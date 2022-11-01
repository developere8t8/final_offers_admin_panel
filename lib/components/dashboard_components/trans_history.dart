// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_offer_admin_panel/widgets/side_bar.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/lodge.dart';

class TransHistory extends StatefulWidget {
  final List<LodgeData> data;

  const TransHistory({Key? key, required this.data}) : super(key: key);

  @override
  State<TransHistory> createState() => _TransHistoryState();
}

class _TransHistoryState extends State<TransHistory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Container(
          width: 620,
          height: 737,
          decoration: BoxDecoration(
            color: kColorWhite,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
                dataRowHeight: 80.0,
                horizontalMargin: 46,
                headingTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kUIDark),
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
                    label: Text('Product name'),
                  ),
                  DataColumn(
                    label: Text('Offers'),
                  ),
                  DataColumn(
                    label: Text('Status'),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ],
                rows: widget.data
                    .map((e) => DataRow(cells: [
                          DataCell(Text(
                            e.name!,
                            style: TextStyle(
                              color: kUIDark,
                            ),
                          )),
                          DataCell(
                            Wrap(
                              children: [
                                Image.asset(
                                  'assets/icons/Tag.png',
                                  scale: 5,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(e.bookings!.toString())
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              e.adminStatus!,
                              style: TextStyle(
                                  color: e.adminStatus == 'Accepted'
                                      ? kPrimary1
                                      : e.adminStatus == 'Pending'
                                          ? kColorOrange
                                          : e.adminStatus == 'Declined'
                                              ? kPrimary2
                                              : kUIDark),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SideBar(
                                              page: 1,
                                            )));
                              },
                              icon: Image.asset('assets/icons/eye.png'),
                            ),
                          ),
                        ]))
                    .toList()),
          ),
        ),
      ),
    );
  }
}
