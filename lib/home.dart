import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:finalcrud/api/function.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Createddata obj = Createddata();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController arrivalDateController = TextEditingController();
  TextEditingController departureDateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getdata();
    datadelete(id);
    obj.datacreate(fullNameController.text, typeController.text,
        arrivalDateController.text, departureDateController.text);
  }

  List data = [];
  String? id;
  Future getdata() async {
    final response =
    await http.get(Uri.parse('http://127.0.0.1:8000/api/reservations'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      print('Add data$data');
    } else {
      print('err');
    }
  }

  Future datadelete(id) async {
    final response = await http
        .delete(Uri.parse('http://127.0.0.1:8000/api/reservations/$id'));
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('DELETE COMPLETE');
    } else {
      print('nOT dELET');
    }
  }

  Future update() async {
    final response = await http
        .put(Uri.parse('http://127.0.0.1:8000/api/reservations/1'),
        body: jsonEncode({
          "customerName":fullNameController.text,
          "order":typeController.text,
          "price":arrivalDateController.text,
          "quantity":departureDateController.text,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Data Update Successfully');
      fullNameController.clear();
      typeController.clear();
      arrivalDateController.clear();
      departureDateController.clear();

    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                  ),
                ),

                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    hintText: 'Room Type',
                  ),
                ),
                TextField(
                  controller: arrivalDateController,
                  decoration: InputDecoration(
                    hintText: 'Arrival Date',
                  ),
                ),
                TextField(
                  controller: departureDateController,
                  decoration: InputDecoration(
                    hintText: 'Departure Date',
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            obj.datacreate(
                              fullNameController.text,
                              typeController.text,
                              arrivalDateController.text,
                              departureDateController.text,
                            );
                          });
                        },
                        child: Text('Submit')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            update();
                          });
                        },
                        child: Text('Update')),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                    children: [
                                      Text(data[index]['fullName']),
                                    ]),
                                Row(
                                    children: [
                                      Text(data[index]['type']),
                                    ]),
                                Row(
                                    children: [
                                      Text(data[index]['arrivalDate']),
                                    ]),
                                Row(
                                    children: [
                                      Text(data[index]['departureDate']),
                                    ]),

                                Container(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            fullNameController.text =
                                            data[index]['fullName'];
                                            typeController.text =
                                            data[index]['type'];
                                            arrivalDateController.text =
                                            data[index]['arrivalDate'];
                                            departureDateController.text =
                                            data[index]['departureDate'];
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              datadelete(data[index]['id']);
                                            });
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

