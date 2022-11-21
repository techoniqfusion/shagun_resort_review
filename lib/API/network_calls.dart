import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception_handlers.dart';
final client = http.Client();

class BaseClient{

  static const int timeOutDuration = 10;

  Future<dynamic> get(String url,Map<String, String>? header) async{
    var getApiUrl = Uri.parse(url);
    try{
      var response = await http.get(getApiUrl,headers: header).timeout(const Duration(seconds: timeOutDuration));
      return processResponse(response);
    } catch(exception){
      throw ExceptionHandlers().getException(exception);
    }
  }

  Future<dynamic> post(String url, dynamic body) async{
    var postApiUrl = Uri.parse(url);
    try{
      var response = await http.post(postApiUrl, body: body).timeout(const Duration(seconds: timeOutDuration));
      return processResponse(response);
    } catch(exception){
      throw ExceptionHandlers().getException(exception);
    }
  }

  Future<dynamic> put(String url, dynamic body, Map<String, String>? header) async{
    var putApiUrl = Uri.parse(url);
    try{
      var response = await http.put(putApiUrl, headers: header).timeout(const Duration(seconds: timeOutDuration));
      return processResponse(response);
    } catch(exception){
      throw ExceptionHandlers().getException(exception);
    }
  }

  Future<dynamic> delete(String url, dynamic body, Map<String, String>? header) async{
    var deleteApiUrl = Uri.parse(url);
    try{
      var response = await http.delete(deleteApiUrl, headers: header).timeout(const Duration(seconds: timeOutDuration));
      return processResponse(response);
    } catch(exception){
      throw ExceptionHandlers().getException(exception);
    }
  }


//----------------------ERROR STATUS CODES----------------------

  processResponse(http.Response response){
    switch (response.statusCode){
      case 200:
        var responseJson = response.body;
        return responseJson;

      case 400: //Bad request
        throw BadRequestException(jsonDecode(response.body)['message']);

      case 401: //Unauthorized
        throw UnAuthorizedException(jsonDecode(response.body)['message']);

      case 403: //Forbidden
        throw UnAuthorizedException(jsonDecode(response.body)['message']);

      case 404: //Resource Not Found
        throw NotFoundException(jsonDecode(response.body)['message']);

      case 500: //Internal Server Error
      default:
        throw FetchDataException(
            'Something went wrong! ${response.statusCode}');
    }
  }
}