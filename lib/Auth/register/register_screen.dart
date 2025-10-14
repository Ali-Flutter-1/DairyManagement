import 'package:dairyapp/Auth/firebase/firebase_auth.dart';
import 'package:dairyapp/Auth/login/login_screen.dart';
import 'package:dairyapp/screens/BottomNavBar/bottom_nav.dart';
import 'package:flutter/material.dart';
import '../../CustomWidets/custom_text_field.dart';
import '../../CustomWidets/custom_toast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  bool _isLoading = false; // loading flag

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // 🧈 Logo
                      Column(
                        children: const [
                          Icon(Icons.local_drink_rounded,
                              size: 70, color: Color(0xFF7CB342)),
                          SizedBox(height: 10),
                          Text(
                            "DairyApp",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7CB342),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Create an account",
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Let's create your account.",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      // Email field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Enter your email address',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: false,
                      ),

                      // Password field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Enter your password',
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        isPassword: true,
                      ),

                      // Confirm Password field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Confirm Password",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      CustomTextField(
                        hintText: 'Re-enter your password',
                        controller: confirmController,
                        keyboardType: TextInputType.text,
                        isPassword: true,
                      ),

                      const SizedBox(height: 20),

                      // ✅ Replaced CustomButton with Built-in ElevatedButton
                      SizedBox(
                        width: size.width,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7CB342),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                            String email = emailController.text.trim();
                            String password =
                            passwordController.text.trim();
                            String confirmPassword =
                            confirmController.text.trim();

                            if (email.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty) {
                              showCustomToast(
                                  context, 'Please fill all fields',isError: true);
                              return;
                            }

                            if (password != confirmPassword) {
                              showCustomToast(
                                  context, 'Passwords do not match!',isError: true);
                              return;
                            }

                            setState(() => _isLoading = true);
                            String? result = await AuthService()
                                .signUp(email, password, confirmPassword,
                                context);

                            setState(() => _isLoading = false);

                            if (result == "Success") {
                              showCustomToast(
                                  context, "Sign Up successful!");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BottomBar()),
                              );
                            } else {
                              showCustomToast(context,
                                  result ?? "An unknown error occurred",isError: true);
                            }
                          },
                          child: _isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)
                              : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: Colors.grey.shade300, thickness: 1)),
                          const Text(" Or "),
                          Expanded(
                              child: Divider(
                                  color: Colors.grey.shade300, thickness: 1)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Google Button
                      SizedBox(
                        width: size.width,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Image.asset("assets/images/google.png",
                              width: 28, height: 28),
                          label: const Text(
                            "Sign up with Google",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Already have account
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? '),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginScreen()),
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF7CB342),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
