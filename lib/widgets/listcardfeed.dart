import 'package:flutter/material.dart';
import 'package:list_market/data/data.dart';
import 'cardfeed.dart';

class ListCardFeed extends StatelessWidget {
  const ListCardFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listCard.length,
      itemBuilder: (context, index) {
        return CardFeed(card: listCard[index],);
      },
    );
  }
}
