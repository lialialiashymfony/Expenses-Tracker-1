import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/screens/database_helper.dart';
import 'package:intl/intl.dart';

class AddExpensesPage extends StatefulWidget {
  const AddExpensesPage({super.key});

  @override
  State<AddExpensesPage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensesPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });
  } //menambahkan variabel untuk menyimpan tanggal yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Add Your Expense Here!',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? 'Date: ${DateFormat('dd-MM-yyyy').format(selectedDate!)}'
                          : 'Select Date',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> expense = {
                  'title': titleController.text,
                  'amount': double.parse(amountController.text),
                  'description': descriptionController.text,
                  'date': selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                      : DateTime.now().toString(),
                };
                await DatabaseHelper.instance.insertExpense(expense);
                // Menutup layar dan memperbarui UI dengan kembali ke layar sebelumnya
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            title: 'Home Page',
                          )),
                );
              },
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
