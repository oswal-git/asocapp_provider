import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/controllers/controllers.dart';
import 'package:asocapp/app/repositorys/repositorys.dart';
import 'package:asocapp/app/services/services.dart';
import 'package:asocapp/app/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Routes {
  static const String initialRoute = '/';
  static const String homeRoute = '/home';
  static const String dashboardRoute = '/dashboard';
  static const String loginRoute = '/login';
  static const String changeRoute = '/change';
  static const String userRoute = '/user';
  static const String listUserRoute = '/listUser';
  static const String profileRoute = '/profile';
  static const String articleRoute = '/article';
  static const String editArticleRoute = '/editArticle';
  static const String articleNotificationRoute = '/articleNotification';

  static Map<String, WidgetBuilder> get routes => {
        loginRoute: (context) => ChangeNotifierProvider(
              create: (context) => LoginController(context),
              child: const LoginPage(),
            ),
        homeRoute: (context) => ChangeNotifierProvider(
              create: (context) => HomeController(context),
              child: const HomePage(),
            ),
        dashboardRoute: (context) => ChangeNotifierProvider(
              create: (context) => DashboardController(context),
              child: const DashboardPage(),
            ),
        changeRoute: (context) => ChangeNotifierProvider(
              create: (context) => ChangeController(
                Provider.of<SessionService>(context, listen: false),
                Provider.of<UserRepository>(context, listen: false),
                Provider.of<AsociationController>(context, listen: false),
              ),
              child: const ChangePage(),
            ),
        userRoute: (context) => ChangeNotifierProvider(
              create: (context) => UserItemController(
                Provider.of<SessionService>(context, listen: false),
                Provider.of<UserRepository>(context, listen: false),
              ),
              child: UserPage(
                user: ModalRoute.of(context)!.settings.arguments as UserItem,
              ),
            ),
        listUserRoute: (context) => ChangeNotifierProvider(
              create: (context) => ListUsersController(
                context,
                Provider.of<SessionService>(context, listen: false),
                Provider.of<UserRepository>(context, listen: false),
              ),
              child: const ListUsersPage(),
            ),
        profileRoute: (context) => ChangeNotifierProvider(
              create: (context) => ProfileController(
                context,
                Provider.of<SessionService>(context, listen: false),
                Provider.of<AsociationController>(context, listen: false),
                Provider.of<UserRepository>(context, listen: false),
              ),
              child: const ProfilePage(),
            ),
        articleRoute: (context) => ChangeNotifierProvider(
              create: (context) => ArticleController(
                context,
                Provider.of<SessionService>(context, listen: false),
                Provider.of<ArticlesRepository>(context, listen: false),
              ),
              child: ArticlePage(
                articleArguments: ModalRoute.of(context)!.settings.arguments as IArticleUserArguments,
              ),
            ),
        editArticleRoute: (context) => ChangeNotifierProvider(
              create: (context) => ArticleController(
                context,
                Provider.of<SessionService>(context, listen: false),
                Provider.of<ArticlesRepository>(context, listen: false),
              ),
              child: EditArticlePage(
                articleArguments: ModalRoute.of(context)!.settings.arguments as IArticleArguments,
              ),
            ),
        articleNotificationRoute: (context) => ChangeNotifierProvider(
              create: (context) => ArticleNotifiedController(
                Provider.of<SessionService>(context, listen: false),
                Provider.of<ArticlesRepository>(context, listen: false),
              ),
              child: ArticleNotifiedPage(
                articleNotifiedArguments: ModalRoute.of(context)!.settings.arguments as IArticleNotifiedArguments,
              ),
            ),
      };
}
