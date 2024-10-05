import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/auth/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthUtils {
  final User? _user = FirebaseAuth.instance.currentUser;

  String? getDisplayName(){
    return _user?.displayName;
  }

  List<String>? getSplitDisplayName(){
    String? name = getDisplayName();
    return name?.split(' ').toList();
  }

  String? getLastName(){
    List<String>? list = getSplitDisplayName();
    print(list?.last);
    if(list!.length < 2) return "";
    return list.last;
  }

  String? getFirstName(){
    List<String>? list = getSplitDisplayName();
    String name = "";
    if (list == null || list.isEmpty) return '';
    if(list.length < 2) return list.first;
    for(int i = 0 ; i < list.length - 1; i++){
      name += list[i];
      if(i != list.length - 1) {
        name += " ";
      }
    }
    print(name);
    return name;
  }

  String? getEmail(){
    return _user?.email;
  }

  Image? getPhoto(){
    String? photoUrl = _user?.photoURL;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      // Replace small photo URL with a larger one
      photoUrl = photoUrl.replaceAll("s96-c", "s400-c");
      return Image.network(photoUrl);
    }
    return null;
  }

  Future<Image?> getCoverPhotoUrl() async {
    final db = FirebaseFirestore.instance;
    var querySnapshot = await db.collection('users')
        .where('user_id', isEqualTo: AuthService().getCurrentUser()?.uid)
        .limit(1)
        .get();

    // Check if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      String docId = doc.id;

      // Update the existing document with the new field
      final snap = await db.collection('users').doc(docId).get();
      if(snap.exists){
        if(snap.get('cover_photo') == '') return Image.asset('assets/images/Deck-Logo.png');
        return Image.network(snap.get('cover_photo'));
      } else {
        return null;
      }
    }
  }

}