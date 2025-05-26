import 'package:flutter/material.dart';
import 'package:farm_expense_mangement_app/screens/authenticate/phoneno.dart';
import '../home/localisations_en.dart';
import '../home/localisations_hindi.dart';
import '../home/localisations_punjabi.dart';
import 'package:provider/provider.dart';
import 'package:farm_expense_mangement_app/main.dart';
class DairyMitraRegistrationPage extends StatefulWidget {
  const DairyMitraRegistrationPage({super.key});

  @override
  _DairyMitraRegistrationPageState createState() =>
      _DairyMitraRegistrationPageState();
}

class _DairyMitraRegistrationPageState
    extends State<DairyMitraRegistrationPage> {
  String? selectedOption;
  late Map<String, String> currentLocalization= {};
  late String languageCode = 'en';



  @override
  Widget build(BuildContext context) {
    languageCode = Provider.of<AppData>(context).persistentVariable;
    print(languageCode);

    if (languageCode == 'en') {
      currentLocalization = LocalizationEn.translations;
    } else if (languageCode == 'hi') {
      currentLocalization = LocalizationHi.translations;
    } else if (languageCode == 'pa') {
      currentLocalization = LocalizationPun.translations;
    }
    print(currentLocalization["Register a new farm"]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22, // Adjusted font size
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20), // Spacing from the top

            // "DairyMitra Registration" text
            const Text(
              'DairyMitra Registration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10), // Space between title and subtitle

            // Subtitle text
            const Text(
              'Get started with your farm management journey',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40), // Space before the buttons

            // "Register a New Farm" button
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedOption = 'Register a New Farm';
                });
              },
              child: Container(
                width: double.infinity, // Full width
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                margin: const EdgeInsets.only(bottom: 20), // Space between buttons
                decoration: BoxDecoration(
                  color: selectedOption == 'Register a New Farm'
                      ? Colors.grey.shade200
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12), // Curved edges
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Slight shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Text(
                      currentLocalization['Register a New Farm']??"",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (selectedOption == 'Register a New Farm')
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0EA6BB), // Blue background
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white, // White checkmark
                        ),
                      ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),

            // "Join an Existing Farm" button
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedOption = 'Join an Existing Farm';
                });
              },
              child: Container(
                width: double.infinity, // Full width
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: selectedOption == 'Join an Existing Farm'
                      ? Colors.grey.shade200
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12), // Curved edges
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Slight shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Text(
                      'Join an Existing Farm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (selectedOption == 'Join an Existing Farm')
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0EA6BB), // Blue background
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white, // White checkmark
                        ),
                      ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),

            if (selectedOption != null)
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SizedBox(
                  width: double.infinity, // Full width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA6BB), // Confirm button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Curved edges
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () {
                      // Handle confirm action
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}