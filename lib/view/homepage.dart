import 'package:flutter/material.dart';
import './menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  var _currentIndex = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Menu(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              items: [
                /// Home
                BottomBarItem(
                  icon: const Icon(Icons.home),
                  title: const Text("Home"),
                  selectedColor: Colors.purple,
                ),

                /// Likes
                BottomBarItem(
                  icon: const Icon(Icons.favorite_border),
                  title: const Text("Likes"),
                  selectedColor: Colors.pink,
                ),

                /// Search
                BottomBarItem(
                  icon: const Icon(Icons.search),
                  title: const Text("Search"),
                  selectedColor: Colors.orange,
                ),

                /// Profile
                BottomBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text("Profile"),
                  selectedColor: Colors.teal,
                ),
              ],
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
