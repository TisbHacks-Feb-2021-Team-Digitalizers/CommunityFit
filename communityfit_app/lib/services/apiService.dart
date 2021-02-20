import 'package:community_fit/environmentConfig.dart';
import 'package:community_fit/models/edamamApiResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final EnvironmentConfig config;
  const ApiService({this.config});

  Future<EdamamApiResponse> searchEdamam(String query) async {
    final edamamApiUrl =
        'https://api.edamam.com/search?q=$query&app_id=${config.edamamApplicationId}&app_key=${config.edamamApiKey}';

    http.Response response = await http.get(edamamApiUrl);
    return EdamamApiResponse.fromMap(
      json.decode(
        response.body,
      ),
    );
  }
}
