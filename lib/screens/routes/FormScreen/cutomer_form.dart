import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_app/screens/routes/SecondScreen/Customer Screen/customer_screen.dart';

class CustomerFormScreen extends StatefulWidget {
  const CustomerFormScreen({Key? key}) : super(key: key);

  @override
  _CustomerFormScreenState createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  // final _ratingController = TextEditingController();

  // String _title = "";
  // String _description = "";
  // // double _rating = 0;
  File? _galleryFile;
  final picker = ImagePicker();

  List<String> divisions = ['IT', 'Billing', 'Helpdesk'];
  String? _selectedDivision;

  List<String> priority = ['High', 'Medium', 'Low'];
  String? _selectedPriority;

  _showPicker({required BuildContext context}) {
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
          _galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  Future<void> _postDataWithImage(BuildContext context) async {
    if (_galleryFile == null || _titleController.text.isEmpty) {
      return; // Handle case where no image or title is provided
    }

    var request = MultipartRequest('POST', Uri.parse(Endpoints.dataNIM));
    request.fields['title_issues'] = _titleController.text;
    request.fields['description_issues'] = _descriptionController.text;
    request.fields['rating'] = rating.toString();

    var multipartFile = await MultipartFile.fromPath(
      'image',
      _galleryFile!.path,
    );
    request.files.add(multipartFile);

    request.send().then((response) {
      // Handle response (success or error)
      if (response.statusCode == 201) {
        debugPrint('Data and image posted successfully!');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const CustomerScreen()));
      } else {
        debugPrint('Error posting data: ${response.statusCode}');
      }
    });
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
      backgroundColor: Colors.pink.shade900,
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Issue",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Fill the datas below, make sure you add titles, description, rating and upload the images",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showPicker(context: context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.pink.shade200))),
                                width: double.infinity,
                                height: 150,
                                child: _galleryFile == null
                                    ? Center(
                                        child: Text(
                                          'Pick your Image here',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                255, 124, 122, 122),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Image.file(_galleryFile!),
                                      ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.pink.shade200))),
                              child: TextField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  hintText: "Title",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.pink.shade200))),
                              child: TextField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  hintText: "Description",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('Berikan Rating!',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('Division'),
                                    DropdownButton<String>(
                                      value: _selectedDivision,
                                      items: divisions.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedDivision = newValue;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Priority'),
                                    DropdownButton<String>(
                                      value: _selectedPriority,
                                      items: priority.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedPriority = newValue;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 174, 106, 161),
        tooltip: 'Save',
        onPressed: () {
          _postDataWithImage(context);
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}
