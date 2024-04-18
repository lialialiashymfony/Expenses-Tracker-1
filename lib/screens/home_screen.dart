import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screens/add_expense_page.dart';
import 'package:my_app/screens/database_helper.dart';
import 'package:my_app/screens/history_expenses_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<double> _todayExpenses;
  late Future<double> _monthlyExpenses;

  @override
  void initState() {
    super.initState();
    _todayExpenses =
        _getTodayExpenses(); // Mengambil total pengeluaran hari ini dari database
    _monthlyExpenses =
        _getMonthlyExpenses(); // Mengambil total pengeluaran bulanan dari database
  }

  Future<double> _getTodayExpenses() async {
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);
    List<
        Map<String,
            dynamic>> expenses = await DatabaseHelper.instance.getExpensesByDate(
        today); // Mengambil pengeluaran berdasarkan tanggal hari ini dari database
    double total = 0;
    for (var expense in expenses) {
      total += expense['amount']; // Menjumlahkan total pengeluaran hari ini
    }
    return total;
  }

  Future<double> _getMonthlyExpenses() async {
    DateTime now = DateTime.now();
    String month = DateFormat('yyyy-MM').format(now);
    List<Map<String, dynamic>> expenses = await DatabaseHelper.instance
        .getExpensesByMonth(
            month); // Mengambil pengeluaran berdasarkan bulan ini dari database
    double total = 0;
    for (var expense in expenses) {
      total += expense['amount']; // Menjumlahkan total pengeluaran bulanan
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          'Welcome to Expenses Tracker!',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ), // Judul halaman
      ),
      body: Center(
        // Menampilkan informasi total pengeluaran hari ini dan bulanan
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<double>(
              future: _todayExpenses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Container(
                    width: 380,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Today Expenses: ${snapshot.data?.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            FutureBuilder<double>(
              future: _monthlyExpenses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Container(
                    width: 380,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Monthly Expenses: ${snapshot.data?.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoryExpensesPage()),
                );

                setState(() {
                  _todayExpenses = _getTodayExpenses();
                  _monthlyExpenses = _getMonthlyExpenses();
                });
              },
              child: Text(
                'See History',
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpensesPage()),
          );
        },
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
