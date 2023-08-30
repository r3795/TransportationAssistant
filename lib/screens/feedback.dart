import 'package:flutter/material.dart';


class Slider_Feedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complaint Report',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ComplaintReportScreen(),
    );
  }
}

class ComplaintReportScreen extends StatefulWidget {
  @override
  _ComplaintReportScreenState createState() => _ComplaintReportScreenState();
}

class _ComplaintReportScreenState extends State<ComplaintReportScreen> {
  final TextEditingController _complaintController = TextEditingController();
  String _submittedText = '';

  void _submitComplaint() {
    setState(() {
      _submittedText = _complaintController.text;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('제출된 피드백'),
          content: Text(_submittedText),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 500, // Set the desired height of the TextField
                child: Center(
                  child: TextField(
                    controller: _complaintController,
                    decoration: InputDecoration(
                      labelText: '  Enter your feedback',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 100),
                    ),
                    maxLines: null, // Allow multiple lines of text
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('제출하기'),
                onPressed: _submitComplaint,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black26), // Set the background color
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.white)), // Set the text color
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16)), // Set the padding
                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), // Set the border shape
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}