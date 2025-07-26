import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(UniversityApp());
}

class UniversityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universities by Country',
      home: UniversityScreen(),
    );
  }
}

class UniversityScreen extends StatefulWidget {
  @override
  _UniversityScreenState createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  List universities = [];
  TextEditingController controller = TextEditingController();
  bool isLoading = false;

  Future<void> fetchUniversities(String country) async {
    setState(() => isLoading = true);
    final url = Uri.parse('http://universities.hipolabs.com/search?country=$country');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        universities = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        universities = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Universities by Country')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Enter Country',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => fetchUniversities(controller.text),
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: universities.length,
                      itemBuilder: (context, index) {
                        final uni = universities[index];
                        return ListTile(
                          title: Text(uni['name']),
                          subtitle: Text(uni['country']),
                          onTap: () {
                            final url = uni['web_pages'][0];
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(uni['name']),
                                content: Text('Website:\n$url'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Close'),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
