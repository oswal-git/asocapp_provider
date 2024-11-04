import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/services/session_service.dart';
import 'package:asocapp/app/repositorys/articles_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleNotifiedController extends ChangeNotifier {
  final SessionService _session;
  final ArticlesRepository articlesRepository;

  ArticleNotifiedController(
    this._session,
    this.articlesRepository,
  );

  Future<bool> isLogin() async => _session.isLogin;

  final _article = Rx<ArticleUser>(ArticleUser.clear());
  ArticleUser get article => _article.value;

  Future<ArticleUser> getSingleArticle(int idarticle) async {
    final ArticleResponse articlesResponse = await articlesRepository.getSingleArticle(idarticle, token: _session.userConnected.tokenUser);

    // print('Response body: ${result}');
    if (articlesResponse.status == 200) {
      _article.value = articlesResponse.result;
    } else {
      _article.value = ArticleUser.clear();
    }
    return _article.value;
  }

  exitSession() {
    _session.exitSession();
  }
}
