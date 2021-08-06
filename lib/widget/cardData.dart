import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logbook_management/models/mahasiswa.dart';
import 'package:logbook_management/utils/constants.dart';

Widget textRow(String textOne, String textTwo) {
  return Wrap(
    children: [
      Text(
        "$textOne:",
        style: TextStyle(
          color: Color.fromRGBO(74, 77, 84, 0.7),
          fontSize: 14.0,
        ),
      ),
      SizedBox(
        width: 4.0,
      ),
      Text(
        textTwo,
        style: TextStyle(
          color: Color.fromRGBO(19, 22, 33, 1),
          fontSize: 14.0,
        ),
      ),
    ],
  );
}

class CardData extends StatelessWidget {
  final String judul;
  final String complitation;
  final String tanggal;
  final String by;
  final Function onBuka;

  CardData(this.judul, this.complitation, this.tanggal, this.by, {this.onBuka});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.grey[300],
            spreadRadius: .8,
            offset: Offset(0, 4),
          )
        ],
      ),
      height: ScreenUtil().setHeight(125.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            if (onBuka != null) onBuka();
          },
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 25.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        judul,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      textRow("By ", by),
                      Row(
                        children: [
                          textRow("Complitation %", complitation + " %"),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            child: textRow("Tanggal ", tanggal),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
