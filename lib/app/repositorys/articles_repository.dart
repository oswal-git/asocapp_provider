import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/apirest/api_models/article_plain_api_model.dart';
import 'package:asocapp/app/apirest/api_models/basic_response_model.dart';
import 'package:asocapp/app/apirest/network/articles_apirest.dart';
import 'package:asocapp/app/models/models.dart';
import 'package:get/get.dart';

class ArticlesRepository {
  ArticlesApiRest articlesApiRest = Get.put<ArticlesApiRest>(ArticlesApiRest());

  Future<NotificationArticleListResponse> getPendingNotifyArticlesList(
          {required String token}) =>
      articlesApiRest.getPendingNotifyArticlesList(token: token);

  Future<ArticleListResponse> getArticles({required String token}) async {
    return articlesApiRest.getArticles(token);
  }

  Future<ArticleResponse> getSingleArticle(int idarticle,
      {required String token}) async {
    return articlesApiRest.getSingleArticle(idarticle, token);
  }

  Future<HttpResult<ArticleUserResponse>?> createArticle(
      ArticlePlain articlePlain,
      ImageArticle imageCoverArticle,
      List<ItemArticle> articleItems,
      UserConnected userConnected) async {
    return articlesApiRest.createArticle(
        articlePlain, imageCoverArticle, articleItems, userConnected);
  }

  Future<HttpResult<ArticleUserResponse>?> modifyArticle(
      ArticlePlain articlePlain,
      ImageArticle imageCoverArticle,
      List<ItemArticle> articleItems,
      UserConnected userConnected) async {
    return articlesApiRest.modifyArticle(
        articlePlain, imageCoverArticle, articleItems, userConnected);
  }

  Future<HttpResult<BasicResponse>?> deleteArticle(
      int idArticle, String dateUpdatedArticle,
      {required String token}) async {
    return articlesApiRest.deleteArticle(idArticle, dateUpdatedArticle, token);
  }
}
