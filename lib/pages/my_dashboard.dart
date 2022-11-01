// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer_admin_panel/components/dashboard_components/info_card_products.dart';
import 'package:final_offer_admin_panel/models/admins.dart';
import 'package:final_offer_admin_panel/models/company.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../components/dashboard_components/incom_analysis.dart';
import '../components/dashboard_components/info_card_controbutors.dart';
import '../components/dashboard_components/info_card_users.dart';
import '../components/dashboard_components/offers_analytics.dart';
import '../components/dashboard_components/trans_history.dart';
import '../constants.dart';
import '../models/lodge.dart';
import '../models/users.dart';
import '../widgets/error.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({Key? key}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isLoading = false;
  AdminData? data;
  List<CompanyData> companyData = [];
  List<Users> userData = [];
  List<LodgeData> lodgesData = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDashboardBodyColor,
        appBar: AppBar(
          backgroundColor: kColorWhite,
          elevation: 0,
          title: const Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: kColorBlue,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 40.5),
              child: Row(
                children: [
                  Text(
                    isLoading ? '' : data!.name!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: kColorBlack),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  isLoading
                      ? CircleAvatar()
                      : data!.photo!.isEmpty
                          ? CircleAvatar()
                          : CircleAvatar(
                              backgroundImage: NetworkImage(data!.photo!),
                            ),
                ],
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: Row(
                    children: [
                      LoadingIndicator(indicatorType: Indicator.lineScalePulseOut),
                      LoadingIndicator(indicatorType: Indicator.lineScalePulseOut)
                    ],
                  ),
                ),
              )
            : Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1,
                    width: MediaQuery.of(context).size.width / 1.148,
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: InfoCardContriButors(
                                    companies: companyData,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: InfoCardUsers(
                                    usersdata: userData,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: InfoCardProducts(
                                    lodgesData: lodgesData,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TransHistory(
                                  data: lodgesData,
                                ),
                                SizedBox(
                                  width: 32,
                                ),
                                Column(
                                  children: [
                                    OffersAnalytics(),
                                    IncomeAnalytics(),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future getData() async {
    try {
      setState(() {
        isLoading = true;
      });

      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection('admins').where('id', isEqualTo: user.uid).get();

      if (snap.docs.isNotEmpty) {
        data = AdminData.fromMap(snap.docs.first.data() as Map<String, dynamic>);
      }

      //geetting comapnydata
      QuerySnapshot comSnap = await FirebaseFirestore.instance.collection('compnies').get();
      if (comSnap.docs.isNotEmpty) {
        companyData =
            comSnap.docs.map((e) => CompanyData.fromMap(e.data() as Map<String, dynamic>)).toList();
      }
      //getting user data

      QuerySnapshot snapUser = await FirebaseFirestore.instance.collection('users').get();
      if (snapUser.docs.isNotEmpty) {
        userData = snapUser.docs.map((e) => Users.fromMap(e.data() as Map<String, dynamic>)).toList();
      }

      //getting lodges data

      QuerySnapshot lodgeSnap = await FirebaseFirestore.instance.collection('lodges').get();

      if (lodgeSnap.docs.isNotEmpty) {
        lodgesData =
            lodgeSnap.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ErrorDialog(
                  title: 'Error',
                  message: e.toString(),
                  type: 'E',
                  function: () {
                    Navigator.pop(context);
                  },
                  buttontxt: 'Close')));
    } finally {
      isLoading = false;
      setState(() {});
    }
  }
}
