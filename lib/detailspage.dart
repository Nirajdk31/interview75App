import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'detailsmodel.dart';

class DetailsPage extends StatefulWidget {
  final String imdbId;

   const DetailsPage({super.key,
     required this.imdbId,

  });

  factory DetailsPage.fromJson(Map<String, dynamic> jsonDet)=> DetailsPage(
    imdbId: jsonDet["imdbID"],

  );

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  //var details = "";
  //late Detail details;
  //Detail? details;
  Map<String, dynamic> details = {};

  @override
  void initState() {
    super.initState();
    fetchDetails(); // Fetch details when the page is initialized
  }

  // @override
  void fetchDetails() async {
    final response = await http.get(
      Uri.parse("https://www.omdbapi.com/?apikey=39a36280&i=${widget.imdbId}"),
    );

    if (response.statusCode == 200) {
      // The API call was successful, parse the response.
      final jsonData = json.decode(response.body);
      setState(() {
        details = jsonData;
      });
    } else {
      // The API call failed.
      showToast("Failed to load data");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: const Center(child: Text('Movies Details', style: TextStyle(fontSize: 30, color: Colors.black54),)),
      ),
      body: details.isEmpty
    ? Center(child: CircularProgressIndicator()) :
    // Padding(
    //   padding: const EdgeInsets.only(top: 20),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       Center(
    //           child: Container(
    //               decoration: BoxDecoration(
    //                 border: Border.all(color: Colors.black, width: 2),
    //                 borderRadius: BorderRadius.circular(20),
    //               ),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(18),
    //                 child: Image.network(
    //                   details["Poster"],
    //                   width: 250,
    //                   height: 350,
    //                   fit: BoxFit.fill,
    //                 ),
    //               )
    //           ),
    //       ),
    //       Text('Title: ${details["Title"]}'),
    //       Text('Year: ${details["Year"]}'),
    //
    //     ],
    //   ),
    // )
      Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FlipCard(
            direction: FlipDirection.HORIZONTAL,
            front: Material(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
              shadowColor: const Color(0x802196F3).withOpacity(0.2),
              child: _nameDetailContainer(details),
            ),
            back: Material(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
              shadowColor: const Color(0x802196F3).withOpacity(0.2),
              child: _overviewDetailContainer(details),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _nameDetailContainer(var details) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        height: 550,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.network(
          details["Poster"],
          fit: BoxFit.cover,
        ),
      ),
      Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black, Colors.black38],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                details["Title"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Release date: ${details["Released"]}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Rating: ${details["Rated"]}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 125),
                child: Text(
                  "[Please tap to flip]",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}

Widget _overviewDetailContainer(var details) {
  return Stack(
    children: [
      Container(
        height: 550,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.network(
          details['Poster'],
          fit: BoxFit.cover,
        ),
      ),
      Container(
        height: 550,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black54,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Plot",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23),
            ),
            Text(
              details['Plot'],
              style: const TextStyle(color: Colors.white, fontSize: 23),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "[Please tap to flip]",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
