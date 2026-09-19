import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';

/// Registry holding the mapped remote assets JSON configuration.
class AppAssetsRegistry {
  Map<String, dynamic> _config = {};

  void setConfig(Map<String, dynamic> config) {
    _config = config;
  }

  /// Looks up a screen image URL by its key (e.g. 'homeHeader')
  String? getScreenImageUrl(String key) {
    final screens = _config['screens'] as Map<String, dynamic>?;
    final item = screens?[key] as Map<String, dynamic>?;
    return item?['url'] as String?;
  }

  /// Looks up an image URL within a set (e.g. 'mixThumbnails', index 0)
  String? getSetImageUrl(String setName, int index) {
    final sets = _config['sets'] as Map<String, dynamic>?;
    final items = sets?[setName] as List<dynamic>?;
    if (items != null && index >= 0 && index < items.length) {
      final item = items[index] as Map<String, dynamic>;
      return item['url'] as String?;
    }
    return null;
  }

  /// Looks up a payment method image URL by its key (e.g. 'card')
  String? getPaymentMethodImageUrl(String key) {
    final paymentMethods = _config['paymentMethods'] as Map<String, dynamic>?;
    final item = paymentMethods?[key] as Map<String, dynamic>?;
    return item?['url'] as String?;
  }
}

/// Service to fetch remote assets configuration with ETag caching.
class AppAssetsApiService {
  final ApiClient _client;
  final AppAssetsRegistry _registry;
  final SharedPreferences _prefs;

  static const _cacheKey = 'app_assets_config_json';
  static const _versionKey = 'app_assets_version';

  AppAssetsApiService(this._client, this._registry, this._prefs) {
    _loadFromCache();
  }

  /// Load cached JSON on initialization
  void _loadFromCache() {
    final cachedJson = _prefs.getString(_cacheKey);
    if (cachedJson != null) {
      try {
        final Map<String, dynamic> config = jsonDecode(cachedJson);
        _registry.setConfig(config);
      } catch (e) {
        // Cache invalid, ignore
      }
    }
  }

  /// Fetches the assets configuration from the backend, passing the ETag
  /// to check for 304 Not Modified.
  Future<void> fetchAssets() async {
    final cachedVersion = _prefs.getString(_versionKey);
    
    try {
      final response = await _client.get(
        '/app/assets',
        options: cachedVersion != null
            ? Options(headers: {'If-None-Match': '"$cachedVersion"'})
            : null,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        // Check if there's a new version in the response
        final newVersion = data['version'] as String?;
        if (newVersion != null && newVersion != cachedVersion) {
          _registry.setConfig(data);
          await _prefs.setString(_versionKey, newVersion);
          await _prefs.setString(_cacheKey, jsonEncode(data));
        }
      }
    } catch (e) {
      // If error (including 304 which Dio might throw if validateStatus fails, 
      // though typically ApiClient handles it), we just rely on cache.
      // ETag 304 means not modified, so our cache is still good.
    }
  }
}
