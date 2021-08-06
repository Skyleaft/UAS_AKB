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

final _formKey = GlobalKey<FormState>();

var _btnController2 = RoundedLoadingButtonController();

String checkDisplayName(var _user) {
  var finalDisplayName;
  if (_user.displayName == null) {
    finalDisplayName = _user.email;
  } else {
    finalDisplayName = _user.displayName;
  }
  return finalDisplayName;
}

class AddData extends StatelessWidget {
  const AddData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference data = firestore.collection('data');

    tanggal.text = DateTime.now().day.toString() +
        '/' +
        DateTime.now().month.toString() +
        '/' +
        DateTime.now().year.toString();

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
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: txtKegiatan,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Kegiatan',
                  counterText: "",
                ),
                maxLength: 50,
                validator: (val) => val.isNotEmpty ? null : "Harap Diisi",
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: txtcomplitation,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Complitation %',
                  counterText: "",
                ),
                maxLength: 3,
                validator: (val) => val.isNotEmpty ? null : "Harap Diisi",
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                readOnly: true,
                controller: tanggal,
                validator: (val) => val.isNotEmpty ? null : "Harap Diisi",
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tanggal',
                  counterText: "",
                ),
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2016, 1, 1), onChanged: (date) {
                    String formtgl = date.day.toString() +
                        "/" +
                        date.month.toString() +
                        "/" +
                        date.year.toString();
                    tanggal.text = formtgl;
                  }, onConfirm: (date) {
                    String formtgl = date.day.toString() +
                        "/" +
                        date.month.toString() +
                        "/" +
                        date.year.toString();
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
                  if (_formKey.currentState.validate()) {
                    data.add({
                      'kegiatan': txtKegiatan.text,
                      'complitation': txtcomplitation.text,
                      'tanggal': tanggal.text,
                      'uid': currentUser.uid,
                      'by': checkDisplayName(currentUser),
                    });
                    clearText();
                    _btnController2.success();
                    Fluttertoast.showToast(
                        msg: "Data Berhasil Disimpan",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        fontSize: 16.0);
                  }
                  Timer(Duration(seconds: 1), () {
                    _btnController2.reset();
                  });
                },
                borderRadius: 6,
                child:
                    Text('Simpan Data', style: TextStyle(color: Colors.white)),
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
      ),
    );
  }
}
