import 'package:flutter/material.dart';
import 'titlecard.dart';
import 'descriptioncard.dart';
import 'imagecard.dart';
import 'buttonscard.dart';

class CardFeed extends StatelessWidget {
  const CardFeed({super.key, required this.card});

  final Map<String, String> card;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return Container(
      width: double.infinity,
      height: 350,
      margin: const EdgeInsets.only(top: 10),
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        // padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: TitleCard(name: card['name'] ?? ''),
            ),

            DescriptionCard(description: card['description'] ?? ''),

            ImageCard(image: card['image'] ?? ''),

            ButtonsCard(textStyle: textStyle),
          ],
        ),
      ),
    );
  }
}
