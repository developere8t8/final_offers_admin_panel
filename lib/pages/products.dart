// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:final_offer_admin_panel/models/admins.dart';
import 'package:final_offer_admin_panel/models/lodge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../constants.dart';
import '../widgets/buttons.dart';
import '../widgets/error.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  TextEditingController search = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  bool isLoading = false;
  AdminData? data;
  List<LodgeData> lodgesData = [];
  List<LodgeData> acceptedlodgesData = [];
  List<LodgeData> diclinelodgesData = [];
  List<LodgeData> pendinglodgesData = [];
  List<String> lodgesNames = [];
  List<String> status = ['Accepted', 'Declined', 'Pending'];
  List<String> qureyDays = ['Past 7 days', 'Past 30 days', 'Past 90 days'];
  String selectedQueryDay = 'Past 30 days';
  List<LodgeData> temp = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kColorWhite,
            elevation: 0,
            title: const Text(
              'Products',
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
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 28),
                  SizedBox(
                    width: 340,
                    height: 47,
                    child: TypeAheadFormField(
                      suggestionsCallback: (patteren) => lodgesNames
                          .where((element) => element.toLowerCase().contains(patteren.toLowerCase())),
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
                  SizedBox(height: 28),
                  Row(
                    children: [
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
                          Tab(text: 'Accepted'),
                          Tab(text: 'Declined'),
                          Tab(text: 'Pending'),
                        ],
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Container(
                        height: 40,
                        //width: 200,
                        decoration: BoxDecoration(border: Border.all(color: kTabBarLine)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.calendar_today,
                                color: kUILight2,
                                size: 18,
                              ),
                            ),
                            Center(
                                child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  focusColor: Colors.white,
                                  isDense: true,
                                  value: selectedQueryDay,
                                  borderRadius: BorderRadius.circular(20),
                                  items: qureyDays.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: TextStyle(
                                          color: kPrimary1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) async {
                                    setState(() {
                                      selectedQueryDay = value!;
                                    });
                                    getDataByDays(value);
                                  }),
                            )
                                // Text(
                                //   'Past 90 Days',
                                //   style: GoogleFonts.poppins(
                                //     fontWeight: FontWeight.w400,
                                //     fontSize: 14,
                                //   ),
                                // ),
                                ),
                            // InkWell(
                            //   onTap: () {},
                            //   child: Icon(
                            //     Icons.keyboard_arrow_down,
                            //     size: 23,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 300,
                        decoration: BoxDecoration(border: Border.all(color: kTabBarLine)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  DateFormat('MMM-dd-yyyy').format(startDate),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500, fontSize: 14, color: kPrimary1),
                                ),
                              ),
                              Center(
                                child: Text(
                                  ' to ',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xff8F8F8F),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  DateFormat('MMM-dd-yyyy').format(endDate),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500, fontSize: 14, color: kPrimary1),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    showDatePickerDialogue();
                                  },
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: kTabBarLine,
                  ),
                  SizedBox(height: 67),
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
                          height: 621,
                          child: TabBarView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Container(
                                      width: 1170,
                                      height: 621,
                                      decoration: BoxDecoration(
                                        color: kColorWhite,
                                      ),
                                      child: InteractiveViewer(
                                        scaleEnabled: false,
                                        constrained: false,
                                        child: DataTable(
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
                                                label: Text('Product Name'),
                                              ),
                                              DataColumn(
                                                label: Text('Category'),
                                              ),
                                              DataColumn(
                                                label: Text('Price'),
                                              ),
                                              DataColumn(
                                                label: Text('Status'),
                                              ),
                                              DataColumn(
                                                label: Text('Date Created'),
                                              ),
                                            ],
                                            rows: lodgesData
                                                .map((e) => DataRow(cells: [
                                                      DataCell(
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            e.name!,
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            e.category!,
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            'R${e.price}',
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: e.adminStatus == 'Accepted'
                                                                        ? kPrimary1
                                                                        : e.adminStatus == 'Declined'
                                                                            ? kPrimary2
                                                                            : kColorOrange,
                                                                    width: 1,
                                                                    style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(20)),
                                                            width: 90,
                                                            height: 30,
                                                            child: SizedBox(
                                                                width: 90,
                                                                height: 30,
                                                                child: Center(
                                                                  child: DropdownButton(
                                                                      dropdownColor: Colors.white,
                                                                      focusColor: Colors.white,
                                                                      isDense: true,
                                                                      value: e.adminStatus,
                                                                      borderRadius:
                                                                          BorderRadius.circular(20),
                                                                      items: status.map((String items) {
                                                                        return DropdownMenuItem(
                                                                          value: items,
                                                                          child: Text(
                                                                            items,
                                                                            style: TextStyle(
                                                                              color: e.adminStatus ==
                                                                                      'Accepted'
                                                                                  ? kPrimary1
                                                                                  : e.adminStatus ==
                                                                                          'Declined'
                                                                                      ? kPrimary2
                                                                                      : kColorOrange,
                                                                              fontSize: 12,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                      onChanged: (value) async {
                                                                        setState(() {
                                                                          e.adminStatus = value;
                                                                        });
                                                                        await FirebaseFirestore.instance
                                                                            .collection('lodges')
                                                                            .doc(e.id)
                                                                            .update(
                                                                                {'adminStatus': value});
                                                                        getData();
                                                                      }),
                                                                ))),
                                                      ),
                                                      DataCell(
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 20),
                                                            Text(
                                                              DateFormat('dd MMM yyyy')
                                                                  .format(e.date!.toDate()),
                                                              style: TextStyle(
                                                                color: kUIDark,
                                                              ),
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              DateFormat('hh:mm a')
                                                                  .format(e.date!.toDate()),
                                                              style: TextStyle(
                                                                color: kUILight2,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]))
                                                .toList()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //accepted products
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Container(
                                      width: 1170,
                                      height: 621,
                                      decoration: BoxDecoration(
                                        color: kColorWhite,
                                      ),
                                      child: InteractiveViewer(
                                        scaleEnabled: false,
                                        constrained: false,
                                        child: DataTable(
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
                                                label: Text('Product Name'),
                                              ),
                                              DataColumn(
                                                label: Text('Category'),
                                              ),
                                              DataColumn(
                                                label: Text('Price'),
                                              ),
                                              DataColumn(
                                                label: Text('Status'),
                                              ),
                                              DataColumn(
                                                label: Text('Date Created'),
                                              ),
                                            ],
                                            rows: acceptedlodgesData
                                                .map((e) => DataRow(cells: [
                                                      DataCell(
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            e.name!,
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            e.category!,
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            'R${e.price}',
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: e.adminStatus == 'Accepted'
                                                                        ? kPrimary1
                                                                        : e.adminStatus == 'Declined'
                                                                            ? kPrimary2
                                                                            : kColorOrange,
                                                                    width: 1,
                                                                    style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(20)),
                                                            width: 90,
                                                            height: 30,
                                                            child: SizedBox(
                                                                width: 90,
                                                                height: 30,
                                                                child: Center(
                                                                  child: DropdownButton(
                                                                      dropdownColor: Colors.white,
                                                                      focusColor: Colors.white,
                                                                      isDense: true,
                                                                      value: e.adminStatus,
                                                                      borderRadius:
                                                                          BorderRadius.circular(20),
                                                                      items: status.map((String items) {
                                                                        return DropdownMenuItem(
                                                                          value: items,
                                                                          child: Text(
                                                                            items,
                                                                            style: TextStyle(
                                                                              color: e.adminStatus ==
                                                                                      'Accepted'
                                                                                  ? kPrimary1
                                                                                  : e.adminStatus ==
                                                                                          'Declined'
                                                                                      ? kPrimary2
                                                                                      : kColorOrange,
                                                                              fontSize: 12,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                      onChanged: (value) async {
                                                                        setState(() {
                                                                          e.adminStatus = value;
                                                                        });
                                                                        await FirebaseFirestore.instance
                                                                            .collection('lodges')
                                                                            .doc(e.id)
                                                                            .update(
                                                                                {'adminStatus': value});
                                                                        getData();
                                                                      }),
                                                                ))),
                                                      ),
                                                      DataCell(
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 20),
                                                            Text(
                                                              DateFormat('dd MMM yyyy')
                                                                  .format(e.date!.toDate()),
                                                              style: TextStyle(
                                                                color: kUIDark,
                                                              ),
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              DateFormat('hh:mm a')
                                                                  .format(e.date!.toDate()),
                                                              style: TextStyle(
                                                                color: kUILight2,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]))
                                                .toList()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //declined
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Container(
                                      width: 1170,
                                      height: 621,
                                      decoration: BoxDecoration(
                                        color: kColorWhite,
                                      ),
                                      child: InteractiveViewer(
                                        scaleEnabled: false,
                                        constrained: false,
                                        child: DataTable(
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
                                                label: Text('Product Name'),
                                              ),
                                              DataColumn(
                                                label: Text('Category'),
                                              ),
                                              DataColumn(
                                                label: Text('Price'),
                                              ),
                                              DataColumn(
                                                label: Text('Status'),
                                              ),
                                              DataColumn(
                                                label: Text('Date Created'),
                                              ),
                                            ],
                                            rows: diclinelodgesData
                                                .map((e) => DataRow(cells: [
                                                      DataCell(
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            e.name!,
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            e.category!,
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            'R${e.price}',
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: e.adminStatus == 'Accepted'
                                                                        ? kPrimary1
                                                                        : e.adminStatus == 'Declined'
                                                                            ? kPrimary2
                                                                            : kColorOrange,
                                                                    width: 1,
                                                                    style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(20)),
                                                            width: 90,
                                                            height: 30,
                                                            child: SizedBox(
                                                                width: 90,
                                                                height: 30,
                                                                child: Center(
                                                                  child: DropdownButton(
                                                                      dropdownColor: Colors.white,
                                                                      focusColor: Colors.white,
                                                                      isDense: true,
                                                                      value: e.adminStatus,
                                                                      borderRadius:
                                                                          BorderRadius.circular(20),
                                                                      items: status.map((String items) {
                                                                        return DropdownMenuItem(
                                                                          value: items,
                                                                          child: Text(
                                                                            items,
                                                                            style: TextStyle(
                                                                              color: e.adminStatus ==
                                                                                      'Accepted'
                                                                                  ? kPrimary1
                                                                                  : e.adminStatus ==
                                                                                          'Declined'
                                                                                      ? kPrimary2
                                                                                      : kColorOrange,
                                                                              fontSize: 12,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                      onChanged: (value) async {
                                                                        setState(() {
                                                                          e.adminStatus = value;
                                                                        });
                                                                        await FirebaseFirestore.instance
                                                                            .collection('lodges')
                                                                            .doc(e.id)
                                                                            .update(
                                                                                {'adminStatus': value});
                                                                        getData();
                                                                      }),
                                                                ))),
                                                      ),
                                                      DataCell(
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 20),
                                                            Text(
                                                              DateFormat('dd MMM yyyy')
                                                                  .format(e.date!.toDate()),
                                                              style: TextStyle(
                                                                color: kUIDark,
                                                              ),
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              DateFormat('hh:mm a')
                                                                  .format(e.date!.toDate()),
                                                              style: TextStyle(
                                                                color: kUILight2,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]))
                                                .toList()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //pending products
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Container(
                                      width: 1170,
                                      height: 621,
                                      decoration: BoxDecoration(
                                        color: kColorWhite,
                                      ),
                                      child: InteractiveViewer(
                                        scaleEnabled: false,
                                        constrained: false,
                                        child: DataTable(
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
                                                label: Text('Product Name'),
                                              ),
                                              DataColumn(
                                                label: Text('Category'),
                                              ),
                                              DataColumn(
                                                label: Text('Price'),
                                              ),
                                              DataColumn(
                                                label: Text('Status'),
                                              ),
                                              DataColumn(
                                                label: Text('Date Created'),
                                              ),
                                            ],
                                            rows: pendinglodgesData
                                                .map((e) => DataRow(cells: [
                                                      DataCell(
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            e.name!,
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            e.category!,
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            'R${e.price}',
                                                            style: TextStyle(
                                                              color: kUIDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: e.adminStatus == 'Accepted'
                                                                        ? kPrimary1
                                                                        : e.adminStatus == 'Declined'
                                                                            ? kPrimary2
                                                                            : kColorOrange,
                                                                    width: 1,
                                                                    style: BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(20)),
                                                            width: 90,
                                                            height: 30,
                                                            child: SizedBox(
                                                                width: 90,
                                                                height: 30,
                                                                child: Center(
                                                                  child: DropdownButton(
                                                                      dropdownColor: Colors.white,
                                                                      focusColor: Colors.white,
                                                                      isDense: true,
                                                                      value: e.adminStatus,
                                                                      borderRadius:
                                                                          BorderRadius.circular(20),
                                                                      items: status.map((String items) {
                                                                        return DropdownMenuItem(
                                                                          value: items,
                                                                          child: Text(
                                                                            items,
                                                                            style: TextStyle(
                                                                              color: e.adminStatus ==
                                                                                      'Accepted'
                                                                                  ? kPrimary1
                                                                                  : e.adminStatus ==
                                                                                          'Declined'
                                                                                      ? kPrimary2
                                                                                      : kColorOrange,
                                                                              fontSize: 12,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                      onChanged: (value) async {
                                                                        setState(() {
                                                                          e.adminStatus = value;
                                                                        });
                                                                        await FirebaseFirestore.instance
                                                                            .collection('lodges')
                                                                            .doc(e.id)
                                                                            .update(
                                                                                {'adminStatus': value});
                                                                        getData();
                                                                      }),
                                                                ))),
                                                      ),
                                                      DataCell(
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 20),
                                                            Text(
                                                              DateFormat('dd MMM yyyy')
                                                                  .format(e.date!.toDate()),
                                                              style: TextStyle(
                                                                color: kUIDark,
                                                              ),
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              DateFormat('hh:mm a')
                                                                  .format(e.date!.toDate()),
                                                              style: TextStyle(
                                                                color: kUILight2,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
      QuerySnapshot lodgeSnap = await FirebaseFirestore.instance.collection('lodges').get();

      if (lodgeSnap.docs.isNotEmpty) {
        setState(() {
          lodgesData =
              lodgeSnap.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
          acceptedlodgesData = lodgesData.where((element) => element.adminStatus == 'Accepted').toList();
          pendinglodgesData = lodgesData.where((element) => element.adminStatus == 'Pending').toList();
          diclinelodgesData = lodgesData.where((element) => element.adminStatus == 'Declined').toList();
          lodgesNames = lodgesData.map((e) => e.name!).toList();
          temp = lodgesData;
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
        lodgesData = temp.where((element) => element.name == value).toList();
        //gettin pendigs, accepted,rejected

        acceptedlodgesData = lodgesData.where((element) => element.adminStatus == 'Accepted').toList();
        pendinglodgesData = lodgesData.where((element) => element.adminStatus == 'Pending').toList();
        diclinelodgesData = lodgesData.where((element) => element.adminStatus == 'Declined').toList();
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

  void getAllDatabyAll() {
    // lodgesData.clear();
    // acceptedlodgesData.clear();
    // diclinelodgesData.clear();
    // pendinglodgesData.clear();

    try {
      setState(() {
        lodgesData = temp;
        //gettin pendigs, accepted,rejected

        acceptedlodgesData = lodgesData.where((element) => element.adminStatus == 'Accepted').toList();
        pendinglodgesData = lodgesData.where((element) => element.adminStatus == 'Pending').toList();
        diclinelodgesData = lodgesData.where((element) => element.adminStatus == 'Declined').toList();
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

  Future getDataByDays(String? value) async {
    DateTime searchDate = DateTime.now(); //'', '', 'Past 90 days'
    if (value == 'Past 7 days') {
      setState(() {
        searchDate = DateTime.now().subtract(Duration(days: 8));
      });
    } else if (value == 'Past 30 days') {
      setState(() {
        searchDate = DateTime.now().subtract(Duration(days: 31));
      });
    } else {
      setState(() {
        searchDate = DateTime.now().subtract(Duration(days: 91));
      });
    }
    lodgesData.clear();
    acceptedlodgesData.clear();
    pendinglodgesData.clear();
    diclinelodgesData.clear();

    setState(() {
      isLoading = true;
    });
    try {
      //getting lodges data
      QuerySnapshot lodgeSnap = await FirebaseFirestore.instance
          .collection('lodges')
          .where('date', isGreaterThan: searchDate)
          .get();

      if (lodgeSnap.docs.isNotEmpty) {
        setState(() {
          lodgesData =
              lodgeSnap.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
          acceptedlodgesData = lodgesData.where((element) => element.adminStatus == 'Accepted').toList();
          pendinglodgesData = lodgesData.where((element) => element.adminStatus == 'Pending').toList();
          diclinelodgesData = lodgesData.where((element) => element.adminStatus == 'Declined').toList();
          lodgesNames = lodgesData.map((e) => e.name!).toList();
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

  //showing date picker for selecting range

  showDatePickerDialogue() async {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  content: Container(
                    width: 600,
                    height: 500,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 400,
                            width: 590,
                            child: SfDateRangePicker(
                              selectionMode: DateRangePickerSelectionMode.range,
                              enableMultiView: true,
                              viewSpacing: 20,
                              headerStyle: DateRangePickerHeaderStyle(
                                textAlign: TextAlign.center,
                              ),
                              onSelectionChanged: (args) => {
                                if (args.value is PickerDateRange)
                                  {
                                    setState(() {
                                      startDate = args.value.startDate ?? DateTime.now();
                                      endDate = args.value.endDate ?? DateTime.now();
                                    })
                                  }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: kPrimary1),
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              InkWell(
                                onTap: () {
                                  getDataByDates(startDate, endDate);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Ok',
                                  style: TextStyle(color: kPrimary1),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )));
  }

  Future getDataByDates(DateTime startDate, DateTime endDate) async {
    lodgesData.clear();
    acceptedlodgesData.clear();
    pendinglodgesData.clear();
    diclinelodgesData.clear();

    setState(() {
      isLoading = true;
    });
    try {
      //getting lodges data
      QuerySnapshot lodgeSnap = await FirebaseFirestore.instance
          .collection('lodges')
          .where('date', isGreaterThan: startDate)
          .get();

      if (lodgeSnap.docs.isNotEmpty) {
        setState(() {
          lodgesData =
              lodgeSnap.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
        });
      }
      setState(() {
        lodgesData = lodgesData
            .where((element) => element.date!.toDate().isBefore(endDate.add(Duration(days: 1))))
            .toList();
        acceptedlodgesData = lodgesData.where((element) => element.adminStatus == 'Accepted').toList();
        pendinglodgesData = lodgesData.where((element) => element.adminStatus == 'Pending').toList();
        diclinelodgesData = lodgesData.where((element) => element.adminStatus == 'Declined').toList();
        lodgesNames = lodgesData.map((e) => e.name!).toList();
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
    } finally {
      isLoading = false;
      setState(() {});
    }
  }
}
