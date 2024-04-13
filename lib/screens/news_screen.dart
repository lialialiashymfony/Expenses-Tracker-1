import 'package:flutter/material.dart';
import 'package:my_app/dto/news.dart';
import 'package:my_app/services/data_services.dart';

class LongListScreen extends StatefulWidget {
  const LongListScreen({Key? key}) : super(key: key);

  @override
  _LongListScreenState createState() => _LongListScreenState();
}

class _LongListScreenState extends State<LongListScreen> {
  late Future<List<News>> _news;

  final _simpanTitle = TextEditingController();
  final _simpanBody = TextEditingController();

  @override
  void initState() {
    super.initState();
    _news = DataService.fetchNews();
  }

  @override
  void dispose() {
    _simpanTitle.dispose();
    _simpanBody.dispose();
    super.dispose();
  }

  void showIsian(News post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          post.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Container(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    post.photo,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "ID Category: ${post.idCategory}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "ID: ${post.id}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  post.body,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 18,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showInput() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Masukkan Data"),
        content: Column(
          children: [
            TextField(
              controller: _simpanTitle,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _simpanBody,
              maxLines: 5,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 222, 73, 123))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: 'Body'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              DataService.sendNews(_simpanTitle.text, _simpanBody.text);
              Navigator.pop(context);
              setState(() {
                _news = DataService.fetchNews();
              });
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _deleteNews(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Apakah Anda yakin ingin menghapus list ini?"),
        actions: [
          TextButton(
            onPressed: () {
              DataService.deleteData(id);
              Navigator.pop(context);
              setState(() {
                _news = DataService.fetchNews();
              });
            },
            child: Text('Ya'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Tidak'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(News post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update List"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: post.title),
              onChanged: (value) {
                post.title = value;
              },
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: TextEditingController(text: post.body),
              onChanged: (value) {
                post.body = value;
              },
              decoration: InputDecoration(
                labelText: "Body",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              DataService.updateData(post.id, post.title, post.body);
              Navigator.pop(context);
              setState(() {
                _news = DataService.fetchNews();
              });
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: FutureBuilder<List<News>>(
          future: _news,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      showIsian(post);
                    },
                    child: Container(
                      height: 150,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(post.photo),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  (post.body.length > 100)
                                      ? post.body.substring(0, 100) + '...'
                                      : post.body,
                                  style: TextStyle(fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteNews(post.id);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _showUpdateDialog(post);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showInput();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
