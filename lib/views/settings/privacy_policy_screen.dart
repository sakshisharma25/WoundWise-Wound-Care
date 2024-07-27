import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    const headlineTextStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
    );

    final bodyTextStyle = TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.w400,
      color: Colors.black.withOpacity(0.6),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Privacy & Security',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SmartHeal Privacy and Security Policy',
              style: headlineTextStyle,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Data Collection and Use',
              style: headlineTextStyle,
            ),
            const SizedBox(height: 8.0),
            Text(
              '• SmartHeal collects wound data, including images, measurements, and pH levels, to provide personalized treatment recommendations and track healing progress.',
              style: bodyTextStyle,
            ),
            Text(
              '• This data is securely transmitted to our servers and used solely for the purpose of wound care management. It is not shared with any third parties.',
              style: bodyTextStyle,
            ),
            Text(
              '• Patients have the ability to review, edit, and delete their wound data at any time through the SmartHeal app.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Data Security',
              style: headlineTextStyle,
            ),
            const SizedBox(height: 8.0),
            Text(
              '• All data transmitted through SmartHeal is encrypted end-to-end to protect patient privacy.',
              style: bodyTextStyle,
            ),
            Text(
              '• SmartHeal\'s servers are housed in secure, HIPAA-compliant data centers with strict access controls.',
              style: bodyTextStyle,
            ),
            Text(
              '• We employ the latest security practices to safeguard patient information and prevent unauthorized access or data breaches.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Patient Consent',
              style: headlineTextStyle,
            ),
            const SizedBox(height: 8.0),
            Text(
              '• Patients must provide explicit consent before using the SmartHeal app and sharing their wound data.',
              style: bodyTextStyle,
            ),
            Text(
              '• Patients can withdraw consent at any time and request deletion of their data.',
              style: bodyTextStyle,
            ),
            Text(
              '• SmartHeal will never use patient data for any purpose other than wound care without obtaining additional consent.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Privacy Commitment',
              style: headlineTextStyle,
            ),
            const SizedBox(height: 8.0),
            Text(
              '• Protecting patient privacy is of the utmost importance to SmartHeal. We are committed to maintaining the highest standards of data security and ethical use of sensitive medical information.',
              style: bodyTextStyle,
            ),
            Text(
              '• SmartHeal complies with all applicable privacy regulations, including HIPAA in the United States and similar laws in other countries where we operate.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 16.0),
            Text(
              'For any questions or concerns about our privacy and security practices, please contact our support team at support@smartheal.org.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10.0),
            // Text(
            //   'Click Agree to accept the terms of our Privacy Policy and continue using SmartHeal.',
            //   style: bodyTextStyle,
            // ),
            // const SizedBox(height: 30.0),
            FutureBuilder(
                future: _isAgreed(),
                builder: (context, snapshot) {
                  final style = ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 14.0,
                    ),
                    textStyle: const TextStyle(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  final value = snapshot.data;
                  if (value == null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _setAgreement(false);
                              setState(() {});
                            },
                            style: style.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.grey.shade400,
                              ),
                            ),
                            child: const Text('Disagree'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _setAgreement(true);
                              setState(() {});
                            },
                            style: style.copyWith(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.blue),
                            ),
                            child: const Text('  Agree  '),
                          ),
                        ],
                      ),
                    );
                  }

                  if (value == true) {
                    return const ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        'You agreed to our Privacy Policy.',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.green,
                        ),
                      ),
                    );
                  }
                  if (value == false) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text(
                        'You must agree to our Privacy Policy to continue using SmartHeal.',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.red,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await _setAgreement(true);
                          setState(() {});
                        },
                        style: style.copyWith(
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                          ),
                        ),
                        child: const Text('  Agree  '),
                      ),
                    );
                  }
                  return const SizedBox(height: 0, width: 0);
                }),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  final _kAgreementKey = 'agreement100000';

  Future<bool?> _isAgreed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kAgreementKey);
  }

  Future<bool> _setAgreement(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_kAgreementKey, value);
  }
}
