import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text(''),
          ),
        ],
        currentIndex: 0,
        backgroundColor: Colors.grey[200],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  'Reading List',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  'Reading (3)',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Column(children: <Widget>[
                Divider(),
                ListTile(
                  title: Text('Sapiens'),
                  subtitle: Text('Yuval Noah Harari'),
                  leading: Image.network(
                      'https://books.google.com/books/content/images/frontcover/FmyBAwAAQBAJ?fife=w200-h300'),
                  trailing: Icon(Icons.reorder),
                ),
                Divider(),
                ListTile(
                  title: Text('Skin in the Game'),
                  subtitle: Text('Nassim Nicholas Taleb'),
                  leading: Image.network(
                      'https://pictures.abebooks.com/isbn/9780425284629-us.jpg'),
                  trailing: Icon(Icons.reorder),
                ),
                Divider(),
                ListTile(
                  title: Text('Man\'s Search for Meaning'),
                  subtitle: Text('Viktor Frankl'),
                  leading: Image.network(
                    'https://images-na.ssl-images-amazon.com/images/I/41-m35gRb3L._AC_UL160_.jpg',
                  ),
                  trailing: Icon(Icons.reorder),
                ),
                Divider(),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
