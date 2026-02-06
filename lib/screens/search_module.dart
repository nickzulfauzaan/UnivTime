import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:univtime/widgets/header.dart';

class SearchModule extends StatefulWidget {
  const SearchModule({super.key});

  @override
  State<SearchModule> createState() => _SearchModuleState();
}

class _SearchModuleState extends State<SearchModule> {
  Map<String, dynamic> jsonData = {};
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      String jsonString =
          await DefaultAssetBundle.of(context).loadString('assets/data.json');
      Map<String, dynamic> data = jsonDecode(jsonString);
      Map<String, dynamic>? dataSet = data['data_set'];

      if (dataSet != null) {
        setState(() {
          jsonData = dataSet;
          selectedCategory = jsonData.keys.elementAt(0);
        });
      } else {
        developer.log('Error: "data_set" is null or missing in the JSON.',
            name: 'SearchModule');
      }
    } catch (e) {
      developer.log('Error loading data: $e', name: 'SearchModule');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF12171D),
      appBar: AppBar(
        backgroundColor: Color(0xFF12171D),
        title: Header(),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
              width: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedCategory,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: jsonData.keys.map<DropdownMenuItem<String>>(
                    (String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            category,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            jsonData.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: jsonData[selectedCategory].length,
                      itemBuilder: (context, index) {
                        String courseCode =
                            jsonData[selectedCategory].keys.elementAt(index);
                        Map<String, dynamic> courseDetails =
                            jsonData[selectedCategory][courseCode] ?? {};

                        return Card(
                          color: Colors.blueAccent,
                          child: ExpansionTile(
                            title: Text(
                              courseCode,
                              style: TextStyle(color: Colors.white),
                            ),
                            children: courseDetails.entries.map((section) {
                              String sectionName = section.key;
                              Map<String, dynamic> sectionDetails =
                                  section.value ?? {};

                              return ListTile(
                                title: Text(
                                  sectionName,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      sectionDetails.entries.map((detail) {
                                    return Text(
                                      '${detail.key}: ${detail.value}',
                                      style: TextStyle(color: Colors.white),
                                    );
                                  }).toList(),
                                ),
                              );
                            }).toList(),
                          ),
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
