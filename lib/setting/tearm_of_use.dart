import 'package:flutter/material.dart';

class Tearm_of_Use extends StatefulWidget {
  const Tearm_of_Use({super.key});

  @override
  State<Tearm_of_Use> createState() => _Tearm_of_UseState();
}

class _Tearm_of_UseState extends State<Tearm_of_Use> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms Of Use"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Terms of Use",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "1. Account Registration\n\n"
                  "1.1. To access certain features of the Platform, you may be required to register for an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.\n\n"
                  "2. Use of the Platform\n\n"
                  "2.1. You agree to use the Platform solely for lawful purposes and in accordance with these Terms.\n\n"
                  "3. Product Listings and Sales\n\n"
                  "3.1. Sellers are solely responsible for the accuracy, completeness, and legality of their product listings and for ensuring that their products comply with all applicable laws and regulations.\n\n"
                  "4. Payment and Checkout\n\n"
                  "4.1. Payment for products purchased through the Platform must be made using the payment methods accepted by the seller.\n\n"
                  "5. Shipping and Delivery\n\n"
                  "5.1. Sellers are responsible for shipping products to buyers in a timely manner and for providing accurate shipping information.\n\n"
                  "6. Returns and Refunds\n\n"
                  "6.1. Sellers are responsible for establishing their own return and refund policies, which must comply with all applicable laws and regulations.\n\n"
                  "7. Intellectual Property\n\n"
                  "7.1. The Platform and its contents, including but not limited to text, graphics, logos, and images, are the property of the Company or its licensors and are protected by copyright, trademark, and other intellectual property laws.\n\n"
                  "8. Privacy Policy\n\n"
                  "8.1. Your use of the Platform is subject to our Privacy Policy, which governs the collection, use, and disclosure of your personal information. By using the Platform, you consent to the terms of our Privacy Policy.\n\n"
                  "9. Limitation of Liability\n\n"
                  "9.1. To the fullest extent permitted by law, the Company shall not be liable for any direct, indirect, incidental, special, consequential, or punitive damages arising out of or in connection with your use of the Platform or these Terms.\n\n"
                  "10. Governing Law\n\n"
                  "10.1. These Terms shall be governed by and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law principles.\n\n",
              style: TextStyle(
                fontSize: 16.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
