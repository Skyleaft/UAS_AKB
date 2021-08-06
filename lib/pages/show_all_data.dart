import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logbook_management/models/mahasiswa.dart';
import 'package:logbook_management/pages/detail_data.dart';
import 'package:logbook_management/widget/cardData.dart';
import 'dart:async';

class ShowAllData extends StatefulWidget {
  @override
  _ShowAllDataState createState() => _ShowAllDataState();
}

class _ShowAllDataState extends State<ShowAllData> {
  List<Mahasiswa> mahasiswa = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference data = firestore.collection('data');
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Semua Log Harian",
                  style: TextStyle(
                    color: Color.fromRGBO(19, 22, 33, 1),
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              StreamBuilder(
                  stream: data.orderBy('tanggal').snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.docs
                            .map<Widget>((e) => CardData(
                                  e.data()["kegiatan"],
                                  e.data()['complitation'],
                                  e.data()['tanggal'],
                                  e.data()["by"],
                                  onBuka: () {},
                                ))
                            .toList(),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
