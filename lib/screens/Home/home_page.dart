import 'dart:io';

import 'package:ChatGemini/globals.dart';
import 'package:ChatGemini/screens/Safety/safety.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ChatGemini/screens/Profile/profile.dart';
import 'package:ChatGemini/widgets/api_integration_widget.dart';
import 'package:ChatGemini/screens/Authentication/LoginOrRegister.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int myIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      USER_NAME_GLOBAL = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    void signUserOut() async {
      await FirebaseAuth.instance.signOut();
    }

    String userEmailString =
        FirebaseAuth.instance.currentUser!.email!.toString();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: [
            IconButton(
              onPressed: () {
                signUserOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginOrRegisterPage(),
                  ),
                );
              },
              icon: Padding(
                padding: const EdgeInsets.only(right: 5.0, top: 15.0),
                child: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              ),
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22.0, left: 50.0),
                child: Image.asset(
                  "lib/assets/logos/image 7.png",
                  height: 50,
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: [
            buildHomePage(userEmailString),
            const Profile(),
            // const SettingsPage(),
            //TODO: Update settings to also show only if platform is android.
            const Safety()
          ],
          onPageChanged: (index) {
            setState(() {
              myIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          fixedColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: const Color.fromRGBO(149, 149, 149, 1),
          onTap: (index) {
            setState(() {
              myIndex = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            });
          },
          currentIndex: myIndex,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.black,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              backgroundColor: Colors.black,
            ),
            if (Platform
                .isAndroid) // Conditionally include the item only on Android
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
                backgroundColor: Colors.black,
              ),
              const BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety),
              label: "Safety",
              backgroundColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHomePage(String userEmailString) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 64.0, left: 16.0, right: 16.0),
          child: Text(
            "Hello $USER_NAME_GLOBAL!",
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Explore and work with the Gemini API!", // Add your subheading text here
            style: TextStyle(
                fontSize: 18.0, color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.left,
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        const Expanded(
          child: ApiIntegrationWidget(),
        ),
      ],
    );
  }
}
