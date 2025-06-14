import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../models/feed.dart';
import '../../services/database/feeddatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/feed_deduction_service.dart';
import 'localisations_en.dart';
import 'localisations_hindi.dart';
import 'localisations_punjabi.dart';


class DryFodderPage extends StatefulWidget {
  // final String uid;
  const DryFodderPage({super.key});

  @override
  State<DryFodderPage> createState() => _DryFodderPageState();
}

class _DryFodderPageState extends State<DryFodderPage> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _otherTypeController = TextEditingController();
  final TextEditingController _weeklyConsumptionController = TextEditingController();

  String? _selectedType;
  String? _selectedSource;
  final List<String> _fodderTypes = ['Wheat Straw', 'Paddy', 'Straw', 'Others'];
  final List<String> _sourceTypes = ['Purchased', 'Own Farm'];
  late Map<String, String> currentLocalization = {};
  late String languageCode = 'en';
  late final FeedDeductionService _feedDeductionService;
  final int _defaultWeeklyConsumption = 10; // Default value for weekly consumption
  late final DatabaseServicesForFeed _dbService;

  @override
  void initState() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    super.initState();
    if (kDebugMode) {
      print('DryFodderPage initState called');
    }
    _dbService = DatabaseServicesForFeed(uid!);
    _feedDeductionService = FeedDeductionService(uid);
    _weeklyConsumptionController.text = _defaultWeeklyConsumption.toString(); // Set default consumption value
  }

  Future<void> _submitData() async {
    final type = _selectedType == 'Others' ? _otherTypeController.text : _selectedType;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unit = _unitController.text;
    final rate = _rateController.text;
    final price = _priceController.text;
    final brand = _brandController.text;
    final source = _selectedSource;
    final weeklyConsumption = int.tryParse(_weeklyConsumptionController.text) ?? _defaultWeeklyConsumption;

    final newFeed = Feed(
      itemName: type ?? '',
      quantity: quantity,
      Type:'Dry Fodder',
      requiredQuantity: weeklyConsumption,
    );

    await _dbService.infoToServerFeed(newFeed);

    // Schedule weekly deduction from total quantity
    _feedDeductionService.scheduleWeeklyDeduction(newFeed);

    if (kDebugMode) {
      print('Data saved: Type: $type, Quantity: $quantity $unit, Rate: $rate, Price: $price, Brand: $brand, Source: $source, Weekly Consumption: $weeklyConsumption');
    }
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
          currentLocalization['Dry Fodder'] ?? 'Dry Fodder',
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              _buildTypeDropdown(),
              if (_selectedType == 'Others') ...[
                const SizedBox(height: 20),
                _buildTextField(_otherTypeController, 'Custom Type'),
              ],
              const SizedBox(height: 20),
              _buildSourceDropdown(),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              _buildTextField(_weeklyConsumptionController, 'Weekly Consumption', readOnly: false),
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

  // Helper method to create input fields
  Widget _buildTextField(TextEditingController controller, String label, {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: currentLocalization[label] ?? label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      ),
      style: const TextStyle(fontSize: 14.0),
    );
  }

  // Dropdown for fodder type
  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: currentLocalization['Type'] ?? 'Type',
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      ),
      items: _fodderTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(currentLocalization[type] ?? type),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value;
        });
      },
    );
  }

  // Dropdown for source type
  Widget _buildSourceDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSource,
      decoration: InputDecoration(
        labelText: currentLocalization['Source'] ?? 'Source',
        labelStyle: const TextStyle(color: Colors.black54, fontSize: 14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      ),
      items: _sourceTypes.map((source) {
        return DropdownMenuItem(
          value: source,
          child: Text(currentLocalization[source] ?? source),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSource = value;
        });
      },
    );
  }
}
