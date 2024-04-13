import 'package:flutter/material.dart';

void main() {
  runApp(ContactScreen());
}

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 131, 106, 187),
        appBar: AppBar(
          title: Text('Contact Us'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color.fromARGB(255, 131, 106, 187),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ContactInfo(
                icon: Icons.phone,
                text: '123-456-7890',
              ),
              SizedBox(height: 20),
              ContactInfo(
                icon: Icons.email,
                text: 'info@harmonyresort.com',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfo({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
