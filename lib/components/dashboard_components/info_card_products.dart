// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_offer_admin_panel/models/company.dart';
import 'package:final_offer_admin_panel/models/lodge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../models/bardata.dart';
import '../../models/data.dart';
import '../../models/users.dart';
import '../../widgets/bar_chart.dart';
import '../../widgets/side_bar.dart';

class InfoCardProducts extends StatefulWidget {
  final List<LodgeData> lodgesData;

  const InfoCardProducts({Key? key, required this.lodgesData}) : super(key: key);

  @override
  State<InfoCardProducts> createState() => _InfoCardProducts();
}

class _InfoCardProducts extends State<InfoCardProducts> {
  List<LodgeData> activeLodges = [];

  List distinctDate = []; //for distinct dates
  List? day1;
  List? day2;
  List? day3;
  List? day4;
  List? day5;
  List? day6;
  List? day7;
  List<Data>? listData = [];

  BarData? data;

  @override
  void initState() {
    serilaizedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 320,
        height: 154,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: kColorAqua,
          boxShadow: [
            BoxShadow(
              color: kBoxShadowColor,
              offset: Offset(19, 19),
              blurRadius: 47,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 20,
              child: Text(
                'Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kUIDark,
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 70,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SideBar(
                                page: 1,
                              )));
                },
                icon: Image.asset('assets/icons/eye.png'),
              ),
            ),
            Positioned(
              top: 15,
              right: 30,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset('assets/icons/copy.png'),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 30,
              child: Text(
                activeLodges.length.toString(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: kPrimary1,
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 10,
              child: Text(
                'Active',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kUILight2,
                ),
              ),
            ),
            Positioned(
              left: 90,
              bottom: 30,
              child: Text(
                widget.lodgesData.length.toString(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: kPrimary1,
                ),
              ),
            ),
            Positioned(
              left: 90,
              bottom: 10,
              child: Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kUILight2,
                ),
              ),
            ),
            Positioned(
                left: 100,
                bottom: 10,
                child: SizedBox(
                  height: 90,
                  width: 240,
                  child: BarChartWidget(
                    data: listData!,
                  ),
                ))
          ],
        ));
  }

  serilaizedData() {
    //getting range from previous 7 days
    DateTime startDate = DateTime.now().subtract(Duration(days: 7));
    for (int i = 0; i < 7; i++) {
      setState(() {
        distinctDate.add(DateFormat('yyyy-MM-dd').format(startDate.add(Duration(days: i - 1))));
      });
    }
    setState(() {
      activeLodges = widget.lodgesData
          .where(
              (element) => element.date!.toDate().isAfter(DateTime.now().subtract(Duration(days: 31))))
          .toList();
      //getting everyday count
      day1 = widget.lodgesData.where((element) => element.date! == distinctDate[0]).toList();
      day2 = widget.lodgesData.where((element) => element.date! == distinctDate[1]).toList();
      day3 = widget.lodgesData.where((element) => element.date! == distinctDate[2]).toList();
      day4 = widget.lodgesData.where((element) => element.date! == distinctDate[3]).toList();
      day5 = widget.lodgesData.where((element) => element.date! == distinctDate[4]).toList();
      day6 = widget.lodgesData.where((element) => element.date! == distinctDate[5]).toList();
      day7 = widget.lodgesData.where((element) => element.date! == distinctDate[6]).toList();
      //getting ready bar data
      listData!.add(Data(
          id: 0,
          name: DateFormat('EEE').format(DateTime.parse(distinctDate[0])),
          y: day1!.isEmpty ? 0 : day1!.length));
      listData!.add(Data(
          id: 1,
          name: DateFormat('EEE').format(DateTime.parse(distinctDate[1])),
          y: day2!.isEmpty ? 0 : day2!.length));
      listData!.add(Data(
          id: 2,
          name: DateFormat('EEE').format(DateTime.parse(distinctDate[2])),
          y: day3!.isEmpty ? 0 : day3!.length));
      listData!.add(Data(
          id: 3,
          name: DateFormat('EEE').format(DateTime.parse(distinctDate[3])),
          y: day4!.isEmpty ? 0 : day4!.length));
      listData!.add(Data(
          id: 4,
          name: DateFormat('EEE').format(DateTime.parse(distinctDate[4])),
          y: day5!.isEmpty ? 0 : day5!.length));
      listData!.add(Data(
          id: 5,
          name: DateFormat('EEE').format(DateTime.parse(distinctDate[5])),
          y: day6!.isEmpty ? 0 : day6!.length));
      listData!.add(Data(
          id: 6,
          name: DateFormat('EEE').format(DateTime.parse(distinctDate[6])),
          y: day7!.isEmpty ? 0 : day7!.length));
    });
  }
}
