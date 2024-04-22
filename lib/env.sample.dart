import '../models/bhajan.dart';
import 'package:http/http.dart' as http;
import 'appConstants.dart';

class RemoteService {
  final http.Client _client;

  RemoteService(this._client);

  Future<List<Bhajan>> getBhajans(int page) async {
    try {
      var uri = Uri.parse('$root/bhajans/?page=$page');
      var response = await _client.get(uri);

      if (response.statusCode == 200) {
        var json = response.body;
        print(json);
        return bhajanFromJson(json);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw e; // Rethrow the exception for handling in UI or wherever this function is called
    }
  }
}
