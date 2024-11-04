import 'dart:convert';

import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/apirest/api_models/article_plain_api_model.dart';
import 'package:asocapp/app/apirest/api_models/basic_response_model.dart';
import 'package:asocapp/app/apirest/network/network.dart';
import 'package:asocapp/app/apirest/response/api_response.dart';
import 'package:asocapp/app/apirest/utils/utils.dart';
import 'package:asocapp/app/config/config.dart';
import 'package:asocapp/app/models/models.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ArticlesApiRest {
  final ApiClient apiClient = ApiClient();

  static String apiArticles = 'articles';
  static String apiNotifications = 'notifications';

  Future<ArticleResponse> getSingleArticle(int idarticle, String token) async {
    // String authToken = token();

    // Map<String, String> requestHeaders = {
    //   'Content-type': 'application/json',
    //   'Authorization': 'Bearer $authToken',
    // };

    final url = await EglConfig.uri(apiArticles, '${EglConfig.apiSingleArticle}?id_article=$idarticle');
    // Helper.eglLogger('i', 'Response body: ${url.toString()}');

    // final response = await http.get(url, headers: requestHeaders);
    final response = await apiClient.get(url, token: token);

    // print('Response status: ${response.statusCode}');
    // Helper.eglLogger('i','Response body: ${await Helper.parseApiUrlBody(response.body)}');

    final ArticleResponse articleResponse = articleResponseFromJson(await ApiResponse.returnResponse(response));

    // print('Articlciations Response body: ${articlesList.result.records}');

    return articleResponse;
  }

  Future<ArticleListResponse> getArticles(String token) async {
    // Map<String, String> requestHeaders = {
    //   'Content-type': 'application/json',
    //   'Authorization': 'Bearer ${token}',
    // };

    final url = await EglConfig.uri(apiArticles, EglConfig.apiListAll);
    // Helper.eglLogger('i', 'Response body: ${url.toString()}');

    // final response = await http.get(url, headers: requestHeaders);
    final response = await apiClient.get(url, token: token);

    // print('Response status: ${response.statusCode}');
    // Helper.eglLogger('i', 'Response body: ${await Helper.parseApiUrlBody(response.body)}');

    final ArticleListResponse articlesListResponse = articleListResponseFromJson(await ApiResponse.returnResponse(response));

    // print('Articlciations Response body: ${articlesList.result.records}');

    return articlesListResponse;
  }

  Future<NotificationArticleListResponse> getPendingNotifyArticlesList({required String token}) async {
    try {
      // String authToken = token();

      // Map<String, String> requestHeaders = {
      //   'Content-type': 'application/json',
      //   'Authorization': 'Bearer ${token}',
      // };

      final Uri url = await EglConfig.uri(apiNotifications, EglConfig.apiListPending);
      // Helper.eglLogger('i', 'requestHeaders: ${requestHeaders.toString()}');
      // Helper.eglLogger('i', 'url: ${url.toString()}');
      // Helper.eglLogger('i', 'ArticlesApiRest: getPendingNotifyArticlesList -> getAuthToken -> tokenUser: $authToken');

      final http.Response response = await apiClient.get(url, token: (token != '') ? token : token);

      // print('Response status: ${response.statusCode}');
      // Helper.eglLogger('i', 'Response body: ${Helper.parseApiUrlBody(response.body)}');

      final decodeResponse = await ApiResponse.returnResponse(response);
      //   Helper.eglLogger('i', 'ArticlesApiRest: getPendingNotifyArticlesList -> decodeResponse: $decodeResponse');
      final NotificationArticleListResponse notificationArticleListResponse = notificationArticleListResponseFromJson(decodeResponse);

      return Future.value(notificationArticleListResponse);
    } on FormatException catch (error) {
      // print('Response status: ${response.statusCode}');
      EglHelper.eglLogger('e', 'ArticlesApiRest - NotificationArticleListResponse: Response try error: ${error.message}', object: error);
      return Future.value(NotificationArticleListResponse.clear());
    } catch (error) {
      // print('Response status: ${response.statusCode}');
      EglHelper.eglLogger('e', 'ArticlesApiRest - NotificationArticleListResponse: Response try error: ', object: error);
      return Future.value(NotificationArticleListResponse.clear());
    }
  }

  Future<HttpResult<ArticleUserResponse>?> createArticle(
    ArticlePlain articlePlain,
    ImageArticle imageCoverArticle,
    List<ItemArticle> articleItems,
    UserConnected userConnected
  ) async {
    Map<String, String> requestHeaders;
    Map<String, dynamic> fields;
    List<http.MultipartFile> files = [];

    int? statusCode;
    dynamic data;

    // string to uri
    final url = await EglConfig.uri(apiArticles, EglConfig.apiCreateArticle);

    // create multipart request
    // http.MultipartRequest request = http.MultipartRequest('POST', url);

    //add headers
    requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer ${userConnected.tokenUser}',
    };

    //adding params
    fields = {
      'article': jsonEncode(articlePlain.toJson()),
      'action': 'create',
      'module': 'articles',
      'prefix': 'images/asociation-${articlePlain.idAsociationArticle.toString()}',
      'user_name': userConnected.nameUser,
    };

    if (imageCoverArticle.isSelectedFile) {
      XFile image = imageCoverArticle.fileImage;
      String name = imageCoverArticle.nameFile;

      final http.ByteStream stream = http.ByteStream(image.openRead());
      stream.cast();
      // get file length
      var len = await image.length();

      // multipart that takes file
      http.MultipartFile multiport = http.MultipartFile(
        'file_cover',
        stream,
        len,
        filename: name,
      );

      files.add(multiport);
    }

    for (var i = 0; i < articleItems.length; i++) {
      if (articleItems[i].imageItemArticle.fileImage != null) {
        XFile image = articleItems[i].imageItemArticle.fileImage;
        int id = articleItems[i].idItemArticle;
        String name = articleItems[i].imageItemArticle.nameFile;

        final http.ByteStream stream = http.ByteStream(image.openRead());
        stream.cast();
        var len = await image.length();
        http.MultipartFile multiport = http.MultipartFile(
          'file_$id',
          stream,
          len,
          filename: name,
        );

        files.add(multiport);
      }
    }

    try {
      // final response = await request.send();
      final response = await apiClient.sendMultipartRequest(
        url: url,
        endpoint: 'upload',
        headers: requestHeaders,
        fields: fields,
        files: files,
      );

      // var res = await http.Response.fromStream(response);
      EglHelper.eglLogger('i', 'ArticlesApiRest - createArticle - response.body: ${response.body}');
      // statusCode = response.statusCode;
      // response.stream.transform(utf8.decoder).listen((value) {
      //   var body1 = value;
      //   EglHelper.eglLogger('i', 'body1: $body1');
      // });

      if (response.statusCode == 200) {
        final ArticleUserResponse articleUserResponse = articleUserResponseFromJson(
          await EglHelper.parseApiUrlBody(response.body),
        );

        return HttpResult<ArticleUserResponse>(
          data: articleUserResponse,
          statusCode: response.statusCode,
          error: null,
        );
      } else if (response.statusCode > 400) {
        data = parseResponseBody(await EglHelper.parseApiUrlBody(response.body));
        return HttpResult<ArticleUserResponse>(
          data: null,
          error: HttpError(
            data: data,
            exception: null,
            stackTrace: StackTrace.current,
          ),
          statusCode: response.statusCode,
        );
      } else {
        data = parseResponseBody(await EglHelper.parseApiUrlBody(response.body));
        String message = data['message'];
        return HttpResult<ArticleUserResponse>(
          data: null,
          error: HttpError(
            data: message,
            exception: null,
            stackTrace: StackTrace.current,
          ),
          statusCode: response.statusCode,
        );
      }
    } catch (e, s) {
      if (e is HttpError) {
        return HttpResult<ArticleUserResponse>(
          data: null,
          error: e,
          statusCode: statusCode!,
        );
      }

      return HttpResult<ArticleUserResponse>(
        data: null,
        error: HttpError(
          exception: e,
          stackTrace: s,
          data: 'Error inesperado.',
        ),
        statusCode: statusCode ?? -1,
      );
    }
  }

  Future<HttpResult<ArticleUserResponse>?> modifyArticle(
    ArticlePlain articlePlain,
    ImageArticle imageCoverArticle,
    List<ItemArticle> articleItems,
    UserConnected userConnected
  ) async {
    Map<String, String> requestHeaders;
    Map<String, dynamic> fields;
    List<http.MultipartFile> files = [];

    int? statusCode;
    dynamic data;

    // string to uri
    final url = await EglConfig.uri(apiArticles, EglConfig.apiModifyArticle);

    // create multipart request
    // http.MultipartRequest request = http.MultipartRequest('POST', url);

    //add headers
    requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer ${userConnected.tokenUser}',
    };

    if (imageCoverArticle.isSelectedFile) {
      XFile image = imageCoverArticle.fileImage;
      String name = imageCoverArticle.nameFile;

      final http.ByteStream stream = http.ByteStream(image.openRead());
      stream.cast();
      // get file length
      var len = await image.length();

      // multipart that takes file
      http.MultipartFile multiport = http.MultipartFile(
        'file_cover',
        stream,
        len,
        filename: name,
      );

      files.add(multiport);
    }

    for (var i = 0; i < articleItems.length; i++) {
      ItemArticle itemImageArticle = articleItems[i];
      ImageArticle imageItem = itemImageArticle.imageItemArticle;
      if (imageItem.fileImage != null) {
        XFile image = imageItem.fileImage;
        int id = articleItems[i].idItemArticle;
        String name = imageItem.nameFile;

        final http.ByteStream stream = http.ByteStream(image.openRead());
        stream.cast();
        var len = await image.length();
        http.MultipartFile multiport = http.MultipartFile(
          'file_$id',
          stream,
          len,
          filename: name,
        );

        files.add(multiport);
      } else if (imageItem.idImage != 0 && imageItem.isDefault) {
        articlePlain.itemsArticlePlain[i].deleteImage = true;
        articlePlain.itemsArticlePlain[i].idDeleteImage = itemImageArticle.imagesIdItemArticle;
      } else if (imageItem.idImage != 0 && imageItem.isChange) {
        articlePlain.itemsArticlePlain[i].deleteImage = true;
        articlePlain.itemsArticlePlain[i].idDeleteImage = itemImageArticle.imagesIdItemArticle;
      }
    }

    //adding params
    fields = {
      'article': jsonEncode(articlePlain.toJson()),
      'action': 'modify',
      'module': 'articles',
      'prefix': 'images/asociation-${articlePlain.idAsociationArticle.toString()}',
      'user_name': userConnected.nameUser,
    };

    try {
      final response = await apiClient.sendMultipartRequest(
        url: url,
        endpoint: 'upload',
        headers: requestHeaders,
        fields: fields,
        files: files,
      );

      EglHelper.eglLogger('i', 'ArticlesApiRest - modifyArticle - response.body: ${response.body}');
      // statusCode = response.statusCode;
      // response.stream.transform(utf8.decoder).listen((value) {
      //   var body1 = value;
      //   EglHelper.eglLogger('i', 'body1: $body1');
      // });

      if (response.statusCode == 200) {
        final ArticleUserResponse articleUserResponse = articleUserResponseFromJson(
          await EglHelper.parseApiUrlBody(response.body),
        );

        return HttpResult<ArticleUserResponse>(
          data: articleUserResponse,
          statusCode: response.statusCode,
          error: null,
        );
      } else if (response.statusCode > 400) {
        data = parseResponseBody(await EglHelper.parseApiUrlBody(response.body));
        return HttpResult<ArticleUserResponse>(
          data: null,
          error: HttpError(
            data: data,
            exception: null,
            stackTrace: StackTrace.current,
          ),
          statusCode: response.statusCode,
        );
      } else {
        data = parseResponseBody(await EglHelper.parseApiUrlBody(response.body));
        String message = data['message'];
        return HttpResult<ArticleUserResponse>(
          data: null,
          error: HttpError(
            data: message,
            exception: null,
            stackTrace: StackTrace.current,
          ),
          statusCode: response.statusCode,
        );
      }
    } catch (e, s) {
      if (e is HttpError) {
        return HttpResult<ArticleUserResponse>(
          data: null,
          error: e,
          statusCode: statusCode!,
        );
      }

      return HttpResult<ArticleUserResponse>(
        data: null,
        error: HttpError(
          exception: e,
          stackTrace: s,
          data: 'Error inesperado.',
        ),
        statusCode: statusCode ?? -1,
      );
    }
  }

  Future<HttpResult<BasicResponse>?> deleteArticle(int idArticle, String dateUpdatedArticle, String token) async {
    int? statusCode;
    dynamic data;

    // Map<String, String> requestHeaders = {
    //   'Content-type': 'application/json',
    //   'Authorization': 'Bearer $token',
    // };

    final url = await EglConfig.uri(apiArticles, '${EglConfig.apiDeleteArticle}?id_article=$idArticle&date_updated_article=$dateUpdatedArticle');
    try {
      // final response = await http.get(url, headers: requestHeaders);
      final response = await apiClient.get(url, token: token);

      statusCode = response.statusCode;

      // print('Response status: ${response.statusCode}');
      //   Helper.eglLogger('i', 'Response body: ${response.body}');
      if (response.statusCode == 200) {
        final BasicResponse basicResponse = basicUserResponseFromJson(await EglHelper.parseApiUrlBody(response.body));

        // print('Asociations Response body: ${asociationsResponse.result.records}');
        // return userAsocResponse;
        return HttpResult<BasicResponse>(
          data: basicResponse,
          statusCode: statusCode,
          error: null,
        );
      } else if (statusCode > 400) {
        data = parseResponseBody(await EglHelper.parseApiUrlBody(response.body));
        return HttpResult<BasicResponse>(
          data: null,
          error: HttpError(
            data: data,
            exception: null,
            stackTrace: StackTrace.current,
          ),
          statusCode: statusCode,
        );
      } else {
        data = parseResponseBody(await EglHelper.parseApiUrlBody(response.body));
        String message = data['message'];
        return HttpResult<BasicResponse>(
          data: null,
          error: HttpError(
            data: message,
            exception: null,
            stackTrace: StackTrace.current,
          ),
          statusCode: statusCode,
        );
      }
    } catch (e, s) {
      if (e is HttpError) {
        return HttpResult<BasicResponse>(
          data: null,
          error: e,
          statusCode: statusCode!,
        );
      }

      return HttpResult<BasicResponse>(
        data: null,
        error: HttpError(
          exception: e,
          stackTrace: s,
          data: data,
        ),
        statusCode: statusCode ?? -1,
      );
    }
  }

  // end class
}
