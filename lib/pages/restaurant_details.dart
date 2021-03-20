import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:random_restaurant_picker/api/yelp.dart';

class RestaurantDetailsPage extends StatefulWidget {
  RestaurantDetailsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the RestaurantDetailsPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
          child: Query(
        options: QueryOptions(
          document: gql(yelpTest), // this is the query string you just created
          variables: {
            'location': 'san francisco',
          },
          pollInterval: Duration(seconds: 10),
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
          List repositories = result.data['viewer']['repositories']['nodes'];

          return ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repository = repositories[index];

                return Text(repository['name']);
              });
        },
      )),
    );
  }
}
