import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _designation = "Student";
  String _bankType = "Savings";
  String? _bankFileName;
  final _bankPasswordController = TextEditingController();
  double _income = 50000;
  double _expenses = 20000;
  String _futureGoal = "Save for Education";
  String _currency = "₹ INR";
  String _frequency = "Monthly";
  DateTime? _dob;
  String _employmentStatus = "Employed";

  List<String> currencies = ["₹ INR", "\$ USD", "€ EUR", "£ GBP", "¥ JPY"];
  List<String> frequencies = ["Weekly", "Monthly", "Quarterly", "Yearly"];
  List<String> employmentStatuses = [
    "Employed",
    "Self-Employed",
    "Student",
    "Retired",
    "Unemployed",
  ];

  // Web file picker
  Future<void> pickBankStatement() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.pdf,.csv,.ofx,.qfx';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        setState(() {
          _bankFileName = file.name;
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

  List<String> futureGoals = [
    "Save for Education",
    "Buy a Car",
    "Buy a House",
    "Invest in Business",
    "Retirement Planning",
    "Travel",
    "Emergency Fund",
    "Debt Repayment",
    "Wealth Building",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
          child: Center(
            child: Container(
              width: 800,
              height: MediaQuery.of(context).size.height * 0.85,
              margin: EdgeInsets.all(20),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Progress indicator
                      LinearProgressIndicator(
                        value: (_currentStep + 1) / 5,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2575FC),
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      SizedBox(height: 15),

                      // Step content
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildBasicInfoStep(),
                            _buildDesignationStep(),
                            _buildBankDetailsStep(),
                            _buildFinanceStep(),
                            _buildFinishStep(),
                          ],
                        ),
                      ),

                      // Navigation buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentStep > 0)
                            ElevatedButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                setState(() {
                                  _currentStep--;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_back, size: 18),
                                  SizedBox(width: 5),
                                  Text('Back'),
                                ],
                              ),
                            )
                          else
                            Container(),

                          ElevatedButton(
                            onPressed: () {
                              if (_currentStep < 4) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                setState(() {
                                  _currentStep++;
                                });
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2575FC),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _currentStep == 4 ? 'Get Started' : 'Next',
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  _currentStep == 4
                                      ? Icons.check_circle
                                      : Icons.arrow_forward,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tell us about yourself to personalize your experience',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _dob != null
                        ? '${_dob!.day}/${_dob!.month}/${_dob!.year}'
                        : 'Select your date of birth',
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignationStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Employment Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Help us understand your financial situation better',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          Text(
            "Employment Status",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                employmentStatuses.map((status) {
                  return ChoiceChip(
                    label: Text(status),
                    selected: _employmentStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        _employmentStatus = status;
                      });
                    },
                    selectedColor: Color(0xFF2575FC).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color:
                          _employmentStatus == status
                              ? Color(0xFF2575FC)
                              : Colors.grey[700],
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 30),
          Text("You are a:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Student'),
                  leading: Radio<String>(
                    value: 'Student',
                    groupValue: _designation,
                    onChanged: (value) {
                      setState(() {
                        _designation = value!;
                      });
                    },
                  ),
                  trailing: Icon(Icons.school, color: Colors.grey),
                ),
                Divider(height: 1),
                ListTile(
                  title: const Text('Professional'),
                  leading: Radio<String>(
                    value: 'Professional',
                    groupValue: _designation,
                    onChanged: (value) {
                      setState(() {
                        _designation = value!;
                      });
                    },
                  ),
                  trailing: Icon(Icons.work, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailsStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Bank Account Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Connect your bank for automated financial tracking',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          DropdownButtonFormField<String>(
            value: _bankType,
            items:
                ['Savings', 'Current', 'Salary', 'Fixed Deposit', 'NRI']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (val) {
              setState(() {
                _bankType = val!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Bank Account Type',
              prefixIcon: Icon(Icons.account_balance),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Upload Bank Statement",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Supported formats: PDF, CSV, OFX, QFX",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: pickBankStatement,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    _bankFileName ?? "Drag & Drop or Click to Upload",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  if (_bankFileName != null)
                    Text(
                      "File uploaded successfully!",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _bankPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Bank Statement Password (if applicable)',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Your financial data is encrypted and secure. We never store your banking credentials.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Financial Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Help us create a personalized financial plan for you',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _currency,
                  items:
                      currencies
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _currency = val!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _frequency,
                  items:
                      frequencies
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _frequency = val!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Monthly Income: ${_income.toInt()} $_currency",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _income,
                    min: 0,
                    max: 200000,
                    divisions: 200,
                    label: _income.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        _income = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Monthly Expenses: ${_expenses.toInt()} $_currency",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _expenses,
                    min: 0,
                    max: 200000,
                    divisions: 200,
                    label: _expenses.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        _expenses = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Savings: ${(_income - _expenses).toInt()} $_currency",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${((_income - _expenses) / _income * 100).toStringAsFixed(1)}% of income",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "What are your primary financial goals?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                futureGoals.map((goal) {
                  return FilterChip(
                    label: Text(goal),
                    selected: _futureGoal == goal,
                    onSelected: (selected) {
                      setState(() {
                        _futureGoal = goal;
                      });
                    },
                    selectedColor: Color(0xFF2575FC).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color:
                          _futureGoal == goal
                              ? Color(0xFF2575FC)
                              : Colors.grey[700],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 100, color: Colors.green),
        SizedBox(height: 20),
        Text(
          'Congratulations!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Your financial profile is complete',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        SizedBox(height: 30),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text('Personal Info'),
                  subtitle: Text(
                    '${_nameController.text} • ${_emailController.text}',
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.work, color: Colors.blue),
                  title: Text('Employment'),
                  subtitle: Text('$_employmentStatus • $_designation'),
                ),
                ListTile(
                  leading: Icon(Icons.account_balance, color: Colors.blue),
                  title: Text('Bank Account'),
                  subtitle: Text('$_bankType Account'),
                ),
                ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.blue),
                  title: Text('Financial Summary'),
                  subtitle: Text('Income: $_income • Expenses: $_expenses'),
                ),
                ListTile(
                  leading: Icon(Icons.flag, color: Colors.blue),
                  title: Text('Primary Goal'),
                  subtitle: Text(_futureGoal),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Ready to take control of your finances?',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
