import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../models/feed.dart';
import '../../services/database/feeddatabase.dart';
import '../../services/feed_deduction_service.dart';
import 'localisations_en.dart';
import 'localisations_hindi.dart';
import 'localisations_punjabi.dart';

class ConcentratePage extends StatefulWidget {
  const ConcentratePage({super.key});

  @override
  State<ConcentratePage> createState() => _ConcentratePageState();
}

class _ConcentratePageState extends State<ConcentratePage> {
  // TextEditingControllers to handle input
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _customHomemadeController = TextEditingController();
  final TextEditingController _customPurchasedController = TextEditingController();
  final TextEditingController _weeklyConsumptionController = TextEditingController();


  String _selectedType = 'Homemade'; // Default value
  String _selectedHomemadeType = 'Mustard'; // Default value for homemade types
  String _selectedPurchasedType = 'Brand Name'; // Default value for purchased types
  late final FeedDeductionService _feedDeductionService;
  final int _defaultWeeklyConsumption = 10; // Default value for weekly consumption
  late final DatabaseServicesForFeed _dbService;
  late Map<String, String> currentLocalization = {};
  late String languageCode = 'en';

  // List of dropdown items
  final List<String> _homemadeTypes = [
    'Mustard',
    'Maize',
    'Barley',
    'De-Oiled Rice Bran',
    'Soyabean',
    'Wheat Bran',
    'DCP',
    'LSP',
    'Salt',
    'Sodium Bicarbonate',
    'Nicen',
    'Urea',
    'Mineral Mixture',
    'Others'
  ];

  final List<String> _purchasedTypes = [
    'Brand Name',
    'Type'
  ];

  @override
  void initState() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    super.initState();
    if (kDebugMode) {
      print('Concentrate initState called');
    }
    _dbService = DatabaseServicesForFeed(uid!);
    _feedDeductionService = FeedDeductionService(uid);
    _weeklyConsumptionController.text = _defaultWeeklyConsumption.toString(); // Set default consumption value
  }

  @override
  Widget build(BuildContext context) {
    languageCode = Provider.of<AppData>(context).persistentVariable;

    if (languageCode == 'en') {
      currentLocalization = LocalizationEn.translations;
    } else if (languageCode == 'hi') {
      currentLocalization = LocalizationHi.translations;
    } else if (languageCode == 'pa') {
      currentLocalization = LocalizationPun.translations;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          currentLocalization['Concentrate'] ?? 'Concentrate',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(4, 142, 161, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildDropdown(
                value: _selectedType,
                items: ['Homemade', 'Purchased'],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    // Reset specific type values based on the selected type
                    if (_selectedType == 'Homemade') {
                      _selectedPurchasedType = 'Brand Name'; // Reset purchased type if homemade is selected
                      _customPurchasedController.clear(); // Clear custom input if switching to Homemade
                    } else if (_selectedType == 'Purchased') {
                      _selectedHomemadeType = 'Mustard'; // Reset homemade type if purchased is selected
                      _customHomemadeController.clear(); // Clear custom input if switching to Purchased
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_selectedType == 'Homemade') ...[
                _buildDropdown(
                  value: _selectedHomemadeType,
                  items: _homemadeTypes,
                  onChanged: (value) {
                    setState(() {
                      _selectedHomemadeType = value!;
                      if (_selectedHomemadeType == 'Others') {
                        _customHomemadeController.text = ''; // Clear custom input when 'Others' is selected
                      }
                    });
                  },
                ),
                if (_selectedHomemadeType == 'Others') ...[
                  const SizedBox(height: 20),
                  _buildTextField(_customHomemadeController, 'Enter Custom Homemade Type'),
                ],
              ] else if (_selectedType == 'Purchased') ...[
                _buildDropdown(
                  value: _selectedPurchasedType,
                  items: _purchasedTypes,
                  onChanged: (value) {
                    setState(() {
                      _selectedPurchasedType = value!;
                      if (_selectedPurchasedType == 'Brand Name') {
                        _customPurchasedController.text = ''; // Clear custom input when 'Brand Name' is selected
                      }
                    });
                  },
                ),
                if (_selectedPurchasedType == 'Type') ...[
                  const SizedBox(height: 20),
                  _buildTextField(_customPurchasedController, 'Enter Custom Purchased Type'),
                ],
              ],
              const SizedBox(height: 20),
              // Row containing Quantity and Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(_quantityController, 'Quantity'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: _buildTextField(_unitController, 'Unit (e.g., kg)'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField(_rateController, 'Rate per Unit (if Purchased)'),
              const SizedBox(height: 20),
              _buildTextField(_priceController, 'Price (if Purchased)'),
              const SizedBox(height: 20),
              _buildTextField(_brandController, 'Brand Name (if Purchased)'),
              const SizedBox(height: 40),
              _buildTextField(_weeklyConsumptionController, 'Weekly Consumption', readOnly:false),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _submitData();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(4, 142, 161, 1.0),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create dropdown
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(currentLocalization[item] ?? item),
        );
      }).toList(),
      isExpanded: true,
    );
  }

  // Helper method to create input fields with smaller size
  Widget _buildTextField(TextEditingController controller, String label, {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: currentLocalization[label] ?? label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      ),
      style: const TextStyle(fontSize: 14.0),
    );
  }

  // Method to handle form submission
  Future<void> _submitData() async {
    final type = _selectedHomemadeType == 'Others' ? _customHomemadeController.text : _selectedHomemadeType;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unit = _unitController.text;
    final rate = _rateController.text;
    final price = _priceController.text;
    final brand = _brandController.text;
    final customHomemade = _customHomemadeController.text;
    final customPurchased = _customPurchasedController.text;
    final weeklyConsumption = int.tryParse(_weeklyConsumptionController.text) ?? _defaultWeeklyConsumption;


    if (kDebugMode) {
      print('Type: $_selectedType');
    }
    if (_selectedType == 'Homemade') {
      if (kDebugMode) {
        print('Homemade Type: $_selectedHomemadeType');
      }
      if (_selectedHomemadeType == 'Others') {
        if (kDebugMode) {
          print('Custom Homemade Type: $customHomemade');
        }
      }
    } else if (_selectedType == 'Purchased') {
      if (kDebugMode) {
        print('Purchased Type: $_selectedPurchasedType');
      }
      if (_selectedPurchasedType == 'Type') {
        if (kDebugMode) {
          print('Custom Purchased Type: $customPurchased');
        }
      }
    }

    final newFeed = Feed(
      itemName: type ?? '',
      quantity: quantity,
      Type:'Concentrate',
      requiredQuantity: weeklyConsumption,
    );


    await _dbService.infoToServerFeed(newFeed);

    // Schedule weekly deduction from total quantity
    _feedDeductionService.scheduleWeeklyDeduction(newFeed);

    if (kDebugMode) {
      print('Quantity: $quantity $unit, Rate: $rate, Price: $price, Brand: $brand');
    }
  }
}