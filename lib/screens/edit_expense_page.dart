import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screens/database_helper.dart';

class EditExpensePage extends StatefulWidget {
  final Map<String, dynamic> expense;

  EditExpensePage(this.expense);

  @override
  _EditExpensePageState createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense['title']);
    _amountController =
        TextEditingController(text: widget.expense['amount'].toString());
    _descriptionController =
        TextEditingController(text: widget.expense['description']);
    TextEditingController(text: widget.expense['description']);
    _selectedDate = DateTime.parse(widget.expense['date']); // Set tanggal awal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'), // Judul halaman
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Title'), // Form untuk judul pengeluaran
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                  labelText: 'Amount'), // Form untuk jumlah pengeluaran
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText: 'Description'), // Form untuk deskripsi pengeluaran
            ),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
                    ),
                  ),
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> editedExpense = {
                  'id': widget.expense['id'],
                  'title': _titleController.text,
                  'amount': double.parse(_amountController.text),
                  'description': _descriptionController.text,
                  'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
                };
                await DatabaseHelper.instance.updateExpense(
                    editedExpense); // Memperbarui pengeluaran di database
                Navigator.pop(context, editedExpense);
              },
              child: Text('Save'), // Tombol untuk menyimpan perubahan
            ),
          ],
        ),
      ),
    );
  }
}
