import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat2x",
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCountry = "+91";

  TextEditingController _numberController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Chat2x"),
      ),
      body: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 30,
                  child: CountryCodePicker(
                    initialSelection: "IN",
                    favorite: ["+91", "IN"],
                    onChanged: (item) {
                      print("country code : ${item.dialCode}");
                      setState(() {
                        selectedCountry = item.dialCode!;
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: TextField(
                    minLines: 1,
                    controller: _numberController,
                    maxLines: 15,
                    decoration: InputDecoration(
                        hintText: "Enter Mobile Number",
                        border: OutlineInputBorder(),
                        labelText: "Mobile Number"),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _messageController,
              minLines: 3,
              maxLines: 1000,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Message",
                  labelText: "Message"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                sendMessage();
              },
              child: Text("Send Box"),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    String number, message;

    if (_numberController.text.isEmpty || _numberController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enter valid Mobile Number"),
        ),
      );

      return; // Return early if validation fails.
    }

    number = selectedCountry + _numberController.text;
    message = _messageController.text;
    String url = "https://wa.me/$number?text=" + Uri.encodeComponent(message);

    // Call the launch URL function here
    _launchUrl(url);
  }

  Future<void> _launchUrl(String url) async {
    if (!await launch(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
