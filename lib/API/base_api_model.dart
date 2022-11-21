class BaseApiModel{
  late bool statusCode;
  late String message;
  late dynamic data;

  BaseApiModel();
  BaseApiModel.fromJson(Map<String,dynamic> json){
    statusCode = json["status"] as bool;
    message = json["message"] as String;
    data = json["data"];
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = statusCode;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}
