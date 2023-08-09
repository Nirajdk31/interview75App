import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detailspage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //List moviesList = [];

  // Future<Movies> fetchInfo() async{
  //   final response = await http.get(apiUrl as Uri);
  //   final jsonresponse = json.decode(response.body);
  //
  //   return Movies.fromJson(jsonresponse[0]);
  // }

  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    final response = await http.get(
      Uri.parse("https://www.omdbapi.com/?apikey=39a36280&s=iron%20man"),
    );

    if (response.statusCode == 200) {
      // The API call was successful, parse the response.
      final jsonData = json.decode(response.body);
      setState(() {
        movies = jsonData['Search'];
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
        title: const Center(child: Text('Movies', style: TextStyle(fontSize: 30, color: Colors.black54),)),
      ),
    body: movies.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: movies.length,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

      itemBuilder: (BuildContext ctx, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsPage(

                    imdbId: movies[index]["imdbID"],

                    // key: movies[index],
                  ),),);
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  tileColor: Colors.white24,
                  //leading:
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            movies[index]["Poster"],
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Text(movies[index]['Title'], style: const TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),

    );
  }
}
