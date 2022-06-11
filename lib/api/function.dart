import 'dart:convert';

import 'package:http/http.dart' as http;

class Createddata {

  Future datacreate(fullNametext,  typetext, arrivalDatetext, departureDatetext ) async {
    final response =
    await http.post(Uri.parse('http://127.0.0.1:8000/api/reservations'),
        body: jsonEncode({
          "fullName":fullNametext,
          "type":typetext,
          "arrivalDate":arrivalDatetext,
          "departureDate":departureDatetext,
        }),
        headers: {
          'Content-type': 'application/json',
        });
    print(response.statusCode);
    if (response.statusCode == 201) {
      print('Data Created Successfully');
    } else {
      print('err');
    }
  }

}

