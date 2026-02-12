import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_store/flutter_secure_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EncryptionErrorCode {
  authenticationFailed,
  keyNotFound,
  keyCorrupted,
  uninitializedEncryption,
  orphanedDatabase,
}

class EncryptionError implements Exception {
  final EncryptionErrorCode code;
  final String message;

  EncryptionError(this.code, this.message);

  @override
  String toString() => 'EncryptionError($code): $message';
}

class DatabaseEncryptionService {
  static const String _encryptionKey = 'encryption_key';
  static const String _keyRequiresAuth = 'key_requires_auth';

  final FlutterSecureStore _secureStore = const FlutterSecureStore();
  String? _keyCache;
  bool _wasKeyCreatedDuringInit = false;

  String _generateRandomKeyHex() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return values.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  Future<bool> _getKeyRequiresAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRequiresAuth) ?? false;
  }

  Future<void> _setKeyRequiresAuth(bool requiresAuth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRequiresAuth, requiresAuth);
  }

  Future<String> _loadExistingKey() async {
    final requiresAuth = await _getKeyRequiresAuth();
    String? keyHex;

    try {
      keyHex = await _secureStore.read(
        key: _encryptionKey,
        iOptions: requiresAuth ? const IOSOptions(accessibility: KeychainAccessibility.when_passcode_set_this_device_only) : null,
        // Authentication options depend on platform and might need more configuration
      );
    } catch (e) {
      if (!requiresAuth) {
        // Retry with auth if we suspect it might be required (similar to RN logic)
        keyHex = await _secureStore.read(key: _encryptionKey);
      } else {
        throw EncryptionError(
          EncryptionErrorCode.authenticationFailed,
          'Authentication failed.',
        );
      }
    }

    if (keyHex == null) {
      throw EncryptionError(
        EncryptionErrorCode.keyNotFound,
        'Encryption key is missing.',
      );
    }

    final hexPattern = RegExp(r'^[0-9a-f]{64}$', caseSensitive: false);
    if (!hexPattern.hasMatch(keyHex)) {
      throw EncryptionError(
        EncryptionErrorCode.keyCorrupted,
        'Stored encryption key is corrupted.',
      );
    }

    return keyHex;
  }

  Future<String> _createNewKey() async {
    final keyHex = _generateRandomKeyHex();
    await _secureStore.write(key: _encryptionKey, value: keyHex);
    await _setKeyRequiresAuth(false);
    return keyHex;
  }

  Future<Map<String, bool>> initializeEncryption() async {
    if (_keyCache != null) {
      return {'wasKeyJustCreated': false};
    }

    _wasKeyCreatedDuringInit = false;

    try {
      _keyCache = await _loadExistingKey();
    } catch (e) {
      if (e is EncryptionError && e.code == EncryptionErrorCode.keyNotFound) {
        _keyCache = await _createNewKey();
        _wasKeyCreatedDuringInit = true;
      } else {
        rethrow;
      }
    }

    return {'wasKeyJustCreated': _wasKeyCreatedDuringInit};
  }

  String getEncryptionKeyHex() {
    if (_keyCache == null) {
      throw EncryptionError(
        EncryptionErrorCode.uninitializedEncryption,
        'Encryption key not initialized.',
      );
    }
    return _keyCache!;
  }

  Future<void> deleteEncryptionKey() async {
    await _secureStore.delete(key: _encryptionKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRequiresAuth);
    _keyCache = null;
    _wasKeyCreatedDuringInit = false;
  }
}
