import 'dart:convert';
import 'package:shagun_resort_review/API/resource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API Response Models/client_data_model.dart';
import 'base_api_model.dart';
import 'network_calls.dart';

class AppApi{
  final baseClientApi = BaseClient();

  Future<Resource> resource(String url,{body, bool isSendToken = false}) async {
    if(body!=null)
    {
      return commonPostMethod(url, body, isSendToken: isSendToken)
          .then((response) {
        BaseApiModel? baseApiModel = BaseApiModel.fromJson(jsonDecode(response));
        if (baseApiModel.statusCode) {
          return Resource.success(baseApiModel.data, baseApiModel.message,baseApiModel.statusCode);
        } else {
          return Resource.error({}, baseApiModel.message);
        }
      });
    }
    else
    {
      return commonGetMethod(url, isSendToken: isSendToken)
          .then((response) {
        BaseApiModel baseApiModel = BaseApiModel.fromJson(jsonDecode(response));
        if (baseApiModel.statusCode) {
          return Resource.success(baseApiModel.data, baseApiModel.message,baseApiModel.statusCode);
        } else {
          return Resource.error({}, baseApiModel.message);
        }
      });
    }
  }

  Future commonPostMethod(String url, Map params,
      {bool isSendToken = false}) async {
    var response = await baseClientApi.post(url, params);
    return response;
  }

  Future commonGetMethod(String url,
      {bool isSendToken = false}) async {
    Map<String, String> header = {};
    if (isSendToken) {
      // var user = HiveConfig.getUserHive();
      // header.putIfAbsent("api_token", () => "${user?.token}");
    }
    header.putIfAbsent("content-type", () => "application/json");
    var response = await baseClientApi.get(url, header);
    return response;
  }

  /// Login Api
  Future loginApi(Map body) async{
    return await resource(ApiUrl.login,body: body,isSendToken: true).then((response){
      return response;
    })
    .catchError((onError){
      print("error occur is $onError");
    });
  }

  /// Submit Review
  Future<Resource> submitReview(Map body) async{
    return await resource(ApiUrl.pendingReviewSubmit, body: body).then((response){
      return response;
    }).catchError((catchError){
      print("pending review submit api error $catchError");
    });
  }

  Future <ClientDetail> getClientData() async{
    try{
      final prefs = await SharedPreferences.getInstance();
     // await prefs.setBool('isLoggedIn', true);
      final userId = prefs.getString('userId');
      final userToken = prefs.getString('userToken');
      final queryParameters = {
        'token': userToken,
        'user_id': userId,
      };
      var res = await commonPostMethod(ApiUrl.pendingReviewList, queryParameters, isSendToken: true);
      var data = ClientDetail.fromJson(jsonDecode(res));
      return data;
    } catch(err){
        print("error data is $err");
        rethrow;
    }
  }
}

class ApiUrl {
  static const baseUrl = "https://crm.shagunresorts.com/review_tab_api/";
  static const login = "${baseUrl}login";
  static const pendingReviewList = "${baseUrl}pending_review_list";
  static const pendingReviewSubmit = "${baseUrl}pending_review_submit";
}