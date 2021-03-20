import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:random_restaurant_picker/pages/restaurant_details.dart';
// import 'package:random_restaurant_picker/secrets/api_keys.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  // Load API keys from env file if available.
  await DotEnv.load(fileName: ".env");
  // We're using HiveStore for persistence,
  // so we need to initialize Hive.
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(
    'https://api.yelp.com/v3/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () async =>
        'Bearer ' +
        String.fromEnvironment('YELP_API_KEY',
            defaultValue: DotEnv.env['YELP_API_KEY']),
    // OR
    // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  );

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
        home: MyHomePage(title: 'Random Restaurant Picker'),
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
    Future<void> _handlePressButton() async {
      // show input autocomplete with selected mode
      // then get the Prediction selected
      // Prediction prediction = await PlacesAutocomplete.show(
      //     context: context,
      //     apiKey: String.fromEnvironment('GOOGLE_API_KEY', defaultValue: DotEnv.env['GOOGLE_API_KEY']),
      //     mode: Mode.fullscreen, // Mode.overlay
      //     language: "en",
      //     components: [Component(Component.country, "us")]);
      print('something');
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
            child: TextFormField(
              decoration: new InputDecoration(
                            labelText: "Enter Location",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                            //fillColor: Colors.green
                          ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
        ),
      );
  }
}
