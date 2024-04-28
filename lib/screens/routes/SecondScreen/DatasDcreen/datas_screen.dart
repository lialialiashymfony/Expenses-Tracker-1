// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/components/bottom_up_transation.dart';
import 'package:my_app/dto/datas.dart';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/screens/routes/FormScreen/form_screen.dart';
import 'package:my_app/services/data_services.dart';
import 'package:my_app/screens/edit-form-screen.dart';

class DatasScreen extends StatefulWidget {
  const DatasScreen({Key? key}) : super(key: key);

  @override
  _DatasScreenState createState() => _DatasScreenState();
}

//cekcek
class _DatasScreenState extends State<DatasScreen> {
  Future<List<Datas>>? _datas;

  @override
  void initState() {
    super.initState();
    _datas = DataService.fetchDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data List'),
        leading: IconButton(
          icon: const Icon(Icons
              .arrow_back), // Customize icon (optional)// Customize color (optional)
          onPressed: () {
            // Your custom back button functionality here
            Navigator.pushReplacementNamed(
                context, '/'); // Default back button behavior
            // You can add additional actions here (e.g., show confirmation dialog)
          },
        ),
      ),
      body: FutureBuilder<List<Datas>>(
        future: _datas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: item.imageUrl != null
                      ? Row(
                          children: [
                            Image.network(
                              fit: BoxFit.fitWidth,
                              width: 350,
                              Uri.parse(
                                      '${Endpoints.baseURLLive}/public/${item.imageUrl!}')
                                  .toString(),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons
                                      .error), // Display error icon if image fails to load
                            ),
                          ],
                        )
                      : null,
                  subtitle: Column(
                    children: [
                      Text(
                        'Name : ${item.name}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 36, 31, 31),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, item);
                            },
                            icon: Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FormUpdateScreen(objek: item)));
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 54, 40, 176),
        tooltip: 'Increment',
        onPressed: () {
          // Navigator.pushNamed(context, '/form-screen');
          // BottomUpRoute(page: const FormScreen());
          Navigator.push(context, BottomUpRoute(page: const FormScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Datas datas) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete ${datas.name}?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("CANCEL"),
            ),
            TextButton(
              onPressed: () {
                // Delete the data and update the UI
                DataService.deleteDatas(datas
                    .idDatas); // Assuming you have a delete method in DataService
                setState(() {
                  _datas = DataService.fetchDatas();
                });
                Navigator.of(context).pop();
              },
              child: Text("DELETE"),
            ),
          ],
        );
      },
    );
  }
}
