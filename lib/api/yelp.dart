import 'package:graphql/client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:math';

String searchRestaurants = """
  query SearchRestaurants(\$location: String!, \$offset: Int!) {
    search(
      term: "restaurants",
      location: \$location,
      limit: 1,
      offset: \$offset
    ) {
      total
      business {
        name
        url
        photos
        is_closed
        location {
          formatted_address
        }
        reviews {
          text
        }
      }
    }
  }
""";

String getTotalRestaurants = """
  query GetTotalRestaurants() {
    search(term: "restaurants",
            location: "san francisco",
            limit: 1) {
      total
    }
  }
""";

/// Not working :(
Future<int> getRandomRestaurantOffset(String _location) async {
  // Load API keys from env file if available.
  DotEnv.load(fileName: ".env");

  final _httpLink = HttpLink(
    'https://api.yelp.com/v3/graphql',
  );
  print(_httpLink);

  final _authLink = AuthLink(
    getToken: () async =>
        'Bearer ' +
        String.fromEnvironment('YELP_API_KEY',
            defaultValue: DotEnv.env['YELP_API_KEY']),
  );
  print(_authLink);

  Link _link = _authLink.concat(_httpLink);
  print(_link);

  final GraphQLClient client = GraphQLClient(
    /// **NOTE** The default store is the InMemoryStore, which does NOT persist to disk
    cache: GraphQLCache(),
    link: _link,
  );

  final QueryResult result = await client.query(QueryOptions(
    document: gql(getTotalRestaurants),
    variables: <String, dynamic>{
      'location': _location,
    },
  ));

  var rng = new Random();

  print(rng.nextInt(result.data['search']['total']));
  return rng.nextInt(result.data['search']['total']);
}
