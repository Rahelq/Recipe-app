import 'package:flutter/material.dart';
import 'package:recipe_app/Views/app_main_screen.dart';
import 'package:recipe_app/Widgets/button.dart';
import 'package:recipe_app/Widgets/snackbar.dart';
import 'package:recipe_app/Widgets/text_field.dart';
import '../Services/authentication.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";
  String emailError = "";
  String passwordError = "";
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Reset errors before new validation
    setState(() {
      errorMessage = "";
      emailError = "";
      passwordError = "";
    });

    // Check if fields are empty
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "All fields are required"; // Show general error
      });
      return;
    }

    // Email format validation
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      setState(() {
        emailError =
            "Please enter a valid email address"; // Show email validation error
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Attempt to log in
    String res = await AuthMethod().loginUser(email: email, password: password);

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AppMainScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      if (res == "invalid credentials" || res == "credentials malformed") {
        setState(() {
          errorMessage =
              "Incorrect email or password"; // Show incorrect credentials error
        });
      } else {
        showSnackBar(context, res); // Show other error messages from backend
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height / 2.7,
                child: Image.asset('images/login.jpg'),
              ),
              // Display the error message if present
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              // Email input field
              TextFieldInput(
                icon: Icons.person,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              // Display email validation error
              if (emailError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    emailError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              // Password input field
              TextFieldInput(
                isPass: true,
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
              ),
              // Display password validation error
              if (passwordError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    passwordError,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              // Forgot password link
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              // Login button
              MyButtons(onTap: loginUser, text: "Log In"),
              SizedBox(height: height / 15),
              // Divider with "or" in the middle
              Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: Colors.black26),
                  ),
                  const Text("  or  "),
                  Expanded(
                    child: Container(height: 1, color: Colors.black26),
                  ),
                ],
              ),
              // Sign-up redirect link
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show a snackbar for other backend errors
  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }
}
