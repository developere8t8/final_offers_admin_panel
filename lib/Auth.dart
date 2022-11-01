import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer_admin_panel/pages/my_dashboard.dart';
import 'package:final_offer_admin_panel/widgets/side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(), //chekcing auth status
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return SideBar();
            } else if (snapshot.hasError) {
              return const LoginPage();
            } else {
              return const LoginPage();
            }
          }),
    ));
  }
}
