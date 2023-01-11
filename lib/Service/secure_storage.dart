import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{

  final storage = FlutterSecureStorage();

  // final androidOptions = const AndroidOptions(encryptedSharedPreferences: true);

  // final iphoneOptions = IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  /// used to insert data in an encrypted format in local storage
  Future writeSecureData(String key, String value) async{
    try{
      var writeData = await storage.write(key: key, value: value,
        //  iOptions: iphoneOptions, aOptions: androidOptions
      );
      return writeData;
    }
    catch(exception){
      print("write data exception");
      print(exception);
      rethrow;
    }
  }

  /// used to read data in an encrypted format in local storage
  Future readSecureData(String key) async{
    try{
      var readData = await storage.read(key: key,
        //  aOptions: androidOptions, iOptions: iphoneOptions
      );
      return readData;
    }
    catch(exception){
      print("read data exception");
      print(exception);
      rethrow;
    }
  }

  /// used to delete encrypted data from local storage
  Future deleteSecureData(String key) async{
    try{
      var deleteData =  await storage.delete(key: key,
         // aOptions: androidOptions, iOptions: iphoneOptions
      );
      return deleteData;
    }
    catch(exception){
      print("delete data exception");
      print(exception);
      rethrow;
    }
  }
}