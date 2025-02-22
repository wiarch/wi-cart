import 'package:flutter/material.dart';
import 'likebutton.dart';

class ButtonsCard extends StatelessWidget {
  const ButtonsCard({super.key, required this.textStyle});

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LikeButton(),
          TextButton(
            onPressed: () {},
            child: Text('Comentar', style: textStyle),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Compartir', style: textStyle),
          ),
        ],
      ),
    );
  }
}
