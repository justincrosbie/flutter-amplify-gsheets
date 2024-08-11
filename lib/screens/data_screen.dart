import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:my_amplify_app/models/google_data.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<GoogleData> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final sheetId = dotenv.env['SHEET_ID']!;
    final url =
        'https://x2qav31zh9.execute-api.us-east-1.amazonaws.com/hudomGSheets?sheetId=$sheetId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decode the response body into a list of lists
      List<dynamic> jsonData = json.decode(response.body);

      // Skip the first row (header) and convert the rest into GoogleData objects
      List<GoogleData> googleDataList = jsonData.skip(1).map((row) {
        return GoogleData.fromJSON(List<String>.from(row));
      }).toList();

      setState(() {
        data = googleDataList;
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sheets Data')),
      body: data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task: ${data[index].task}',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Detail: ${data[index].detail}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Date Complete: ${data[index].dateComplete}',
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
