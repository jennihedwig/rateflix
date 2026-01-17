// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rateflix/auth/login_view.dart';
import 'package:rateflix/auth/signup_view.dart';
import 'package:rateflix/services/user_service.dart';
import 'package:rateflix/tabs/tab_view.dart';
import 'package:rateflix/theme_data.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final String pathToImage = 'assets/images/authImage2.png';
  final userService = UserService();

  @override
  void initState() {
    super.initState();

    //onPageLoaded();
  }

  void onPageLoaded() async {
    await userService.autoLogin().then((value) {
      print("Auto Login value: $value");
      if (value == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TabView(),
          ),
        );
      } else {
        print("Auto-login failed.");
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Image with wavy clip path
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(pathToImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Text and button section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rateify",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      height: 1, // Adjust this value to control line spacing
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Weil deine Freunde besser sind als jeder Alogrithmus. Schauen - Bewerten - Teilen",
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  // Spacer to push buttons towards the bottom in the remaining space
                  const Spacer(),
                  //Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          fontSize: 18, color: theme.colorScheme.onPrimary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  //Login Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: theme.primaryColor),
                    ),
                  ),
                  const Spacer()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for the wavy effect
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20); // Start point at bottom left

    // Draw the wave with a quadratic bezier curve
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 50,
    );
    path.quadraticBezierTo(
      3 * size.width / 3.5,
      size.height - 110,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0); // Finish at top right
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
