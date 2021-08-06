import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logbook_management/db/db_mhs.dart';
import 'package:logbook_management/models/mahasiswa.dart';
import 'package:logbook_management/pages/detail_data.dart';
import 'package:logbook_management/pages/detailmhs.dart';
import 'package:logbook_management/widget/cardData.dart';
import 'package:logbook_management/widget/item_card.dart';
import 'dart:async';

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  List<Mahasiswa> mahasiswa = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMahasiswa();
  }

  Future refreshMahasiswa() async {
    setState(() => isLoading = true);

    this.mahasiswa = await MhsDatabase.instance.readAllMahasiswa();

    setState(() => isLoading = false);
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
                  "Data Kegiatan",
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
                  stream: data
                      .where("uid", isEqualTo: currentUser.uid)
                      .orderBy('tanggal')
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.docs
                            .map<Widget>((e) => CardData(
                                  e.data()["kegiatan"],
                                  e.data()['complitation'],
                                  e.data()['tanggal'],
                                  onBuka: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailData(
                                              id: e.id,
                                              by: e.data()["by"],
                                              kegiatan: e.data()["kegiatan"],
                                              complitation:
                                                  e.data()["complitation"],
                                              tgl: e.data()["tanggal"])),
                                    );
                                  },
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

          // StreamBuilder(
          //   stream: data.snapshots(),
          //     builder: (_,snapshot){
          //     if(snapshot.hasData){
          //       return Column(
          //         children: snapshot.data.docs
          //             .map<Widget>((e) =>
          //             ItemCard(e.data()["kegiatan"], e.data()['complitation'],e.data()['tanggal']))
          //             .toList(),
          //       );
          //     }
          //     else{
          //       return CircularProgressIndicator();
          //     }
          //   }),
          // FutureBuilder(
          //   future: data.get(),
          //   builder: (_,snapshot){
          //     if(snapshot.hasData){
          //       return Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(8.0),
          //           boxShadow: [
          //             BoxShadow(
          //               blurRadius: 5,
          //               color: Colors.grey[300],
          //               spreadRadius: .8,
          //               offset: Offset(0, 4),
          //             )
          //           ],
          //         ),
          //         child: Material(
          //           color: Colors.transparent,
          //           child: InkWell(
          //             borderRadius: BorderRadius.circular(8.0),
          //             onTap: () {
          //
          //             },
          //             child: Column(
          //               children: snapshot.data.docs
          //                   .map<Widget>((e) =>
          //                     CardData(e.data()["kegiatan"], e.data()['complitation'],e.data()['tanggal']))
          //                   .toList(),
          //             )
          //           ),
          //         ),
          //       );
          //     }
          //     else{
          //       return CircularProgressIndicator();
          //     }
          //   }),
        ],
      ),
    );
  }
}
