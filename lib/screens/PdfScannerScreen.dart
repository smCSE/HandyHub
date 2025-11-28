import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PdfScannerScreen extends StatefulWidget {
  const PdfScannerScreen({super.key});

  @override
  _PdfScannerScreenState createState() => _PdfScannerScreenState();
}

class _PdfScannerScreenState extends State<PdfScannerScreen> {
  Uint8List? _imageBytes; // For storing image in bytes (web)
  File? _imageFile; // For storing image on mobile
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery (mobile)
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageBytes = null;
      });
    }
  }

  // Pick image from camera (mobile)
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageBytes = null;
      });
    }
  }

  // Pick image from web (using file input)
  Future<void> _pickImageFromWeb() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]!);
      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageBytes = reader.result as Uint8List?;
          _imageFile = null;
        });
      });
    });
  }

  // Remove selected image
  void _removeImage() {
    setState(() {
      _imageBytes = null;
      _imageFile = null;
    });
  }

  // Generate PDF from image
  Future<void> _generatePdf() async {
    if (_imageBytes == null && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first!')),
      );
      return;
    }

    // Create a PDF document
    final pdf = pw.Document();

    // Add an image to the PDF
    if (_imageBytes != null) {
      // For web
      final image = pw.MemoryImage(_imageBytes!);
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Image(image); // Display the image
        },
      ));
    } else if (_imageFile != null) {
      // For mobile
      final image = pw.MemoryImage(await _imageFile!.readAsBytes());
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Image(image); // Display the image
        },
      ));
    }

    // Save the PDF to a file or preview it
    if (kIsWeb) {
      // For web, we display the PDF in a new window
      final pdfData = await pdf.save();
      final blob = html.Blob([pdfData]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'generated.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // For mobile, save the PDF locally
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return pdf.save();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PDF Scanner',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true, // Ensures the title is centered
        backgroundColor: const Color(0xFFA5B68D), // Title background color
      ),
      backgroundColor: const Color(0xFFADB2D4), // Body background color
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Select an image for PDF scan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _imageBytes == null && _imageFile == null
                ? const Text('No image selected')
                : (_imageBytes != null
                    ? Image.memory(_imageBytes!)
                    : Image.file(_imageFile!)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (kIsWeb) {
                      _pickImageFromWeb();
                    } else {
                      _pickImageFromCamera();
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (kIsWeb) {
                      _pickImageFromWeb();
                    } else {
                      _pickImageFromGallery();
                    }
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _imageBytes != null || _imageFile != null
                ? ElevatedButton(
                    onPressed: _removeImage,
                    child: const Text('Remove Selected Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generatePdf,
              child: const Text('Create PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
