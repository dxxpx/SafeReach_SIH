import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sr/views/Uicomponents.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';

class Insurancepage extends StatefulWidget {
  const Insurancepage({super.key});

  @override
  State<Insurancepage> createState() => _InsurancepageState();
}

class _InsurancepageState extends State<Insurancepage> {
  List<Map<String, String>> _insuranceData = [];

  @override
  void initState() {
    super.initState();
    fetchInsuranceData();
  }

  Future<void> fetchInsuranceData() async {
    final baseUrl = "https://www.sbilife.co.in/";
    final url = '$baseUrl/en/individual-life-insurance/protection-plans';
    try {
      // Fetch the HTML content
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parse(response.body);

        // Extract insurance information
        final insuranceElements = document.querySelectorAll(
            'body > div.container.content-wrapper.product-solutions-content-wrapper.sectionPH > div.tab-content > div.insurance-card-wrapper > div');
        final data = <Map<String, String>>[];

        for (var element in insuranceElements) {
          final title = element
              .querySelector(
                  'div > div.col-xs-offset-1.col-xs-11.col-md-offset-1.col-md-5 > a:nth-child(1) > h2')
              ?.text;
          final relativeUrl = element
              .querySelector(
                  'div > div.col-xs-offset-1.col-xs-11.col-md-offset-1.col-md-5 > a:nth-child(1)')
              ?.attributes['href'];
          final details = element
              .querySelector(
                  'div > div.col-xs-offset-1.col-xs-11.col-md-offset-1.col-md-5 > p')
              ?.text;
          final learnMoreButton = element
              .querySelector(
                  'div > div.col-xs-12.col-md-offset-1.col-md-11.box-space-plan > div.row > div.col-xs-10.col-md-3.col-lg-5.pull-right > a.btn.margin-0.btn-green.insurance-card-btn')
              ?.attributes['href'];
          final buyNowButton = element
              .querySelector(
                  'div > div.col-xs-12.col-md-offset-1.col-md-11.box-space-plan > div.row > div.col-xs-10.col-md-3.col-lg-5.pull-right > a.btn.margin-0.btn-orange.insurance-card-btn')
              ?.attributes['href'];

          final completeUrl = relativeUrl != null ? '$baseUrl$relativeUrl' : '';
          final completeLearnMoreButton =
              learnMoreButton != null ? '$baseUrl$learnMoreButton' : '';
          final completeBuyNowButton =
              buyNowButton != null ? '$baseUrl$buyNowButton' : '';

          if (title != null && relativeUrl != null && details != null) {
            data.add({
              'title': title,
              'url': relativeUrl,
              'details': details,
              'learnMoreButton': completeLearnMoreButton ?? '',
            });
          }
        }

        // Print the extracted insurance information
        print(jsonEncode(data));

        setState(() {
          _insuranceData = data;
          print("_insurance data Updated : $_insuranceData");
        });
      } else {
        print('Failed to load page');
      }
    } catch (e) {
      print('Error occurred during data extraction: $e');
    }
  }

  void _launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Insurance Page",
          style: appbar_Tstyle,
        ),
        backgroundColor: appblue,
      ),
      body: _insuranceData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _insuranceData.length,
              itemBuilder: (context, index) {
                final insurance = _insuranceData[index];
                return Card(
                  color: Colors.purple.shade50,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      insurance['title'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      children: [
                        Text(insurance['details'] ?? ''),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _launchURL(insurance['learnMoreButton'] ?? '');
                      },
                      icon: Icon(CupertinoIcons.shopping_cart),
                    ),
                    onTap: () {
                      _launchURL(insurance['url'] ?? '');
                    },
                  ),
                );
              },
            ),
    );
  }
}

//Container(
//         child: Card(
//           color: Colors.purple.shade50,
//           margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//           child: ListTile(
//             title: Text(
//               "title",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text("Details"),
//             trailing: Container(
//               width: 200,
//               child: Row(
//                 children: [
//                   IconButton(
//                       onPressed: () {},
//                       icon: Icon(CupertinoIcons.shopping_cart)),
//                   IconButton(
//                       onPressed: () {}, icon: Icon(CupertinoIcons.search))
//                 ],
//               ),
//             ),
//             onTap: () {
//               _launchURL("titleurl");
//             },
//           ),
//         ),
//       ),
