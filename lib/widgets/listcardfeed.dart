import 'package:flutter/material.dart';
import 'titlecard.dart';
import 'descriptioncard.dart';
import 'imagecard.dart';
import 'buttonscard.dart';
import 'package:list_market/services/firebase_service.dart';

class ListCardFeed extends StatelessWidget {
  const ListCardFeed({super.key});

  @override
  Widget build(BuildContext context) {
    // print("EJEMPLO: $data");

    var textStyle = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return FutureBuilder(
      future: GetPeople(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                height: 350,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(color: Colors.white),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TitleCard(
                          name: snapshot.data?[index]['name'] ?? 'No Name',
                        ), // Maneja el caso de que no haya un valor para 'name'
                      ),
                      DescriptionCard(
                        description:
                            snapshot.data?[index]['description'] ??
                            'No Description',
                      ), // Lo mismo aquí
                      ImageCard(
                        image: snapshot.data?[index]['image'] ?? 'No Image',
                      ), // Lo mismo aquí
                      ButtonsCard(textStyle: textStyle),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
