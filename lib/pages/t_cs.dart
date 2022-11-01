// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer_admin_panel/models/admins.dart';
import 'package:final_offer_admin_panel/models/terms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../constants.dart';
import '../widgets/buttons.dart';
import '../widgets/error.dart';

class TCs extends StatefulWidget {
  const TCs({super.key});

  @override
  State<TCs> createState() => _TCsState();
}

class _TCsState extends State<TCs> {
  final currentuser = FirebaseAuth.instance.currentUser!;
  TextEditingController user = TextEditingController();
  TextEditingController company = TextEditingController();

  bool isLoading = false;
  TermsData? userTerms;
  TermsData? companyTerms;
  AdminData? data;
  @override
  void initState() {
    getTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kColorWhite,
          elevation: 0,
          title: const Text(
            'T&Cs',
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 49),
          child: Column(
            children: [
              SizedBox(height: 65),
              isLoading
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Users',
                              style:
                                  TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: kUIDark),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 488,
                              child: TextField(
                                controller: user,
                                maxLines: 10,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400, color: kUILight2),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: kUILight, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: kFormStockColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: kUILight2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contributors',
                              style:
                                  TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: kUIDark),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 488,
                              child: TextField(
                                controller: company,
                                maxLines: 10,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400, color: kUILight2),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: kUILight, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: kFormStockColor, width: 1),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: kUILight2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              SizedBox(height: 71),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 400.0),
                    child: SizedBox(
                      width: 200,
                      height: 52,
                      child: FixedPrimary(
                          buttonText: 'Save Changes',
                          ontap: () async {
                            await FirebaseFirestore.instance
                                .collection('userterms')
                                .doc(userTerms!.id)
                                .update({'terms': user.text});

                            await FirebaseFirestore.instance
                                .collection('companyTerms')
                                .doc(companyTerms!.id)
                                .update({'terms': user.text});
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ErrorDialog(
                                        title: 'Success',
                                        message: 'Terms saved successfully',
                                        type: 'R',
                                        function: () {
                                          Navigator.pop(context);
                                        },
                                        buttontxt: 'Close')));
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getTerms() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('admins')
        .where('id', isEqualTo: currentuser.uid)
        .get();

    if (snap.docs.isNotEmpty) {
      data = AdminData.fromMap(snap.docs.first.data() as Map<String, dynamic>);
    }

    QuerySnapshot usersnap = await FirebaseFirestore.instance.collection('userterms').get();
    if (usersnap.docs.isNotEmpty) {
      userTerms = TermsData.fromMap(usersnap.docs.first.data() as Map<String, dynamic>);
    }

    QuerySnapshot compsnap = await FirebaseFirestore.instance.collection('companyTerms').get();
    if (compsnap.docs.isNotEmpty) {
      companyTerms = TermsData.fromMap(compsnap.docs.first.data() as Map<String, dynamic>);
    }
    isLoading = false;
    user.text = userTerms!.terms!;
    company.text = companyTerms!.terms!;
    setState(() {});
  }
}
