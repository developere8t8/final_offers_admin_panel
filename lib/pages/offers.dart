// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/buttons.dart';

class Offers extends StatefulWidget {
  Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  bool value = false;
  final _controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kColorWhite,
            elevation: 0,
            title: const Text(
              'Offers',
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
                      'Green Valley Lodge',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: kColorBlack),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://pix10.agoda.net/hotelImages/445543/-1/4a23821ee052b54680d947fe07a23e16.jpg?ca=10&ce=1&s=1024x768'),
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
                    child: TextField(
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kUILight2),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          size: 17,
                        ),
                        suffixIcon: Icon(
                          CupertinoIcons.mic_fill,
                          size: 17,
                        ),
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
                    ),
                  ),
                  SizedBox(height: 28),
                  TabBar(
                    isScrollable: true,
                    labelPadding: EdgeInsets.symmetric(horizontal: 35),
                    indicatorPadding: EdgeInsets.zero,
                    indicatorColor: kPrimary2,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: kPrimary2,
                    unselectedLabelColor: kUILight2,
                    labelStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    unselectedLabelStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    indicatorWeight: 3,
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'Accepted'),
                      Tab(text: 'Declined'),
                      Tab(text: 'Pending'),
                      Tab(text: 'Recently Deleted'),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: kTabBarLine,
                  ),
                  SizedBox(height: 67),
                  SizedBox(
                    width: 1597,
                    height: 611,
                    child: TabBarView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: Container(
                                width: 1597,
                                height: 611,
                                decoration: BoxDecoration(
                                  color: kColorWhite,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
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
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                        (states) {
                                          return Color(0xFFF3F3F3);
                                        },
                                      ),
                                      columns: <DataColumn>[
                                        DataColumn(
                                          label: Text('Product Name'),
                                        ),
                                        DataColumn(
                                          label: Text('Lodge Name'),
                                        ),
                                        DataColumn(
                                          label: Text('User'),
                                        ),
                                        DataColumn(
                                          label: Text('Price'),
                                        ),
                                        DataColumn(
                                          label: Text('Offered'),
                                        ),
                                        DataColumn(
                                          label: Text('Status'),
                                        ),
                                        DataColumn(
                                          label: Text('Date Created'),
                                        ),
                                        DataColumn(
                                          label: Text('Condition'),
                                        ),
                                        DataColumn(
                                          label: Text('Payment'),
                                        ),
                                        DataColumn(
                                          label: Text(''),
                                        ),
                                      ],
                                      rows: <DataRow>[
                                        DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: value,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    onChanged: (value) =>
                                                        setState(() => this
                                                            .value = value!),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 20),
                                                      Text(
                                                        'Sabi Sands 2 nights special',
                                                        style: TextStyle(
                                                          color: kUIDark,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3),
                                                      Text(
                                                        'Ref no: #25014287',
                                                        style: TextStyle(
                                                          color: kUILight2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                'Safari Sands',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: kPrimary1,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                'Ammar Khawar',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: kPrimary1,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                'R15000',
                                                style:
                                                    TextStyle(color: kUIDark),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                'R15000',
                                                style:
                                                    TextStyle(color: kUIDark),
                                              ),
                                            ),
                                            DataCell(
                                              SizedBox(
                                                width: 104,
                                                height: 30,
                                                child: FixedSecondary(
                                                    buttonText: 'Accepted',
                                                    ontap: () {}),
                                              ),
                                            ),
                                            DataCell(
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 20),
                                                  Text(
                                                    '18 July 2022',
                                                    style: TextStyle(
                                                      color: kUIDark,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'At 8:45 PM',
                                                    style: TextStyle(
                                                      color: kUILight2,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                '48H',
                                                style: TextStyle(
                                                  color: kColorOrange,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              SizedBox(
                                                width: 72,
                                                height: 30,
                                                child: FixedSecondary(
                                                    buttonText: 'Paid',
                                                    ontap: () {}),
                                              ),
                                            ),
                                            DataCell(
                                              Column(
                                                children: [
                                                  SizedBox(height: 20),
                                                  Image.asset(
                                                    'assets/icons/eye.png',
                                                    scale: 5,
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    'View',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kPrimary1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(),
                        Column(),
                        Column(),
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
}
