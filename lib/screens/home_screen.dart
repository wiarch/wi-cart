import 'package:flutter/material.dart';
import '../widgets/listcardfeed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Market'),
        backgroundColor: Colors.blue,
      ),

      backgroundColor: Colors.grey[300],

      body: ListCardFeed(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        splashColor: Colors.blue[100],
        tooltip: 'Agregar',
        shape: CircleBorder(),
        // mini: true,
        // elevation: 5.0,
        // highlightElevation: 10.0,
        // disabledElevation: 0.0,
        // focusElevation: 0.0,
        // hoverElevation: 0.0,
      ),
    );
  }
}

