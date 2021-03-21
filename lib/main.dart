import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:random_restaurant_picker/pages/restaurant_details.dart';
// import 'package:random_restaurant_picker/secrets/api_keys.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() async {
  // Load API keys from env file if available.
  // await DotEnv.load(fileName: "assets/apikey.env");
  // We're using HiveStore for persistence,
  // so we need to initialize Hive.
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(
    'https://api.yelp.com/v3/graphql',
  );

  final AuthLink authLink = AuthLink(
      getToken: () async =>
          'Bearer RU8br-ZfI6fTPcol68ahMsStdnsyl2CDcHneoscds5N9wS1bq0CVX0hff0IrgL9cZaIGpwjCK5wNSTqo5pLVj1DdUm5_jCkPx3NqXysqCQjEC2J6kvr8pjWOGfBUYHYx');

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  MyApp({this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Random Restaurant Picker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(
          title: 'Random Restaurant Picker',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Random Restaurant Picker',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              ElevatedButton(
                child: Text('Continue'),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SecondRoute()),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<Null> displayPrediction(Prediction p) async {
      if (p != null) {
        // get detail (lat/lng)
        GoogleMapsPlaces _places = GoogleMapsPlaces(
          apiKey: 'AIzaSyDaLoVRBiGxUUWg0uliTV_uELvFaDXVueQ',
        );
        PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(p.placeId);
        final address = detail.result.formattedAddress;
        print(address);
        var url = Uri.parse(
            'https://us-central1-packhacks-random-restaurant.cloudfunctions.net/get-yelp-random-business');
        http.Response response = await http.post(
          url,
          body: "{\n  \"location\": \"San Francisco, CA, USA\"\n}",
          headers: {'content-type': 'application/json'},
        );
        var searchResults =
            convert.jsonDecode(response.body)['data']['search']['business'][0];
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RestaurantDetailsPage(
                    title: 'Random Restaurant Picker',
                    searchResults: searchResults,
                  )),
        );
      }
    }

    Future<void> _handlePressButton() async {
      /*
      const api = String.fromEnvironment('GOOGLE_API_KEY');
      */
      Prediction prediction = await PlacesAutocomplete.show(
          context: context,
          apiKey: 'AIzaSyDaLoVRBiGxUUWg0uliTV_uELvFaDXVueQ',
          mode: Mode.fullscreen, // Mode.overlay
          language: "en",
          components: [Component(Component.country, "us")]);
      displayPrediction(prediction);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Your Location"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              _handlePressButton();
            },
            child: Text('Enter location'),
          ),
        ),
      ),
    );
  }
}
