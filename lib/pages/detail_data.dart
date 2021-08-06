import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logbook_management/db/db_mhs.dart';
import 'package:logbook_management/models/mahasiswa.dart';
import 'package:logbook_management/pages/adddata.dart';
import 'package:logbook_management/utils/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// ignore: must_be_immutable
class DetailData extends StatelessWidget {
  final String id;
  final String kegiatan;
  final String complitation;
  final String tgl;
  final String by;

  DetailData(
      {Key key, this.id, this.by, this.kegiatan, this.complitation, this.tgl})
      : super(key: key);

  var txtKegiatan = TextEditingController();
  var tanggal = TextEditingController();
  var txtcomplitation = TextEditingController();

  void getData() {
    txtKegiatan.text = this.kegiatan;
    txtcomplitation.text = this.complitation;
    tanggal.text = this.tgl;
  }

  @override
  Widget build(BuildContext context) {
    getData();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference data = firestore.collection('data');
    final Query currentData = data.where('id', isEqualTo: this.id);
    Future<void> _showMyDialog(String _tittle, String _msg) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(_tittle),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(_msg),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Tidak'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ya'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  data.doc(this.id).delete();
                  Fluttertoast.showToast(
                      msg: "Data Berhasil Dihapus",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      fontSize: 16.0);
                },
              ),
            ],
          );
        },
      );
    }

    void onClose() {
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/images/washing_machine_illustration.png",
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kToolbarHeight,
                    ),
                    GestureDetector(
                      onTap: () {
                        onClose();
                      },
                      child: Icon(
                        FlutterIcons.keyboard_backspace_mdi,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Details Log Kegiatan\n",
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          TextSpan(
                            text: by,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
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
                            "Detail",
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: Color.fromRGBO(74, 77, 84, 1),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                          ),
                          SizedBox(
                            height: 6.0,
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
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      height: ScreenUtil().setHeight(160.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Constants.primaryColor,
                            ),
                            onPressed: () {
                              data.doc(this.id).update({
                                'kegiatan': txtKegiatan.text,
                                'complitation': txtcomplitation.text,
                                'tanggal': tanggal.text
                              });
                              onClose();
                            },
                            child: const Text('Ubah'),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextButton.icon(
                            icon: Icon(FlutterIcons.trash_2_fea),
                            label: Text("Hapus"),
                            style: TextButton.styleFrom(
                                primary: Colors.red,
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              _showMyDialog(
                                  "Peringatan", "Yakin Data mau Dihapus?");
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getTotalRow(String title, String amount) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(19, 22, 33, 1),
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Text(
          amount,
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 17.0,
          ),
        )
      ],
    ),
  );
}

Widget getSubtotalRow(String title, String price) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Text(
          price,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
          ),
        )
      ],
    ),
  );
}

Widget getItemRow(String count, String item, String price) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          count,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            " x $item",
            style: TextStyle(
              color: Color.fromRGBO(143, 148, 162, 1),
              fontSize: 15.0,
            ),
          ),
        ),
        Text(
          price,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
          ),
        )
      ],
    ),
  );
}
