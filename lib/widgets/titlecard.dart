import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(child: Text('W')),
        const SizedBox(width: 10),
        Text(name,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
