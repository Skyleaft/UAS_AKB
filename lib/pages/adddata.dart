import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logbook_management/models/mahasiswa.dart';
import 'package:logbook_management/utils/constants.dart';
import 'dart:async';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:logbook_management/db/db_mhs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

var txtKegiatan = TextEditingController();
var tanggal = TextEditingController();
var txtcomplitation = TextEditingController();

void clearText() {
  txtKegiatan.text = "";
  tanggal.text = "";
  txtcomplitation.text = "";
}

var _btnController2 = RoundedLoadingButtonController();

class AddData extends StatelessWidget {
  const AddData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference data = firestore.collection('data');

    return Container(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Constants.scaffoldBackgroundColor,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Insert Log Book",
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Color.fromRGBO(74, 77, 84, 1),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: txtKegiatan,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Kegiatan',
                counterText: "",
              ),
              maxLength: 40,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: txtcomplitation,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Complitation %',
                counterText: "",
              ),
              maxLength: 2,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              readOnly: true,
              controller: tanggal,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tanggal',
                counterText: "",
              ),
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2016, 1, 1),
                    onChanged: (date) {
                      String formtgl = date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString();
                      tanggal.text = formtgl;
                }, onConfirm: (date) {
                  String formtgl = date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString();
                  tanggal.text = formtgl;
                  print('confirm $date');
                }, currentTime: DateTime.now());
              },
              maxLength: 20,
            ),
            SizedBox(
              height: 15.0,
            ),
            RoundedLoadingButton(
              width: MediaQuery.of(context).size.width,
              color: Constants.primaryColor,
              successColor: Colors.green[800],
              controller: _btnController2,
              onPressed: () {
                data.add({
                  'kegiatan': txtKegiatan.text,
                  'complitation': txtcomplitation.text,
                  'tanggal': tanggal.text,
                  'uid': currentUser.uid,
                  'by': currentUser.displayName,
                });
                clearText();
                _btnController2.reset();
              },
              borderRadius: 6,
              child: Text('Simpan Data', style: TextStyle(color: Colors.white)),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: Constants.primaryColor,
                    textStyle: TextStyle(fontSize: 16)),
                onPressed: () {
                  clearText();
                },
                child: const Text("Clear"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
