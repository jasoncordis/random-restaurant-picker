import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailsPage extends StatefulWidget {
  RestaurantDetailsPage({Key key, this.title, this.searchResults})
      : super(key: key);

  final String title;
  final Map searchResults;

  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  var rng = new Random();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map searchResults = widget.searchResults;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: NetworkImage(searchResults['photos'][0]),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Colors.blue.shade300,
                            height: 100,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.blue,
                            height: 100,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.blue.shade700,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () {
                            _launchURL(searchResults['url']);
                          },
                          child: Text(
                            searchResults['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: max(screenWidth * 0.05, 36),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(''),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          searchResults['location']['formatted_address'],
                          style: TextStyle(
                            fontSize: max(screenWidth * 0.02, 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            searchResults['is_closed']
                                ? "Not open at the moment :("
                                : "Open now!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: max(screenWidth * 0.02, 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(''),
                ),
              ],
            ),
            // Image.network(searchResults['photos'][0]),
            Container(
              padding: EdgeInsets.only(top: 40),
              width: max(screenWidth / 2, 320),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.rate_review_sharp),
                      title: Text(
                        searchResults['reviews'][0]['text'].substring(0, 79) +
                            '...',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              width: max(screenWidth / 2, 320),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.rate_review_sharp),
                      title: Text(
                        searchResults['reviews'][1]['text'].substring(0, 79) +
                            '...',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              width: max(screenWidth / 2, 320),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.rate_review_sharp),
                      title: Text(
                        searchResults['reviews'][2]['text'].substring(0, 79) +
                            '...',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
