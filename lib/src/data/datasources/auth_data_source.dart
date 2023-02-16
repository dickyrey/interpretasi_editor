import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:interpretasi_editor/src/common/const.dart';
import 'package:interpretasi_editor/src/common/exception.dart';
import 'package:interpretasi_editor/src/data/models/token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthDataSource {
  Future<bool> checkAuth();
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  });
  Future<void> signOut();
}

class AuthDataSourceImpl extends AuthDataSource {
  AuthDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Const.token);
    
    if (token != null) {
      return true;
    } else {
      throw ServerException(ExceptionMessage.internetNotConnected);
    }
  }

  @override
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final headers = {
      'Accept': 'application/json',
    };
    final body = {
      'email': email,
      'password': password,
    };

    final url = Uri(
      scheme: Const.scheme,
      host: Const.host,
      path: '/v1/signin',
    );

    final response = await http.post(url, headers: headers, body: body);
    
    if (response.statusCode == 200) {
      final accessToken = TokenModel.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
      await prefs.setString(Const.token, accessToken.token);
      return true;
    } else if (response.statusCode == 403) {
      throw ServerException(ExceptionMessage.wrongPassword);
    } else if (response.statusCode == 404) {
      throw ServerException(ExceptionMessage.userNotFound);
    } else {
      throw ServerException(ExceptionMessage.internetNotConnected);
    }
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Const.token);
    final header = {
      'Authorization': 'Bearer $token',
    };

    final url = Uri(
      scheme: Const.scheme,
      host: Const.host,
      path: '/v1/signout',
    );

    final response = await http.post(url, headers: header);

    if (response.statusCode == 200) {
      await prefs.remove(Const.token);
      return;
    } else {
      await prefs.remove(Const.token);
      throw ServerException(ExceptionMessage.internetNotConnected);
    }
  }
}
