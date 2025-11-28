import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final translator = GoogleTranslator();
  final TextEditingController _controller = TextEditingController();
  String translatedText = '';
  String selectedSourceLanguage = 'en'; // Default source language (English)
  String selectedTargetLanguage = 'bn'; // Default target language (Bangla)

  // List of available languages for translation
  final Map<String, String> languages = {
    'English': 'en',
    'Bangla': 'bn',
    'French': 'fr',
    'Spanish': 'es',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Chinese': 'zh',
    'Japanese': 'ja',
    'Arabic': 'ar',
  };

  // Function to translate text based on selected languages
  void translateText() async {
    var translation = await translator.translate(_controller.text,
        from: selectedSourceLanguage, to: selectedTargetLanguage);
    setState(() {
      translatedText = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translator', style: TextStyle(fontSize: 22)),
        backgroundColor: Color(0xFFA5B68D), // Title background color
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFADB2D4), // Body background color
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Translate your text',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 242, 242, 243),
                ),
              ),
              SizedBox(height: 20),

              // Source Language Dropdown
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: DropdownButton<String>(
                    value: selectedSourceLanguage,
                    isExpanded: true,
                    underline: SizedBox(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    items: languages.keys.map((String language) {
                      return DropdownMenuItem<String>(
                        value: languages[language]!,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSourceLanguage = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Target Language Dropdown
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: DropdownButton<String>(
                    value: selectedTargetLanguage,
                    isExpanded: true,
                    underline: SizedBox(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    items: languages.keys.map((String language) {
                      return DropdownMenuItem<String>(
                        value: languages[language]!,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTargetLanguage = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),

              // TextField for user input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter text here...',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Translate Button
              Center(
                child: ElevatedButton(
                  onPressed: translateText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 60.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Translate',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Translated Text
              if (translatedText.isNotEmpty)
                Center(
                  // This ensures the box is centered within the screen
                  child: Container(
                    width: double
                        .infinity, // Ensures the container takes up full width
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      'Translated: $translatedText',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign
                          .center, // This centers the text inside the container
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
