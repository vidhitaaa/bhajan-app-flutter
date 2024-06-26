import '../models/bhajan_details.dart';
import 'package:http/http.dart' as http;
import 'appConstants.dart';

class RemoteServicedetails {
  final http.Client _client;

  RemoteServicedetails(this._client);

  Future<Bhajandetails> getBhajansdetails(String slug) async {
    try {
      var uri = Uri.parse('$root/bhajans/$slug/');
      var response = await _client.get(uri);

      if (response.statusCode == 200) {
        var json = response.body;
        print(json);
        return bhajandetailsFromJson(json);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw e; // Rethrow the exception for handling in UI or wherever this function is called
    }
  }
}
