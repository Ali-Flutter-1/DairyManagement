import 'package:dairyapp/Auth/forgetPassword/forget_screen.dart';

import 'package:dairyapp/Auth/register/register_screen.dart';
import 'package:dairyapp/screens/BottomNavBar/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../CustomWidets/custom_text_field.dart';
import '../../CustomWidets/custom_toast.dart';
import '../firebase/firebase_auth.dart';
import '../google/google_signin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomBar()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.local_drink_rounded,
                                size: 70, color: Color(0xFF7CB342)),
                            SizedBox(height: 10),
                            Text(
                              "DairyApp",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Font",
                                color: Color(0xFF7CB342),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Login to your account",
                            style: TextStyle(
                              fontSize: 28.0,
                              fontFamily: 'Font',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "It’s great to see you again.",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF808080),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Font',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        CustomTextField(
                          hintText: 'Enter your email address',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          isPassword: false,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Font',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        CustomTextField(
                          hintText: 'Enter your password',
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          isPassword: true,
                        ),

                        // Forgot password link
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Forgot your password? ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Reset your password',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // 🔥 Login Button with Loading Spinner
                        SizedBox(
                          width: size.width,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7CB342),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () async {
                              String email =
                              emailController.text.trim();
                              String password =
                              passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                showCustomToast(context, 'Please fill all required fields',isError: true);
                                return;
                              }

                              setState(() => _isLoading = true);

                              String? result = await AuthService()
                                  .login(email, password,context);

                              setState(() => _isLoading = false);

                              if (result == "Success") {
                                showCustomToast(
                                    context, 'Login Successfully');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BottomBar(),
                                  ),
                                );
                              } else {
                                showCustomToast(context,
                                    result ?? "An unknown error occurred",isError: true);
                              }
                            },
                            child: _isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                                : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 10),
                                height: 1,
                                color: const Color(0xFFE6E6E6),
                              ),
                            ),
                            const Text('Or'),
                            Expanded(
                              child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 10),
                                height: 1,
                                color: const Color(0xFFE6E6E6),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Google Button
                        SizedBox(
                          width: size.width,
                          height: 50,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFCCCCCC)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            icon: Image.asset(
                              "assets/images/google.png",
                              width: 28,
                              height: 28,
                            ),
                            label: const Text(
                              "Login with Google",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Font',
                              ),
                            ),
                            onPressed: () async {
                              // Show loading indicator
                              setState(() => _isLoading = true);

                              var user = await GoogleAuthService().signInWithGoogle(context);

                              setState(() => _isLoading = false);

                              if (user != null) {
                                showCustomToast(context, 'Login Successful');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BottomBar(), // ✅ Dashboard screen
                                  ),
                                );
                              } else {
                                showCustomToast(context, 'Google Sign-In failed',isError: true);
                              }
                            },
                          ),
                        ),

                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don’t have an account? '),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Join',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
          },
        ),
      ),
    );
  }
}
