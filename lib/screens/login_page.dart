import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'poultry_dashboard_page.dart';
import 'pig_dashboard_page.dart';
import '../utils/translations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLocaleChange});

  final Function(Locale) onLocaleChange;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  // Login controllers
  final _loginNameController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Sign-up controllers
  final _signUpNameController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();
  final _signUpFarmSizeController = TextEditingController();
  final _signUpContactController = TextEditingController();
  final _signUpStateController = TextEditingController();
  final _signUpCityController = TextEditingController();

  // Farm type selection
  String? _selectedFarmType;

  final List<String> _units = [
    'Acres',
    'Hectares',
    'Bigha',
    'Square meters',
    'Square feet',
    'Kanal',
    'Marla',
    'Guntha',
    'Rood',
    'Square yards',
    'Square kilometers',
    'Hectare (ha)'
  ];

  String _selectedUnit = 'Acres';
  bool _isSignUp = false;

  // Password visibility
  bool _obscureCreatePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscureLoginPassword = true;

  // Language selector
  String _selectedLanguage = 'en';
  final Map<String, String> _languageMap = {
    'en': 'English',
    'hi': 'हिन्दी',
    'pa': 'ਪੰਜਾਬੀ',
    'ta': 'தமிழ்',
    'as': 'অসমীয়া',
    'bn': 'বাংলা',
    'gu': 'ગુજરાતી',
    'mr': 'मराठी',
    'te': 'తెలుగు',
    'ur': 'اردو',
    'or': 'ଓଡିଆ',
    'ml': 'മലയാളം',
    'kn': 'ಕನ್ನಡ',
  };

  final Map<String, double> _toAcres = {
    'Acres': 1,
    'Hectares': 2.47105,
    'Bigha': 0.6195,
    'Square meters': 0.000247105,
    'Square feet': 2.2957e-5,
    'Kanal': 0.125,
    'Marla': 0.003125,
    'Guntha': 0.025,
    'Rood': 0.25,
    'Square yards': 2.066e-5,
    'Square kilometers': 247.105,
    'Hectare (ha)': 2.47105,
  };

  void _convertUnitValue(String newUnit) {
    double? currentValue = double.tryParse(_signUpFarmSizeController.text);
    if (currentValue == null) {
      setState(() => _selectedUnit = newUnit);
      return;
    }
    double valueInAcres = currentValue * (_toAcres[_selectedUnit] ?? 1);
    double newValue = valueInAcres / (_toAcres[newUnit] ?? 1);
    _signUpFarmSizeController.text = newValue.toStringAsFixed(2);
    setState(() => _selectedUnit = newUnit);
  }

  // ✅ LOGIN FUNCTION
  void _login() {
    if (_loginFormKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PoultryDashboardPage(
            onLocaleChange: widget.onLocaleChange,
            userName: _loginNameController.text, // 👈 FIXED
            farmSizeWithUnit: "",
          ),
        ),
      );
    }
  }

  // ✅ SIGN UP FUNCTION
  void _signUp() {
    if (_signUpFormKey.currentState!.validate()) {
      if (_signUpPasswordController.text !=
          _signUpConfirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(getTranslatedText("Password Mismatch", _selectedLanguage)),
        ));
        return;
      }

      String farmSizeWithUnit =
          "${_signUpFarmSizeController.text} $_selectedUnit";

      if (_selectedFarmType == "Pig Farm") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PigDashboardPage(
              onLocaleChange: widget.onLocaleChange,
              userName: _signUpNameController.text, // 👈 FIXED
              farmSizeWithUnit: farmSizeWithUnit,
            ),
          ),
        );
      } else if (_selectedFarmType == "Poultry Farm") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PoultryDashboardPage(
              onLocaleChange: widget.onLocaleChange,
              userName: _signUpNameController.text, // 👈 FIXED
              farmSizeWithUnit: farmSizeWithUnit,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(getTranslatedText("Select Farm Type", _selectedLanguage)),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Card(
                elevation: 12,
                shadowColor: Colors.black38,
                color: const Color(0xFFFFFDD0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: DropdownButton<String>(
                          value: _selectedLanguage,
                          items: _languageMap.entries
                              .map((e) => DropdownMenuItem(
                                  value: e.key, child: Text(e.value)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedLanguage = value);
                              widget.onLocaleChange(Locale(value));
                            }
                          },
                        ),
                      ),
                      _isSignUp ? _buildSignUpForm() : _buildLoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            getTranslatedText("Login", _selectedLanguage),
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _loginNameController,
            icon: Icons.person,
            label: getTranslatedText("Name", _selectedLanguage),
            validatorMsg: getTranslatedText("Enter Name", _selectedLanguage),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
              controller: _loginPasswordController,
              icon: Icons.lock,
              label: getTranslatedText("Password", _selectedLanguage),
              validatorMsg:
                  getTranslatedText("Enter Password", _selectedLanguage),
              obscureText: _obscureLoginPassword,
              toggleObscure: () {
                setState(() => _obscureLoginPassword = !_obscureLoginPassword);
              }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 6),
              child: Text(getTranslatedText("Login", _selectedLanguage),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow)),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() => _isSignUp = true),
            child: Text(getTranslatedText("Sign Up", _selectedLanguage),
                style: const TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            getTranslatedText("Sign Up", _selectedLanguage),
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green),
          ),
          const SizedBox(height: 24),

          // Name
          _buildTextField(
            controller: _signUpNameController,
            icon: Icons.person,
            label: getTranslatedText("Name", _selectedLanguage),
            validatorMsg: getTranslatedText("Enter Name", _selectedLanguage),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
            ],
          ),
          const SizedBox(height: 16),

          // Phone
          _buildTextField(
            controller: _signUpContactController,
            icon: Icons.phone,
            label: getTranslatedText("Phone Number", _selectedLanguage),
            validatorMsg:
                getTranslatedText("Enter Phone Number", _selectedLanguage),
            keyboardType: TextInputType.phone,
            isPhone: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          const SizedBox(height: 16),

          // State
          _buildTextField(
            controller: _signUpStateController,
            icon: Icons.map,
            label: getTranslatedText("State", _selectedLanguage),
            validatorMsg: getTranslatedText("Enter State", _selectedLanguage),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
            ],
          ),
          const SizedBox(height: 16),

          // City
          _buildTextField(
            controller: _signUpCityController,
            icon: Icons.location_city,
            label: getTranslatedText("City", _selectedLanguage),
            validatorMsg: getTranslatedText("Enter City", _selectedLanguage),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
            ],
          ),
          const SizedBox(height: 16),

          // Farm Type Dropdown
          DropdownButtonFormField<String>(
            value: _selectedFarmType,
            items: const [
              DropdownMenuItem(
                value: "Pig Farm",
                child: Text("Pig Farm", style: TextStyle(color: Colors.black)),
              ),
              DropdownMenuItem(
                value: "Poultry Farm",
                child:
                    Text("Poultry Farm", style: TextStyle(color: Colors.black)),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFarmType = value;
              });
            },
            dropdownColor: const Color(0xFFFFFDD0),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.agriculture, color: Colors.green.shade700),
              labelText: getTranslatedText("Farm Type", _selectedLanguage),
              labelStyle: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
              filled: true,
              fillColor: const Color(0xFFFFFDD0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade400, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade700, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return getTranslatedText("Enter Farm Type", _selectedLanguage);
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Passwords
          _buildTextField(
              controller: _signUpPasswordController,
              icon: Icons.lock,
              label: getTranslatedText("Create Password", _selectedLanguage),
              validatorMsg:
                  getTranslatedText("Create Password", _selectedLanguage),
              obscureText: _obscureCreatePassword,
              toggleObscure: () => setState(
                  () => _obscureCreatePassword = !_obscureCreatePassword)),
          const SizedBox(height: 16),

          _buildTextField(
              controller: _signUpConfirmPasswordController,
              icon: Icons.lock,
              label: getTranslatedText("Confirm Password", _selectedLanguage),
              validatorMsg:
                  getTranslatedText("Confirm Password", _selectedLanguage),
              obscureText: _obscureConfirmPassword,
              toggleObscure: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword)),
          const SizedBox(height: 16),

          // Farm Size
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: _signUpFarmSizeController,
                  icon: Icons.landscape,
                  label: getTranslatedText("Farm Size", _selectedLanguage),
                  validatorMsg:
                      getTranslatedText("Enter Farm Size", _selectedLanguage),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  value: _selectedUnit,
                  isExpanded: true,
                  dropdownColor: const Color(0xFFFFFDD0),
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null && value != _selectedUnit) {
                      _convertUnitValue(value);
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFFFFDD0),
                    labelText: getTranslatedText("Unit", _selectedLanguage),
                    labelStyle: const TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.green.shade400, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.green.shade700, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Submit
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 6),
              child: Text(getTranslatedText("Sign Up", _selectedLanguage),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow)),
            ),
          ),
          const SizedBox(height: 16),

          TextButton(
            onPressed: () => setState(() => _isSignUp = false),
            child: Text(getTranslatedText("Back To Login", _selectedLanguage),
                style: const TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String validatorMsg,
    TextInputType keyboardType = TextInputType.text,
    bool isPhone = false,
    bool obscureText = false,
    VoidCallback? toggleObscure,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.green.shade700),
                onPressed: toggleObscure,
              )
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.green.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return validatorMsg;
        if (isPhone && !RegExp(r'^\d{10}$').hasMatch(value)) {
          return getTranslatedText("Enter Valid Contact", _selectedLanguage);
        }
        if (!isPhone &&
            keyboardType == TextInputType.text &&
            !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
          return getTranslatedText("Invalid Name", _selectedLanguage);
        }
        return null;
      },
    );
  }
}