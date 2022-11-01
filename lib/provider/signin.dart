import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer_admin_panel/models/admins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/company.dart';

class SigninProvider extends ChangeNotifier {
  //google signin function starts here
  final googleSignin = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignin.signIn();
      if (googleUser == null) {
        return;
      } else {
        _user = googleUser;
      }
      final googleauth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('admins').where('id', isEqualTo: user.uid).get();
        if (snapshot.docs.isEmpty) {
          final addUser = FirebaseFirestore.instance.collection('admins').doc(user.uid);
          AdminData adminData = AdminData(
              active: true,
              created: Timestamp.fromDate(DateTime.now()),
              email: user.email,
              id: user.uid,
              photo: user.photoURL,
              name: user.displayName);

          await addUser.set(adminData.tomap());
        } else {
          final addUser = FirebaseFirestore.instance.collection('admins').doc(user.uid);
          addUser.update({
            'photo': user.photoURL,
            'name': user.displayName,
          });
        }
      }

      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  //google signin function ends here

  //logout function
  Future logOut() async {
    try {
      await googleSignin.disconnect();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      await FirebaseAuth.instance.signOut();
    } finally {
      await FirebaseAuth.instance.signOut();
    }
  }
}
