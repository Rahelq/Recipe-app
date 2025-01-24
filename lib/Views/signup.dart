import 'package:flutter/material.dart';
import 'package:recipe_app/Views/app_main_screen.dart';
import 'package:recipe_app/Widgets/button.dart';
import 'package:recipe_app/Widgets/snackbar.dart';
import 'package:recipe_app/Widgets/text_field.dart';
import '../Services/authentication.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Error message variables
  String nameError = '';
  String emailError = '';
  String passwordError = '';
  String generalError = ''; // General error for all fields

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  // Email validation
  bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  // Password validation
  bool isValidPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) && // At least one uppercase
        RegExp(r'[a-z]').hasMatch(password) && // At least one lowercase
        RegExp(r'[0-9]').hasMatch(password) && // At least one digit
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password); // Special char
  }

  void signupUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Reset error messages
    setState(() {
      nameError = '';
      emailError = '';
      passwordError = '';
      generalError = ''; // Reset general error
    });

    // Check if any field is empty
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        generalError = "All fields are required."; // Set general error
      });
      return;
    }

    // Validate email
    if (!isValidEmail(email)) {
      setState(() {
        emailError = "Please enter a valid email address.";
      });
    }

    // Validate password
    if (!isValidPassword(password)) {
      setState(() {
        passwordError =
            "Password must be at least 8 characters long, include uppercase, lowercase, a number, and a special character.";
      });
    }

    // Proceed only if no errors
    if (emailError.isEmpty && passwordError.isEmpty) {
      setState(() {
        isLoading = true;
      });

      // Call signup method
      String res = await AuthMethod().signupUser(
        email: email,
        password: password,
        name: name,
      );

      // Handle result
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AppMainScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        // Show error message
        showSnackBar(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 2.8,
              child: Image.asset('images/login.jpg'),
            ),
            // Display general error for missing fields
            if (generalError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  generalError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            // Name field with error
            TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Enter your name',
                textInputType: TextInputType.text),
            if (nameError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  nameError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            // Email field with error
            TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.text),
            if (emailError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  emailError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            // Password field with error
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: passwordController,
              hintText: 'Enter your password',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            if (passwordError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  passwordError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            // Sign-Up button
            MyButtons(onTap: signupUser, text: "Sign Up"),

            const SizedBox(height: 50),

            // Login redirect
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    " Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
