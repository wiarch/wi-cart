import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLiked = !_isLiked; //devuelve el valor contrario de _isLiked
        });
      },
      child: Text(
        'Me gusta',
        style: TextStyle(
          color: _isLiked ? Colors.blue : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
