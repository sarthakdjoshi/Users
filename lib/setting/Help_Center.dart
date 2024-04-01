import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help_Center extends StatefulWidget {
  const Help_Center({super.key});

  @override
  State<Help_Center> createState() => _Help_CenterState();
}

class _Help_CenterState extends State<Help_Center> {
  List<FAQ> faqData = [
    FAQ(
      question: "What countries do you ship to?",
      answer: "We ship to most countries worldwide. However, there may be some restrictions depending on the destination. Please check our shipping policy for more details.",
    ),
    FAQ(
      question: "What is your return/exchange policy?",
      answer: "We accept returns and exchanges within 30 days of purchase. Items must be unused and in the same condition as received. Please refer to our returns and exchanges policy for more information.",
    ),
    FAQ(
      question: "How long will it take to get my order?",
      answer: "Delivery times vary depending on the shipping method chosen and the destination. Please refer to our shipping policy for estimated delivery times.",
    ),
    FAQ(
      question: "What payment methods do you accept?",
      answer: "We accept various payment methods including credit/debit cards, PayPal, and bank transfers. Please check our payment methods page for more details.",
    ),
    FAQ(
      question: "Do you have gift packaging options?",
      answer: "Yes, we offer gift packaging options for select items. You can choose gift packaging during the checkout process.",
    ),
    FAQ(
      question: "How long does order processing take?",
      answer: "Order processing typically takes 1-2 business days. During busy periods, processing times may be slightly longer. Once your order has been processed, you will receive a confirmation email with tracking information.",
    ),
    FAQ(
      question: "How do I cancel/modify an order?",
      answer: "If you need to cancel or modify your order, please contact our customer support team as soon as possible. Orders can only be modified or canceled before they have been shipped.",
    ),
    FAQ(
      question: "How can I track my order?",
      answer: "Once your order has been shipped, you will receive a tracking number via email. You can use this tracking number to track your order on our website or the courier's website.",
    ),
    FAQ(
      question: "What if my order arrives damaged?",
      answer: "If your order arrives damaged, please contact our customer support team immediately. We will arrange for a replacement or refund as necessary.",
    ),
    FAQ(
      question: "Product info Q&A",
      answer: "For specific product information, please refer to the product description on our website. If you have any additional questions, feel free to contact our customer support team.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Center"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: faqData.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    faqData[index].question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        faqData[index].answer,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("Email"),
            subtitle: const Text("your@example.com"),
            onTap: () {
              _launchEmail("your@example.com");
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Call"),
            subtitle: const Text("1234567890"),
            onTap: () {
              _launchPhone("1234567890");
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("Map"),
            subtitle: const Text("1600 Amphitheatre Parkway,Mountain+View,CA"),
            onTap: () {
              _launchMap("1600+Amphitheatre+Parkway,Mountain+View,+CA");
            },
          ),
        ],
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

_launchEmail(String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
  );
  String url = emailLaunchUri.toString();
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchPhone(String phoneNumber) async {
  final Uri phoneLaunchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  String url = phoneLaunchUri.toString();
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchMap(String address) async {
  final Uri mapLaunchUri = Uri(
    scheme: 'geo',
    query: address,
  );
  String url = mapLaunchUri.toString();
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
