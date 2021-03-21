import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:random_restaurant_picker/api/yelp.dart';
import 'dart:math';

class RestaurantDetailsPage extends StatefulWidget {
  RestaurantDetailsPage({Key key, this.title, this.location}) : super(key: key);

  final String title;
  final String location;

  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  var rng = new Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(searchRestaurants),
          variables: {
            'location': widget.location,
            'offset': rng.nextInt(500),
          },
        ),
        // Just like in apollo refetch() could be used to manually trigger a refetch
        // while fetchMore() can be used for pagination purpose
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Text('Loading');
          }

          // it can be either Map or List
          Map searchResults = result.data['search']['business'][0];
          // print(searchResults);

          double screenWidth = MediaQuery.of(context).size.width;

          return Container(
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
                            child: Text(
                              searchResults['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: max(screenWidth * 0.05, 36),
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
                            searchResults['reviews'][0]['text']
                                    .substring(0, 79) +
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
                            searchResults['reviews'][1]['text']
                                    .substring(0, 79) +
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
                            searchResults['reviews'][2]['text']
                                    .substring(0, 79) +
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
          );
        },
      ),
    );
  }
}
