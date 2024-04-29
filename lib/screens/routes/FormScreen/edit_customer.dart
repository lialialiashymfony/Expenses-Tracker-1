import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dto/issue.dart';
import 'package:my_app/endpoints/endpoints.dart';

class EditCustomer extends StatefulWidget {
  const EditCustomer({Key? key, required this.issues}) : super(key: key);
  final Issues issues;

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
