// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:woundwise/constants.dart';
import 'package:woundwise/services/storage_services.dart';
import 'package:woundwise/views/introduction/splash_screen.dart';
import 'package:woundwise/views/settings/change_pin_screen.dart';
import 'package:woundwise/views/settings/forget_pin_screen.dart';
import 'package:woundwise/views/settings/notifications_screen.dart';
import 'package:woundwise/views/settings/privacy_policy_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Center(
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // buildSettingsOption(
          //   context,
          //   title: 'Account Management',
          //   onTap: () {},
          // ),
          buildExpandableSettingsOption(context),
          buildSettingsOption(
            context,
            title: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          buildSettingsOption(
            context,
            title: 'Privacy & Security',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          buildLogoutButton(context),
        ],
      ),
    );
  }
}

Widget buildSettingsOption(BuildContext context, {required String title, required Function onTap}) {
  return GestureDetector(
    onTap: () => onTap(),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    ),
  );
}

ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);

Widget buildExpandableSettingsOption(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Theme(
      data: Theme.of(context).copyWith(
        // Override the default arrow icon with desired icon
        expansionTileTheme: const ExpansionTileThemeData(
          collapsedIconColor: Colors.black,
          iconColor: Colors.black,
          collapsedTextColor: Colors.black,
          textColor: Colors.black,
          shape: RoundedRectangleBorder(),
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: isExpanded,
        builder: (BuildContext context, bool value, Widget? child) {
          return ExpansionTile(
            title: const Text("PIN Management", style: TextStyle(fontSize: 16)),
            initiallyExpanded: value,
            onExpansionChanged: (bool expanded) {
              isExpanded.value = expanded;
            },
            trailing: value ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.arrow_forward_ios, size: 16),
            children: <Widget>[
              buildPinOption(
                title: "Change PIN",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePinScreen(),
                    ),
                  );
                },
              ),
              buildPinOption(
                title: "Forgot PIN",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPinScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    ),
  );
}

Widget buildPinOption({required String title, required Function onTap}) {
  return ListTile(
    tileColor: Colors.grey.shade100,
    onTap: () => onTap(),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    // TextButton(
    //   child: const Text(
    //     "Click here",
    //     style: TextStyle(
    //       // decoration: TextDecoration.underline,
    //       color: Colors.blueAccent,
    //     ),
    //   ),
    // ),
  );
}

Widget buildLogoutButton(BuildContext context) {
  return GestureDetector(
    onTap: () async {
      try {
        await StorageServices.logOutUser();
        kShowSnackBar("You have been logged out successfully.");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => route.settings.name == "/",
        );
      } catch (e) {
        kShowSnackBar("Something went wrong. Please try again.");
        debugPrint("debugPrint: $e");
      }
    },
    child: Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.logout, size: 24), // Icon for logout
          SizedBox(width: 8), // Space between icon and text
          Text("Logout", style: TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );
}
