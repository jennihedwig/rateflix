import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rateflix/auth/signup_view.dart';
import 'package:rateflix/services/user_service.dart';
import 'package:rateflix/tabs/tab_view.dart';
import 'package:rateflix/theme_data.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginViewState();
  }
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    emailController.addListener(_updateState);
    passwordController.addListener(_updateState);
    emailFocusNode.addListener(_updateState);
    passwordFocusNode.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24.0),
              // Heading
              const Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hello Again!',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Good to see you, we missed you.',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email input field
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text('E-mail'),
                        suffixIcon: emailFocusNode.hasFocus &&
                                emailController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () => emailController.clear(),
                                child: Icon(
                                  CupertinoIcons.clear_circled,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            : null,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte geben Sie eine gültige e-mail an';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password input field
                    TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: const Text('Passwort'),
                        suffixIcon: passwordFocusNode.hasFocus &&
                                passwordController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  isPasswordVisible
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            : null,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte geben Sie ein Passwort ein';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          // Handle password recovery action here
                        },
                        child: Text(
                          'Recover Password',
                          style: TextStyle(
                            color: theme.colorScheme
                                .onSurfaceVariant, // Change color to indicate it's clickable
                            // Optional: underline to show it's clickable
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Login button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          UserService().login({
                            'email': emailController.text,
                            'password': passwordController.text,
                          }).then((data) {
                            print("Login erfolgreich: $data");

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const TabView()),
                            );
                          }).catchError((e) {
                            print("Login fehlgeschlagen: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login fehlgeschlagen")),
                            );
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              //Trenner
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.grey],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "or login with",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              //Google, Apple, Facebook
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color.fromARGB(
                            255, 186, 186, 186), // Light grey border
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize:
                          const Size(60, 60), // Size for square buttons
                    ),
                    child: SvgPicture.asset(
                      'assets/images/google.svg',
                      width: 28,
                      height: 28,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 186, 186, 186),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(60, 60),
                    ),
                    child: const Icon(
                      Icons.apple,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color.fromARGB(255, 186, 186, 186),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(60, 60),
                    ),
                    child: const Icon(
                      Icons.facebook,
                      color: Color(0xFF3b5998),
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              //Signing in
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpView()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'No Account yet? ',
                      style: TextStyle(
                          fontSize: 14, color: theme.colorScheme.onSurface),
                      children: [
                        TextSpan(
                          text: 'Register here',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
