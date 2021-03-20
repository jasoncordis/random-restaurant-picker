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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(yelpTest),
          variables: {
            'location': 'san francisco',
            'nRepositories': 50,
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
          print(result);
          Map searchResults = result.data['search'];

          return Text('got here');
        },
      ),
    );
  }
}
