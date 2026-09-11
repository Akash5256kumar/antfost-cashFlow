import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl() : _connectivity = Connectivity();
  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.any((type) => type != ConnectivityResult.none);
    } on MissingPluginException {
      return false;
    }
  }
}
