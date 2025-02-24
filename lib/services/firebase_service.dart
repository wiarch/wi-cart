import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> GetPeople() async {
  List people = [];
  try {
    CollectionReference collectionReferencePeople = db.collection('people');

    QuerySnapshot querySnapshotPeople = await collectionReferencePeople.get(); // Get all documents from the collection
    querySnapshotPeople.docs.forEach((documento) {
      people.add(documento.data());
    });
  } catch (e) {
    print(e);
  }
  return people;
}
