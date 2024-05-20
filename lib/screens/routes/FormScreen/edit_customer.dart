import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_app/dto/issue.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:my_app/screens/routes/SecondScreen/Customer%20Screen/customer_screen.dart';

class EditCustomer extends StatefulWidget {
  const EditCustomer({Key? key, required this.issues}) : super(key: key);
  final Issues issues;

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? galleryFile;
  final picker = ImagePicker();

  late String division;
  late String priority;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.issues.title;
    _descriptionController.text = widget.issues.deskripsi;
    division =
        widget.issues.division ?? 'IT'; // Default to IT if division is null
    priority =
        widget.issues.priority ?? 'Low'; // Default to Low if priority is null
  }

  _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  Future<void> _updateDataWithImage(BuildContext context) async {
    if (galleryFile == null) {
      return; // Handle case where no image is selected
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('${Endpoints.dataNIM}/${widget.issues.idIssues}'));
    request.fields['title_issues'] = _titleController.text;
    request.fields['description_issues'] = _descriptionController.text;
    request.fields['rating'] = rating.toString(); // Use existing rating
    request.fields['division'] = division; // Use updated division
    request.fields['priority'] = priority; // Use updated priority
    if (galleryFile != null) {
      var multipartFile = await http.MultipartFile.fromPath(
        'image', // ganti field sesui in
        galleryFile!.path,
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();
    // Handle response (success or error)
    if (response.statusCode == 200) {
      debugPrint('Data and image posted successfully!');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const CustomerScreen()));
    } else {
      debugPrint('Error posting data: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _titleController.dispose(); // Dispose of controller when widget is removed
    _descriptionController.dispose();
    super.dispose();
  }

  double rating = 0;
  void ratingUpdate(double userRating) {
    setState(() {
      rating = userRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Update Issues'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Division',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              DropdownButton<String>(
                value: division,
                items: ['IT', 'Billing', 'Helpdesk'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      division = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Priority',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              DropdownButton<String>(
                value: priority,
                items: ['Low', 'Medium', 'High'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      priority = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Title Issue',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  hintText: "Title",
                ),
              ),
              const SizedBox(height: 10),
              const Text('Description Issue',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink)),
              TextField(
                controller: _descriptionController,
                maxLength: 150,
                maxLines: 4,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  hintText: "Description",
                ),
              ),
              const Text('Rating',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink)),
              RatingBar(
                minRating: 1,
                maxRating: 5,
                allowHalfRating: false,
                ratingWidget: RatingWidget(
                  full: const Icon(
                    Icons.star,
                    color: Colors.pink,
                  ),
                  half: const Icon(
                    Icons.star_half,
                    color: Colors.pink,
                  ),
                  empty: const Icon(
                    Icons.star_border,
                    color: Colors.pink,
                  ),
                ),
                onRatingUpdate: ratingUpdate,
                initialRating: widget.issues.rating.toDouble(),
              ),
              const SizedBox(height: 20),
              const Text('Picture',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink)),
              GestureDetector(
                onTap: () {
                  _showPicker(context: context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            Colors.pink, // Warna border hitam untuk semua sisi
                      ),
                      color: Colors.grey.shade200),
                  width: double.infinity, // Fill available space
                  height: 150, // Adjust height as needed
                  // color: Colors.grey[200], // Placeholder color
                  child: galleryFile == null
                      ? Center(
                          child: Image.network(
                            width: 200,
                            Uri.parse(
                                    '${Endpoints.baseURLLive}/public/${widget.issues.imageUrl!}')
                                .toString(),
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        )
                      : Center(
                          child: Image.file(galleryFile!),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        tooltip: 'Increment',
        onPressed: () {
          _updateDataWithImage(context);
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}
