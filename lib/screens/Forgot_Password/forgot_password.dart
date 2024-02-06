// ignore_for_file: deprecated_member_use

import 'package:ChatGemini/Components/button.dart';
import 'package:ChatGemini/Components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _resetPassword() async {
    try {
      String email = _emailController.text;
      await _auth.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent to $email'),
        ),
      );
    } catch (e) {
      // Handle any errors that occurred during the password reset process.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Row(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 70, top: 10),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Image.asset(
              'lib/assets/logos/PaLM Logo.png',
              width: 75,
              height: 75,
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Reset Your Password",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "We Will Send You An Email \n To Reset Your Password",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 50),
            MyTextField(
              controller: _emailController,
              hintText: "Your Registered Email",
              obscureText: false,
            ),
            SizedBox(height: 20),
            MyButton(
              text: 'Reset',
              onTap: _resetPassword,
            ),
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Facing Issues?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onLongPress: () async {
                  final emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'prabir.kalwani@gmail.com',
                    queryParameters: {
                      'subject': 'Issue with login',
                    },
                  );
                  final String emailLaunchUriString = emailLaunchUri.toString();

                  if (await canLaunch(emailLaunchUriString)) {
                    await launch(emailLaunchUriString);
                  } else {
                    throw 'Could not launch email app for prabir.kalwani@gmail.com';
                  }
                },
                child: const Text(
                  "Support",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
