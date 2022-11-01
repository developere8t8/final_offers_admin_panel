// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer_admin_panel/models/category.dart';
import 'package:final_offer_admin_panel/models/region.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../constants.dart';
import '../models/admins.dart';
import '../widgets/buttons.dart';
import '../widgets/error.dart';
import '../widgets/text_field.dart';

class Regions extends StatefulWidget {
  const Regions({super.key});

  @override
  State<Regions> createState() => _RegionsState();
}

class _RegionsState extends State<Regions> {
  TextEditingController search = TextEditingController();
  TextEditingController newRegion = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;
  bool isLoading = false;
  AdminData? data;
  List<RegionData> regionData = [];
  List<RegionData> activeregionData = [];
  List<RegionData> pendingregionData = [];
  List<String> regionNames = [];
  List<RegionData> temp = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kColorWhite,
            elevation: 0,
            title: Text(
              'Regions',
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
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Row(
                    children: [
                      SizedBox(
                        width: 340,
                        height: 47,
                        child: TypeAheadFormField(
                          suggestionsCallback: (patteren) => regionNames.where(
                              (element) => element.toLowerCase().contains(patteren.toLowerCase())),
                          onSuggestionSelected: (String value) {
                            search.text = value;
                            getAllDatabyName(value);
                          },

                          itemBuilder: (_, String item) => Card(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(item),
                            ),
                          ),
                          getImmediateSuggestions: true,
                          //hideSuggestionsOnKeyboardHide: true,
                          hideOnEmpty: false,
                          noItemsFoundBuilder: (_) => const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('No data found'),
                          ),
                          textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  CupertinoIcons.search,
                                  size: 17,
                                ),
                                // suffixIcon: Icon(
                                //   CupertinoIcons.mic_fill,
                                //   size: 17,
                                // ),
                                hintText: 'Search',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(128),
                                  borderSide: BorderSide(color: kUILight, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(128),
                                  borderSide: BorderSide(color: kUILight, width: 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: kUILight2,
                                ),
                              ),
                              controller: search,
                              onChanged: ((value) {
                                if (value == '') {
                                  getAllDatabyAll();
                                }
                              })),
                        ),
                      ),
                      SizedBox(width: 24),
                      SizedBox(
                        width: 250,
                        height: 52,
                        child: TextFieldWidget(
                          hintText: 'Wirte region to add',
                          ebColor: kUILight,
                          controller: newRegion,
                        ),
                      ),
                      SizedBox(width: 24),
                      SizedBox(
                        width: 250,
                        height: 52,
                        child: FixedPrimary(
                            buttonText: 'Save Region',
                            ontap: () async {
                              addNewCategory();
                            }),
                      ),
                    ],
                  ),
                  SizedBox(height: 29),
                  TabBar(
                    isScrollable: true,
                    labelPadding: EdgeInsets.symmetric(horizontal: 35),
                    indicatorPadding: EdgeInsets.zero,
                    indicatorColor: kPrimary2,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: kPrimary2,
                    unselectedLabelColor: kUILight2,
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    indicatorWeight: 3,
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'Active'),
                      Tab(text: 'Inactive'),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: kTabBarLine,
                  ),
                  SizedBox(height: 78),
                  isLoading
                      ? SizedBox(
                          height: 700,
                          width: 500,
                          child: Center(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Row(
                                children: [
                                  LoadingIndicator(
                                    indicatorType: Indicator.orbit,
                                    colors: [Colors.red, Colors.blue],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 1170,
                          height: 611,
                          child: TabBarView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Container(
                                      width: 1170,
                                      height: 611,
                                      decoration: BoxDecoration(
                                        color: kColorWhite,
                                      ),
                                      child: SingleChildScrollView(
                                        child: DataTable(
                                            columnSpacing: 300,
                                            dataRowHeight: 80.0,
                                            horizontalMargin: 46,
                                            headingTextStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: kUIDark),
                                            dataTextStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            headingRowColor: MaterialStateColor.resolveWith(
                                              (states) {
                                                return Color(0xFFF3F3F3);
                                              },
                                            ),
                                            columns: <DataColumn>[
                                              DataColumn(
                                                label: Text('Name'),
                                              ),
                                              DataColumn(
                                                label: Text('Set Inactive/Active'),
                                              ),
                                              // DataColumn(
                                              //   label: Text(''),
                                              // ),
                                            ],
                                            rows: regionData
                                                .map((e) => DataRow(cells: [
                                                      DataCell(
                                                        Text(
                                                          e.region!,
                                                          style: TextStyle(
                                                            color: kUIDark,
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Transform.scale(
                                                          scale: 0.8,
                                                          child: CupertinoSwitch(
                                                            value: e.active!,
                                                            activeColor: kPrimary1,
                                                            trackColor: kUILight,
                                                            onChanged: (value) async {
                                                              setState(() {
                                                                e.active = value;
                                                              });
                                                              await FirebaseFirestore.instance
                                                                  .collection('region')
                                                                  .doc(e.id)
                                                                  .update({'active': e.active});
                                                              getData();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      // DataCell(
                                                      //   Row(
                                                      //     children: [
                                                      //       InkWell(
                                                      //         onTap: () {
                                                      //           setState(() {
                                                      //             newCategory.text = e.category!;
                                                      //           });
                                                      //         },
                                                      //         child: Column(
                                                      //           children: [
                                                      //             SizedBox(height: 20),
                                                      //             Image.asset(
                                                      //               'assets/icons/p_edit.png',
                                                      //               scale: 5,
                                                      //             ),
                                                      //             SizedBox(height: 6),
                                                      //             Text(
                                                      //               'Edit',
                                                      //               style: TextStyle(
                                                      //                   fontSize: 13,
                                                      //                   fontWeight: FontWeight.w500,
                                                      //                   color: kPrimary1),
                                                      //             ),
                                                      //           ],
                                                      //         ),
                                                      //       )
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                    ]))
                                                .toList()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //active categories
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Container(
                                      width: 1170,
                                      height: 611,
                                      decoration: BoxDecoration(
                                        color: kColorWhite,
                                      ),
                                      child: SingleChildScrollView(
                                        child: DataTable(
                                            columnSpacing: 300,
                                            dataRowHeight: 80.0,
                                            horizontalMargin: 46,
                                            headingTextStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: kUIDark),
                                            dataTextStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            headingRowColor: MaterialStateColor.resolveWith(
                                              (states) {
                                                return Color(0xFFF3F3F3);
                                              },
                                            ),
                                            columns: <DataColumn>[
                                              DataColumn(
                                                label: Text('Name'),
                                              ),
                                              DataColumn(
                                                label: Text('Set Inactive/Active'),
                                              ),
                                              // DataColumn(
                                              //   label: Text(''),
                                              // ),
                                            ],
                                            rows: activeregionData
                                                .map((e) => DataRow(cells: [
                                                      DataCell(
                                                        Text(
                                                          e.region!,
                                                          style: TextStyle(
                                                            color: kUIDark,
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Transform.scale(
                                                          scale: 0.8,
                                                          child: CupertinoSwitch(
                                                            value: e.active!,
                                                            activeColor: kPrimary1,
                                                            trackColor: kUILight,
                                                            onChanged: (value) async {
                                                              setState(() {
                                                                e.active = value;
                                                              });
                                                              await FirebaseFirestore.instance
                                                                  .collection('region')
                                                                  .doc(e.id)
                                                                  .update({'active': e.active});
                                                              getData();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      // DataCell(
                                                      //   Row(
                                                      //     children: [
                                                      //       InkWell(
                                                      //         onTap: () {
                                                      //           setState(() {
                                                      //             newCategory.text = e.category!;
                                                      //           });
                                                      //         },
                                                      //         child: Column(
                                                      //           children: [
                                                      //             SizedBox(height: 20),
                                                      //             Image.asset(
                                                      //               'assets/icons/p_edit.png',
                                                      //               scale: 5,
                                                      //             ),
                                                      //             SizedBox(height: 6),
                                                      //             Text(
                                                      //               'Edit',
                                                      //               style: TextStyle(
                                                      //                   fontSize: 13,
                                                      //                   fontWeight: FontWeight.w500,
                                                      //                   color: kPrimary1),
                                                      //             ),
                                                      //           ],
                                                      //         ),
                                                      //       )
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                    ]))
                                                .toList()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //inactive categories
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Container(
                                      width: 1170,
                                      height: 611,
                                      decoration: BoxDecoration(
                                        color: kColorWhite,
                                      ),
                                      child: SingleChildScrollView(
                                        child: DataTable(
                                            columnSpacing: 300,
                                            dataRowHeight: 80.0,
                                            horizontalMargin: 46,
                                            headingTextStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: kUIDark),
                                            dataTextStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            headingRowColor: MaterialStateColor.resolveWith(
                                              (states) {
                                                return Color(0xFFF3F3F3);
                                              },
                                            ),
                                            columns: <DataColumn>[
                                              DataColumn(
                                                label: Text('Name'),
                                              ),
                                              DataColumn(
                                                label: Text('Set Inactive/Active'),
                                              ),
                                              // DataColumn(
                                              //   label: Text(''),
                                              // ),
                                            ],
                                            rows: pendingregionData
                                                .map((e) => DataRow(cells: [
                                                      DataCell(
                                                        Text(
                                                          e.region!,
                                                          style: TextStyle(
                                                            color: kUIDark,
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Transform.scale(
                                                          scale: 0.8,
                                                          child: CupertinoSwitch(
                                                            value: e.active!,
                                                            activeColor: kPrimary1,
                                                            trackColor: kUILight,
                                                            onChanged: (value) async {
                                                              setState(() {
                                                                e.active = value;
                                                              });
                                                              await FirebaseFirestore.instance
                                                                  .collection('region')
                                                                  .doc(e.id)
                                                                  .update({'active': e.active});
                                                              getData();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      // DataCell(
                                                      //   Row(
                                                      //     children: [
                                                      //       InkWell(
                                                      //         onTap: () {
                                                      //           setState(() {
                                                      //             newCategory.text = e.category!;
                                                      //           });
                                                      //         },
                                                      //         child: Column(
                                                      //           children: [
                                                      //             SizedBox(height: 20),
                                                      //             Image.asset(
                                                      //               'assets/icons/p_edit.png',
                                                      //               scale: 5,
                                                      //             ),
                                                      //             SizedBox(height: 6),
                                                      //             Text(
                                                      //               'Edit',
                                                      //               style: TextStyle(
                                                      //                   fontSize: 13,
                                                      //                   fontWeight: FontWeight.w500,
                                                      //                   color: kPrimary1),
                                                      //             ),
                                                      //           ],
                                                      //         ),
                                                      //       )
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                    ]))
                                                .toList()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getData() async {
    try {
      setState(() {
        isLoading = true;
      });

      //getting admin data
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('admins').where('id', isEqualTo: user.uid).get();
      if (snapshot.docs.isNotEmpty) {
        data = AdminData.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      }

      //getting lodges data
      QuerySnapshot regionSnap = await FirebaseFirestore.instance.collection('region').get();

      if (regionSnap.docs.isNotEmpty) {
        setState(() {
          regionData =
              regionSnap.docs.map((e) => RegionData.fromMap(e.data() as Map<String, dynamic>)).toList();
          activeregionData = regionData.where((element) => element.active == true).toList();
          pendingregionData = regionData.where((element) => element.active == false).toList();
          regionNames = regionData.map((e) => e.region!).toList();
          temp = regionData;
        });
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

  getAllDatabyName(String value) {
    try {
      setState(() {
        regionData = temp.where((element) => element.region == value).toList();
        //gettin pendigs, accepted,rejected

        activeregionData = regionData.where((element) => element.active == true).toList();
        pendingregionData = regionData.where((element) => element.active == false).toList();
      });
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
    }
  }

  getAllDatabyAll() {
    // lodgesData.clear();
    // acceptedlodgesData.clear();
    // diclinelodgesData.clear();
    // pendinglodgesData.clear();

    try {
      setState(() {
        regionData = temp;
        //gettin pendigs, accepted,rejected

        activeregionData = regionData.where((element) => element.active == true).toList();
        pendingregionData = regionData.where((element) => element.active == false).toList();
      });
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
    }
  }

  Future addNewCategory() async {
    if (newRegion.text.isNotEmpty) {
      final newcat = FirebaseFirestore.instance.collection('region').doc();
      RegionData regnData = RegionData(region: newRegion.text, active: true, id: newcat.id);
      await newcat.set(regnData.tomap());
      newRegion.clear();
      getData();
      // ignore: use_build_context_synchronously
      showMsg(
          'region added',
          Icon(
            Icons.check,
            color: Colors.green,
          ),
          context);
    } else {
      // ignore: use_build_context_synchronously
      showMsg(
          'write region to add',
          Icon(
            Icons.close,
            color: Colors.red,
          ),
          context);
    }
  }
}
