import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{

  final storage = FlutterSecureStorage();

  Future writeSecureData(String key, String value) async{
    var writeData = await storage.write(key: key, value: value);
    return writeData;
  }

  Future readSecureData(String key) {
    var readData =  storage.read(key: key);
    return readData;
  }

  Future deleteSecureData(String key) async{
    var deleteData = await storage.delete(key: key);
    return deleteData;
  }
}