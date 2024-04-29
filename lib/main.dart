import 'package:flutter/material.dart';
import 'package:my_app/screens/custom_screen.dart';
import 'package:my_app/screens/history_expenses_page.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/add_expense_page.dart';
import 'package:my_app/screens/news_screen.dart';
import 'package:my_app/screens/routes/FormScreen/cutomer_form.dart';
import 'package:my_app/screens/routes/SecondScreen/Customer%20Screen/customer_screen.dart';
import 'package:my_app/screens/routes/SecondScreen/DatasDcreen/datas_screen.dart';
import 'package:my_app/screens/try.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lia Cantik Jelita',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      // home: const MyHomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Home Page'),
        '/add-expenses-page': (context) => const AddExpensesPage(),
        '/history-expenses-page': (context) => HistoryExpensesPage(),
        '/news-screen': (context) => const LongListScreen(),
        '/datas-screen': (context) => const DatasScreen(),
        '/customer-form': (context) => const CustomerFormScreen(),
        '/customer-screen': (context) => const CustomerScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    AddExpensesPage(),
    HistoryExpensesPage(),
    LongListScreen(),
    DatasScreen(),
    CustomerScreen(),
  ];

  final List<String> _appBarTitles = const [
    'Home',
    'Add',
    'History',
    'List',
    'Datas screen',
    'Customer service'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateAndCloseDrawer(BuildContext context, String routeName) {
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context); // Close the drawer first
    }
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          _appBarTitles[_selectedIndex],
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text(
                'Expenses Tracker',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text('Home Page'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Add Expense Page'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('History Expenses Page'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            listTilePush(context, 'News Screen', '/news-screen'),
            listTilePush(context, 'Datas Screen', '/datas-screen'),
            listTilePush(context, 'Customer Service', '/customer-screen'),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        onTap: _onItemTapped,
      ),
    );
  }

  ListTile listTilePush(
      BuildContext context, String screenName, String routesname) {
    return ListTile(
      title: Text(screenName),
      selected: _selectedIndex == 2,
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routesname);
      },
    );
  }
}
