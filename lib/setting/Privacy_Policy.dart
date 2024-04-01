import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Privacy Policy",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Your privacy is important to us. This Privacy Policy explains how we collect, use, and disclose your personal information when you use our e-commerce platform (the 'Service').\n\n"
                  "1. Information We Collect\n\n"
                  "1.1. Account Information: When you create an account on our platform, we collect information such as your name, email address, and password.\n\n"
                  "1.2. Order Information: When you make a purchase through our platform, we collect information such as your shipping address, billing address, and payment information.\n\n"
                  "1.3. Usage Information: We collect information about how you interact with our platform, such as the products you view, the pages you visit, and your interactions with other users.\n\n"
                  "2. How We Use Your Information\n\n"
                  "2.1. We use the information we collect to provide, maintain, and improve our platform, including processing orders, personalizing your experience, and analyzing user behavior.\n\n"
                  "2.2. We may also use your information to communicate with you, respond to your inquiries, and provide you with updates and marketing materials.\n\n"
                  "3. Information Sharing and Disclosure\n\n"
                  "3.1. We may share your information with third-party service providers who help us operate our platform and provide services to you, such as payment processors and shipping partners.\n\n"
                  "3.2. We may also share your information in response to legal requests, to protect our rights or property, or to prevent illegal activities.\n\n"
                  "4. Data Retention\n\n"
                  "4.1. We retain your information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.\n\n"
                  "5. Your Choices\n\n"
                  "5.1. You can access, update, or delete your account information by logging into your account settings.\n\n"
                  "5.2. You can opt-out of receiving marketing communications from us by following the instructions provided in the communication.\n\n"
                  "6. Security\n\n"
                  "6.1. We take reasonable measures to protect your information from unauthorized access, disclosure, alteration, or destruction.\n\n"
                  "6.2. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee the absolute security of your information.\n\n"
                  "7. Children's Privacy\n\n"
                  "7.1. Our platform is not directed to children under the age of 13, and we do not knowingly collect personal information from children under the age of 13.\n\n"
                  "8. Changes to This Privacy Policy\n\n"
                  "8.1. We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\n\n"
                  "9. Contact Us\n\n"
                  "9.1. If you have any questions about this Privacy Policy, please contact us at abc@gmail.com.\n\n",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
