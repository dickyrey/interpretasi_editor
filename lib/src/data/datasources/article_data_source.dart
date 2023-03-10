import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:interpretasi_editor/src/common/const.dart';
import 'package:interpretasi_editor/src/common/exception.dart';
import 'package:interpretasi_editor/src/data/models/article_detail_model.dart';
import 'package:interpretasi_editor/src/data/models/article_detail_response.dart';
import 'package:interpretasi_editor/src/data/models/article_model.dart';
import 'package:interpretasi_editor/src/data/models/article_response.dart';
import 'package:interpretasi_editor/src/data/models/url_image_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticleDataSource {
  Future<List<ArticleModel>> getArticle({
    required String page,
    required String query,
    required String category,
    required bool isTrending,
  });
  Future<ArticleDetailModel> getArticleDetail(String id);
  Future<bool> deleteArticle(String id);
  Future<bool> createArticle({
    required int categoryId,
    required XFile image,
    required String title,
    required String content,
    required String deltaJson,
    required List<String> tags,
  });
  Future<bool> updateArticle({
    required int categoryId,
    required XFile? image,
    required String id,
    required String title,
    required String content,
    required String deltaJson,
    required List<String> tags,
  });
  Future<String> uploadImage(XFile image);
}

class ArticleDataSourceImpl extends ArticleDataSource {
  ArticleDataSourceImpl(this.client);
  final http.Client client;

  @override
  Future<List<ArticleModel>> getArticle({
    required String page,
    required String query,
    required String category,
    required bool isTrending,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Const.token);
    final header = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final url = Uri(
      scheme: Const.scheme,
      host: Const.host,
      path: '/api/v1/article/',
      queryParameters: {
        'page': page,
        'find': query,
        'category': (category == '0') ? '' : category,
        'trending': (isTrending == true) ? '1' : '0',
      },
    );

    final response = await client.get(url, headers: header);
    if (response.statusCode == 200) {
      return ArticleResponse.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      ).articleList;
    } else {
      throw ServerException(ExceptionMessage.internetNotConnected);
    }
  }

  @override
  Future<ArticleDetailModel> getArticleDetail(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Const.token);
    final header = {
      'Authorization': 'Bearer $token',
    };
    final url = Uri(
      scheme: Const.scheme,
      host: Const.host,
      path: '/api/v1/article/$id',
    );
    final response = await client.get(url, headers: header);
    if (response.statusCode == 200) {
      return ArticleDetailResponse.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      ).article;
    } else {
      throw ServerException(ExceptionMessage.internetNotConnected);
    }
  }

  @override
  Future<bool> createArticle({
    required int categoryId,
    required XFile image,
    required String title,
    required String content,
    required String deltaJson,
    required List<String> tags,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Const.token);
    final header = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final url = Uri(
      scheme: Const.scheme,
      host: Const.host,
      path: '/api/v1/article',
    );

    final request = http.MultipartRequest(
      'POST',
      url,
    );
    request.fields['category_id'] = categoryId.toString();
    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['original_content'] = deltaJson;
    request.fields['tags'] = tags.map((e) => '"$e"').toList().toString();
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        await image.readAsBytes().then((value) {
          return value.cast();
        }),
        filename: image.path + image.name,
      ),
    );
    request.headers.addAll(header);
    final response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException(ExceptionMessage.internetNotConnected);
    }
  }

  @override
  Future<bool> updateArticle({
    required int categoryId,
    required XFile? image,
    required String id,
    required String title,
    required String content,
    required String deltaJson,
    required List<String> tags,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Const.token);
    final header = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final url = Uri(
      scheme: Const.scheme,
      host: Const.host,
      path: '/api/v1/article/$id',
    );

    final request = http.MultipartRequest(
      'POST',
      url,
    );

    request.fields['_method'] = 'PUT';
    request.fields['category_id'] = categoryId.toString();
    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['original_content'] = deltaJson;
    request.fields['tags'] = tags.map((e) => '"$e"').toList().toString();

    if (image != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          await image.readAsBytes().then((value) {
            return value.cast();
          }),
          filename: image.path + image.name,
        ),
      );
    }

    request.headers.addAll(header);
    final response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException(ExceptionMessage.internetNotConnected);
    }
  }

  @override
  Future<bool> deleteArticle(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Const.token);
    final header = {
      'Authorization': 'Bearer $token',
    };

    final url = Uri(
      scheme: Const.scheme,
      host: Const.host,
      path: '/api/v1/article/$id',
    );

    final response = await client.delete(url, headers: header);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException(ExceptionMessage.internetNotConnected);
    }
  }

  @override
  Future<String> uploadImage(XFile image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Const.token);
    final header = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final url = Uri(
      scheme: Const.scheme,
      host: Const.host,
      path: '/v1/article/upload-image',
    );

    final request = http.MultipartRequest(
      'POST',
      url,
    );
    
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        await image.readAsBytes().then((value) {
          return value.cast();
        }),
        filename: image.path + image.name,
      ),
    );

    request.headers.addAll(header);
    final response = await request.send();
    if (response.statusCode == 200) {
      final jsonResult = await response.stream.bytesToString();
      final imageUrl = UrlImageModel.fromJson(
        json.decode(jsonResult) as Map<String, dynamic>,
      );
      return imageUrl.url;
    } else {
      throw ServerException(ExceptionMessage.internetNotConnected);
    }
  }
}
