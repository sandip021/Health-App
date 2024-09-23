import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'bmi_chart_page.dart'; // Import the chart page

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  String _bmiResult = '';
  
  // Store BMI values with corresponding dates
  final List<Map<String, dynamic>> _bmiRecords = [];

  // Method to calculate BMI and store it with a timestamp
  void _calculateBMI() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0) {
      final double bmi = weight / (height * height);

      setState(() {
        _bmiResult = 'Your BMI is: ${bmi.toStringAsFixed(2)}';

        // Store the BMI with the current date
        _bmiRecords.add({
          'bmi': bmi,
          'date': DateTime.now(),
        });
      });
    } else {
      setState(() {
        _bmiResult = 'Please enter valid numbers for height and weight';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        backgroundColor: const Color.fromARGB(255, 173, 238, 227),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              // Navigate to the chart page, passing the BMI records
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BMIChartPage(bmiRecords: _bmiRecords),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Calculate Your BMI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height in meters (e.g., 1.75)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight in kilograms (e.g., 70)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 173, 238, 227),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Calculate BMI',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _bmiResult,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),

              // Show BMI history
              if (_bmiRecords.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _bmiRecords.length,
                    itemBuilder: (context, index) {
                      final bmiEntry = _bmiRecords[index];
                      final formattedDate =
                          DateFormat('yyyy-MM-dd – kk:mm').format(bmiEntry['date']);

                      return ListTile(
                        title: Text('BMI: ${bmiEntry['bmi'].toStringAsFixed(2)}'),
                        subtitle: Text('Date: $formattedDate'),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
