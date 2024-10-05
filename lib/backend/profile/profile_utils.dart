import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../auth/auth_service.dart';
import '../auth/auth_utils.dart';
class ProfileUtils {
  Future<bool> doesFileExist(Reference ref) async {
    try {
      await ref.getDownloadURL();
      return true; // File exists
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return false; // File does not exist
      } else {
        rethrow; // Some other error occurred
      }
    }
  }


}