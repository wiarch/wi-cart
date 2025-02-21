import 'package:flutter/material.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec nunc nec nunc.Nullam nec nunc nec nunc.Nullam nec nunc nec nunc.',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
      ),
    );
  }
}
