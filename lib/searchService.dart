import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {

  searchByName(String searchfield){
    return Firestore.instance.collection('mahavir_menu').where(
      'searchKey', isEqualTo: searchfield.substring(0,1).toUpperCase()
    ).getDocuments();
  }

}