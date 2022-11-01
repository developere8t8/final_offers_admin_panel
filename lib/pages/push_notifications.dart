// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:final_offer_admin_panel/models/notificationdata.dart';
import 'package:firebase_notification_scheduler/firebase_notification_scheduler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import '../constants.dart';
import '../models/admins.dart';
import '../models/users.dart';
import '../widgets/buttons.dart';
import '../widgets/error.dart';
import '../widgets/text_field.dart';
import 'package:intl/intl.dart';

class PushNotifications extends StatefulWidget {
  const PushNotifications({super.key});

  @override
  State<PushNotifications> createState() => _PushNotificationsState();
}

class _PushNotificationsState extends State<PushNotifications> {
  TextEditingController message = TextEditingController();
  DateTime sendingDate = DateTime.now();
  TimeOfDay time = TimeOfDay(hour: 09, minute: 00);
  // List<ScheduledNotification> allSchudled = []; //from api
  List<NotificationsData> schuldedmessges = []; //from firebase

  bool isLoading = false;
  AdminData? data;
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseNotificationScheduler firebaseNotificationScheduler =
      FirebaseNotificationScheduler(authenticationKey: schulderkey, rapidApiKey: rapidApikey);
  @override
  void initState() {
    getData();
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
            'Push Notifications',
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
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      SizedBox(height: 53),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: kUIDark,
                                ),
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2021),
                                      lastDate: DateTime(2099));

                                  if (picked != null) {
                                    setState(() {
                                      sendingDate = picked;
                                    });
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.only(left: 20, right: 05),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: kUILight, style: BorderStyle.solid),
                                        borderRadius: BorderRadius.circular(5)),
                                    width: 261,
                                    height: 49,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('MMM dd yyyy').format(sendingDate),
                                          style: TextStyle(
                                            color: kPrimary1,
                                          ),
                                        ),
                                        Icon(
                                          CupertinoIcons.arrow_down,
                                          color: kUILight2,
                                          size: 15,
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: kUIDark,
                                ),
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () async {
                                  TimeOfDay? picked =
                                      await showTimePicker(context: context, initialTime: time);
                                  if (picked != null) {
                                    setState(() {
                                      time = picked;
                                    });
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.only(left: 20, right: 05),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: kUILight, style: BorderStyle.solid),
                                        borderRadius: BorderRadius.circular(5)),
                                    width: 261,
                                    height: 49,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${time.hour}:${time.minute}',
                                          style: TextStyle(
                                            color: kPrimary1,
                                          ),
                                        ),
                                        Icon(
                                          CupertinoIcons.arrow_down,
                                          color: kUILight2,
                                          size: 15,
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 17),
                      SizedBox(
                        width: 542,
                        child: TextField(
                          controller: message,
                          maxLines: 5,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kUILight2),
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
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: kUILight2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 33),
                      SizedBox(
                        width: 543,
                        height: 52,
                        child: FixedPrimary(
                            buttonText: 'Create',
                            ontap: () {
                              sendPushMessage('Notification', message.text, 'all');
                            }),
                      ),
                      SizedBox(height: 75),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Container(
                          width: 1170,
                          height: 357,
                          decoration: BoxDecoration(
                            color: kColorWhite,
                          ),
                          child: SingleChildScrollView(
                            child: DataTable(
                                dataRowHeight: 80.0,
                                horizontalMargin: 46,
                                headingTextStyle:
                                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kUIDark),
                                dataTextStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (states) {
                                    return Color(0xFFF3F3F3);
                                  },
                                ),
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Text('Notification'),
                                  ),
                                  DataColumn(
                                    label: Text('Scheduled For'),
                                  ),
                                  DataColumn(
                                    label: Text(''),
                                  ),
                                ],
                                rows: schuldedmessges
                                    .map((e) => DataRow(cells: [
                                          DataCell(SizedBox(
                                            width: 200,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    e.message.toString(),
                                                    style: TextStyle(color: kUIDark),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                          DataCell(
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 20),
                                                Text(
                                                  DateFormat('hh:mm a').format(e.schulded!.toDate()),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      color: kUIDark),
                                                ),
                                                SizedBox(height: 3),
                                                Text(
                                                  DateFormat('MMM dd yyyy').format(e.schulded!.toDate()),
                                                  style: TextStyle(color: kUILight6),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataCell(InkWell(
                                            onTap: () {
                                              deleteNotifications(e.msgid!);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ErrorDialog(
                                                          title: 'Success',
                                                          message: 'Notification Deleted',
                                                          type: 'R',
                                                          function: () {
                                                            Navigator.pop(context);
                                                          },
                                                          buttontxt: 'Close')));
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(height: 20),
                                                Icon(Icons.delete),
                                                SizedBox(height: 6),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                      color: kPrimary1),
                                                ),
                                              ],
                                            ),
                                          )),
                                        ]))
                                    .toList()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  //getting data
  Future getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('admins').where('id', isEqualTo: user.uid).get();

    if (snap.docs.isNotEmpty) {
      data = AdminData.fromMap(snap.docs.first.data() as Map<String, dynamic>);
    }
    getNotificationlist();
    setState(() {
      isLoading = false;
    });
  }

//sending push notification screen
  sendPushMessage(String title, String body, String topic) async {
    setState(() {
      isLoading = true;
    });

    try {
      String payLoad = {
        'notification': {'body': body, 'title': title, "sound": "default"},
        'priority': 'high',
        'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'status': 'done'},
        "to": '/topics/$topic',
      }.toString();
      final DateTime now = DateTime.now().toUtc();
      final DateTime dateTimeInUtc = now.add(const Duration(minutes: 1));

      String msgID = await firebaseNotificationScheduler.scheduleNotification(
          payload: payLoad, dateTimeInUtc: dateTimeInUtc);

      final newNotification =
          FirebaseFirestore.instance.collection('notifications').doc(msgID); //for notification record

      NotificationsData notiData = NotificationsData(
          id: msgID,
          message: message.text,
          msgid: msgID,
          date: Timestamp.fromDate(DateTime.now()),
          schulded: Timestamp.fromDate(
              DateTime(sendingDate.year, sendingDate.month, sendingDate.day, time.hour, time.minute)));
      await newNotification.set(notiData.toMap());

      //sendign notification to all users
      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection('users').where('status', isEqualTo: true).get();
      List<Users> users = snap.docs.map((e) => Users.fromMap(e.data() as Map<String, dynamic>)).toList();
      for (var noty in users) {
        final newuserNoti = FirebaseFirestore.instance
            .collection('users')
            .doc(noty.id)
            .collection('notification')
            .doc(msgID);
        UserNotification userNoti = UserNotification(
            date: Timestamp.fromDate(
                DateTime(sendingDate.year, sendingDate.month, sendingDate.day, time.hour, time.minute)),
            id: msgID,
            message: message.text,
            msgid: msgID,
            status: false);

        await newuserNoti.set(userNoti.toMap());
      }
      QuerySnapshot snapnew = await FirebaseFirestore.instance
          .collection('notifications')
          .where('schulded', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .get();

      setState(() {
        schuldedmessges = snapnew.docs
            .map((e) => NotificationsData.fromMap(e.data() as Map<String, dynamic>))
            .toList();
      });
      message.clear();
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

  //getting notifiaction list

  Future getNotificationlist() async {
    try {
      // List<ScheduledNotification> all =
      //     await firebaseNotificationScheduler.getAllScheduledNotification();

      // setState(() {
      //   allSchudled = all;
      // });
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('notifications')
          .where('schulded', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .get();

      setState(() {
        schuldedmessges =
            snap.docs.map((e) => NotificationsData.fromMap(e.data() as Map<String, dynamic>)).toList();
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

  Future deleteNotifications(String msgid) async {
    setState(() {
      isLoading = true;
    });
    firebaseNotificationScheduler.cancelNotification(messageId: msgid);
    await FirebaseFirestore.instance.collection('notifications').doc(msgid).delete();

    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('users').where('status', isEqualTo: true).get();
    List<Users> users = snap.docs.map((e) => Users.fromMap(e.data() as Map<String, dynamic>)).toList();
    for (var noty in users) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(noty.id)
          .collection('notification')
          .doc(msgid)
          .delete();
    }
    QuerySnapshot snapnew = await FirebaseFirestore.instance
        .collection('notifications')
        .where('schulded', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .get();

    setState(() {
      schuldedmessges =
          snapnew.docs.map((e) => NotificationsData.fromMap(e.data() as Map<String, dynamic>)).toList();
    });
    setState(() {
      isLoading = false;
    });
  }
}
