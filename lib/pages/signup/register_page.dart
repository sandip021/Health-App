import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart'; // Add this package to your pubspec.yaml

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  String _message = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _ageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    setState(() {
      _message = ''; // Clear previous messages
      _isLoading = true; // Show loading indicator
    });

    if (validateInputs()) {
      try {
        // Create user
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String uid = userCredential.user!.uid;

        // Adding user details including UID as docId
        await addUserDetails(
          uid,
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          int.parse(_ageController.text.trim()),
        );

        if (mounted) {
          setState(() {
            _message = 'Registration successful!';
          });
        }

        // Clear inputs
        _emailController.clear();
        _passwordController.clear();
        _confirmpasswordController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
        _ageController.clear();
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          setState(() {
            _message = e.message ?? 'An error occurred. Please try again.';
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _message = 'An unexpected error occurred. Please try again.';
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  bool validateInputs() {
    final email = _emailController.text.trim();
    if (!EmailValidator.validate(email) || !isValidEmailDomain(email)) {
      setState(() {
        _message = 'Invalid email format.';
      });
      return false;
    }
    if (_passwordController.text.trim() != _confirmpasswordController.text.trim()) {
      setState(() {
        _message = 'Passwords do not match.';
      });
      return false;
    }
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmpasswordController.text.trim().isEmpty ||
        _firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty) {
      setState(() {
        _message = 'All fields are required.';
      });
      return false;
    }
    if (int.tryParse(_ageController.text.trim()) == null) {
      setState(() {
        _message = 'Age must be a valid number.';
      });
      return false;
    }
    return true;
  }

  bool isValidEmailDomain(String email) {
    final domain = email.split('@').last;
    return domain == 'gmail.com'; // Adjust the domain check as needed
  }

  Future<void> addUserDetails(
    String uid, String firstName, String lastName, String email, int age) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('profile')
      .doc('profileData') // This could be a specific document ID for profile data
      .set({
    'first name': firstName,
    'last name': lastName,
    'email': email,
    'age': age,
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 238, 227),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hello There!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Register below with your details!',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 50),

                // Input fields
                buildTextField(_firstNameController, 'First Name'),
                const SizedBox(height: 10),
                buildTextField(_lastNameController, 'Last Name'),
                const SizedBox(height: 10),
                buildTextField(_ageController, 'Age', keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 10),
                buildTextField(_passwordController, 'Password', obscureText: true),
                const SizedBox(height: 10),
                buildTextField(_confirmpasswordController, 'Confirm Password', obscureText: true),
                const SizedBox(height: 10),

                // Sign Up Button
                _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: GestureDetector(
                          onTap: signUp,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 241, 244, 241),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Center(
                                child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            )),
                          ),
                        ),
                      ),

                const SizedBox(height: 25),

                // Message display
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('success') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                // Switch to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('I am a member!',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: const Text(
                        ' Login now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // build text fields
  Widget buildTextField(TextEditingController controller, String hintText, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            border: Border.all(
                color: const Color.fromARGB(255, 152, 167, 155)),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }
}
