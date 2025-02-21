import 'package:flutter/material.dart';
import 'titlecard.dart';
import 'descriptioncard.dart';
import 'imagecard.dart';
import 'buttonscard.dart';

class CardFeed extends StatelessWidget {
  const CardFeed({super.key});

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
          children: [
            Container(padding: const EdgeInsets.all(10), child: TitleCard()),

            DescriptionCard(),

            ImageCard(),

            ButtonsCard(textStyle: textStyle),
          ],
        ),
      ),
    );
  }
}
