import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() async {
  var address = "San Francisco, CA, USA";
  var url = Uri.parse(
      'https://us-central1-packhacks-random-restaurant.cloudfunctions.net/get-yelp-random-business');
  http.Response response = await http.post(
    url,
    body: "{\n  \"location\": \"San Francisco, CA, USA\"\n}",
    headers: {'content-type': 'application/json'},
  );
  print(response.statusCode);
  print(response.body);
  var searchResults =
      convert.jsonDecode(response.body)['data']['search']['business'][0];
  print(searchResults);
  // print('{\n  \"location\": \"' + address + '\"\n}');
}
