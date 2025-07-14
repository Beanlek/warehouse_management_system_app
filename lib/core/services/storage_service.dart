import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class StorageService {
  static const String keyToken = 'token';
  static const String keyTokenExpiryTime = 'token_expiry_time';
  static const String keyAllotmentDate = 'allotment_date';
  static const String keyEodFlag = 'eod_flag';
  static const String isOnline = 'is_online';
  static const String keyProfile = 'user_profile';
  static const String keyBaseUrl = 'base_url';
  static const String keyBaseCountry = 'base_country';
  static const String keyBaseEnvironment = 'base_environment';

  static final StorageService _instance = StorageService._internal();

  factory StorageService() => _instance;

  StorageService._internal();

  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> remove(String key) async {
    await secureStorage.delete(key: key);
  }

  Future<void> save(String key, String? value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String?> retrieve(String key) async {
    return await secureStorage.read(key: key);
  }
}
