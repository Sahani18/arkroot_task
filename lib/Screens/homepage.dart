import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Nasa extends StatefulWidget {
  @override
  _NasaState createState() => _NasaState();
}

class _NasaState extends State<Nasa> {
  List data;
  String initialLink;
  String explaination = "";
  String title = "";
  int year, month, date;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        year = picked.year;
        month = picked.month;
        date = picked.day;
      });
      // _getNasaData();
    }
  }

  _getNasaData() async {
    //use DIO package
    Dio dio = new Dio();
    Response response;
    try {
      response = await dio.get(
          "https://api.nasa.gov/planetary/apod?api_key=aWPhODExHc5j48m59viPzCysv1jkoaN7ID2dchPw&date=$year-$month-$date");
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          initialLink = response.data['hdurl'].toString();
          explaination = response.data['explanation'].toString();
          title = response.data['title'].toString();
        });
      } else
        throw Exception('Error');
    } catch (e) {
      print(e);
    }
  }

  initialPage() async {
    int year, month, date;
    year = selectedDate.year;
    month = selectedDate.month;
    date = selectedDate.day;
    print(selectedDate.year);
    String link =
        "https://api.nasa.gov/planetary/apod?api_key=aWPhODExHc5j48m59viPzCysv1jkoaN7ID2dchPw&date=$year-$month-$date";
    Dio dio = new Dio();
    Response response;
    try {
      response = await dio.get(link);

      if (response.statusCode == 200) {
        print(response.data['hdurl']);
        setState(() {
          initialLink = response.data['hdurl'].toString();
        });
      } else
        throw Exception('Error');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    this.initialPage();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Arkroot Technologies'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _selectDate(context),
                    style: ButtonStyle(),
                    child: Text(
                      'Select Date',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  ElevatedButton(
                    onPressed: _getNasaData,
                    child: Text('Find'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              height: 300,
              width: width,
              child: initialLink == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Image.network(
                      "$initialLink",
                      fit: BoxFit.fill,
                    ),
            ),
            // Padding(padding: EdgeInsets.only(top: 20)),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              height: 500,
              margin: EdgeInsets.all(10),
              child: Expanded(
                child: Text(
                  explaination,
                  style: TextStyle(fontSize: 16, wordSpacing: 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
