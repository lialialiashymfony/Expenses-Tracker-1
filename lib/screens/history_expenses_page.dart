import 'package:flutter/material.dart';
import 'package:my_app/screens/add_expense_page.dart';
import 'package:my_app/screens/database_helper.dart';
import 'package:my_app/screens/edit_expense_page.dart';
import 'package:my_app/screens/home_screen.dart';

class HistoryExpensesPage extends StatefulWidget {
  @override
  _HistoryExpensesPageState createState() => _HistoryExpensesPageState();
}

class _HistoryExpensesPageState extends State<HistoryExpensesPage> {
  late Future<List<Map<String, dynamic>>> _expenses;

  @override
  void initState() {
    super.initState();
    _expenses = DatabaseHelper.instance
        .getAllExpenses(); // Mengambil semua data pengeluaran dari database
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          'History Expenses',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ), // Judul halaman
      ),
      body: FutureBuilder(
        future: _expenses,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Map<String, dynamic>> expenses =
              snapshot.data as List<Map<String, dynamic>>;
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> expense = expenses[index];
              return ListTile(
                title: Text(expense['title']), // Menampilkan judul pengeluaran
                subtitle: Text(
                    'Amount: ${expense['amount']}'), // Menampilkan jumlah pengeluaran
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        final editedExpense = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditExpensePage(
                                  expense)), // Navigasi ke halaman edit pengeluaran
                        );
                        if (editedExpense != null) {
                          setState(() {
                            _expenses = DatabaseHelper.instance
                                .getAllExpenses(); // Menyegarkan halaman jika ada perubahan data
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DatabaseHelper.instance.deleteExpense(expense[
                            'id']); // Menghapus pengeluaran dari database
                        setState(() {
                          _expenses = DatabaseHelper.instance
                              .getAllExpenses(); // Menyegarkan halaman setelah penghapusan
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
