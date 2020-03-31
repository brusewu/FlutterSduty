
import 'dart:convert';
import 'dart:io';
import 'dart:convert' show json, utf8;


const apiCategory = {
  'name':'Currency',
  'route':'Currency',
};

class Api{
  final HttpClient httpClient = HttpClient();

  final String url  = 'flutter.udacity.com';

  Future<List> getUnits(String category) async{
    final uri = Uri.https(url, '/$category');
    final jsonResponse = await getJson(uri);
    if(jsonResponse == null || jsonResponse['units'] == null){
      print('Error retrieving units.');
      return null;
    }
    return jsonResponse['units'];
  }

  Future<double> convert(
      String category, String amount, String fromUnit,String toUnit
      ) async {
    final uri = Uri.https(url, '/$category/convert',
    {'amount':amount,'from':fromUnit,'to':toUnit});
    final jsonResponse = await getJson(uri);
    if(jsonResponse == null || jsonResponse['status'] == null){
      print('Error retrieving conversion.');
      return null;
    }else if(jsonResponse['status'] == 'error'){
      print(jsonResponse['message']);
      return null;
    }
    return jsonResponse['conversion'].toDouble();
  }

  Future<Map<String,dynamic>> getJson(Uri uri) async{
    try{
      final httpRequest = await httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if(httpResponse.statusCode != HttpStatus.OK){
        return null;
      }
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch (e){
      print('$e');
      return null;
    }
  }
}