import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rateflix/auth/login_view.dart';
import 'package:rateflix/tabs/tab_view.dart';
import 'package:rateflix/theme_data.dart';
import 'package:rateflix/services/user_service.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpViewState();
  }
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode firstnameFocusNode = FocusNode();
  final FocusNode lastnameFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode birthDateFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  DateTime now = DateTime.now();
  late DateTime today;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  UserService userService = UserService();

  @override
  void initState() {
    super.initState();

    firstnameController.addListener(_updateState);
    lastnameController.addListener(_updateState);
    usernameController.addListener(_updateState);
    emailController.addListener(_updateState);
    birthDateController.addListener(_updateState);
    passwordController.addListener(_updateState);
    confirmPasswordController.addListener(_updateState);
    firstnameFocusNode.addListener(_updateState);
    lastnameFocusNode.addListener(_updateState);
    usernameFocusNode.addListener(_updateState);
    emailFocusNode.addListener(_updateState);
    birthDateFocusNode.addListener(_updateState);
    passwordFocusNode.addListener(_updateState);
    confirmPasswordFocusNode.addListener(_updateState);

    today = DateTime(now.year, now.month, now.day);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    birthDateController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstnameFocusNode.dispose();
    lastnameFocusNode.dispose();
    usernameFocusNode.dispose();
    emailFocusNode.dispose();
    birthDateFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  /* signUp() async {
    
      await userService.testEndpoint();
    
  } */

  signUp() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> userData = {
        "username": usernameController.text,
        "dateOfBirth": birthDateController.text,
        "email": emailController.text,
        "password": passwordController.text
      };

      print("userData: $userData");

      await userService.signUp(userData).then(
            (value) => login(userData),
          );
    }
  }

  login(credentials) async {
    if (_formKey.currentState!.validate()) {
      await userService.login(credentials).then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TabView(),
              ),
            ),
          );
    }
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
                      'Create Account',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Start organizing and sharing your tasks!',
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
                    // Username input field
                    CupertinoTextField(
                      placeholder: "Username",
                      controller: usernameController,
                      focusNode: usernameFocusNode,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      keyboardType: TextInputType.text,
                    ),
                    //Email input
                    const SizedBox(height: 16),
                    CupertinoTextField(
                      placeholder: "Email",
                      controller: emailController,
                      focusNode: emailFocusNode,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    //Birthday
                    CupertinoTextField(
                      placeholder: "Birthdate",
                      controller: birthDateController,
                      focusNode: birthDateFocusNode,
                      readOnly: true, // verhindert Tastatur
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        await showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 250,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  // Done-Button oben rechts
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.all(8),
                                    child: CupertinoButton(
                                      child: const Text("Fertig"),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                  Expanded(
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.date,
                                      minimumDate: DateTime(1920),
                                      maximumDate: today,
                                      initialDateTime: today,
                                      onDateTimeChanged: (DateTime newDate) {
                                        birthDateController.text =
                                            "${newDate.day}.${newDate.month}.${newDate.year}";
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    // Password input field
                    CupertinoTextField(
                      placeholder: "Password",
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      suffix: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          isPasswordVisible
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      obscureText: !isPasswordVisible,
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password input field
                    // Confirm Password input field
                    CupertinoTextField(
                      placeholder: "Confirm password",
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocusNode,
                      suffix: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          isConfirmPasswordVisible
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      obscureText: !isConfirmPasswordVisible,
                    ),
                    const SizedBox(height: 32),
                    // Sign Up button
                    ElevatedButton(
                      onPressed: () {
                        signUp();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(
                        "Sign Up",
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
                      "or sign up with",
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
              //No Accout yet? Register here
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                          fontSize: 14, color: theme.colorScheme.onSurface),
                      children: [
                        TextSpan(
                          text: 'Login here',
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
