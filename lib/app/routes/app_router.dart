import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/repositorys/repositorys.dart';
import 'package:asocapp/app/services/services.dart';
import 'package:go_router/go_router.dart';
import 'package:asocapp/app/controllers/controllers.dart';
import 'package:asocapp/app/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => HomeController(context),
          child: const DashboardPage(),
        ),
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => HomeController(context),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        name: 'dashboard',
        path: '/dashboard',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => DashboardController(context),
          child: const DashboardPage(),
        ),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => LoginController(context),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        name: 'change',
        path: '/change',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => ChangeController(
            Provider.of<SessionService>(context, listen: false),
            Provider.of<UserRepository>(context, listen: false),
            Provider.of<AsociationController>(context, listen: false),
          ),
          child: const ChangePage(),
        ),
      ),
      GoRoute(
        name: 'user',
        path: '/user',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => UserItemController(
            Provider.of<SessionService>(context, listen: false),
            Provider.of<UserRepository>(context, listen: false),
          ),
          child: UserPage(
            user: ModalRoute.of(context)!.settings.arguments as UserItem,
          ),
        ),
      ),
      GoRoute(
        name: 'listUser',
        path: '/listUser',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => ListUsersController(
            context,
            Provider.of<SessionService>(context, listen: false),
            Provider.of<UserRepository>(context, listen: false),
          ),
          child: const ListUsersPage(),
        ),
      ),
      GoRoute(
        name: 'profile',
        path: '/profile',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => ProfileController(
            context,
            Provider.of<SessionService>(context, listen: false),
            Provider.of<AsociationController>(context, listen: false),
            Provider.of<UserRepository>(context, listen: false),
          ),
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        name: 'article',
        path: '/article',
        builder: (context, state) {
          IArticleUserArguments articleArguments = state.extra as IArticleUserArguments;
          return ChangeNotifierProvider(
            create: (context) => ArticleController(
              context,
              Provider.of<SessionService>(context, listen: false),
              Provider.of<ArticlesRepository>(context, listen: false),
            ),
            child: ArticlePage(
              articleArguments: articleArguments,
            ),
          );
        },
      ),
      GoRoute(
        name: 'editArticle',
        path: '/editArticle',
        builder: (context, state) {
          IArticleArguments articleArguments = state.extra as IArticleArguments;

          return ChangeNotifierProvider(
            create: (context) => ArticleController(
              context,
              Provider.of<SessionService>(context, listen: false),
              Provider.of<ArticlesRepository>(context, listen: false),
            ),
            child: EditArticlePage(
              articleArguments: articleArguments,
            ),
          );
        },
      ),
      GoRoute(
        path: '/articleNotification',
        builder: (context, state) {
          IArticleNotifiedArguments articleNotifiedArguments = state.extra as IArticleNotifiedArguments;

          return ChangeNotifierProvider(
            create: (context) => ArticleNotifiedController(
              Provider.of<SessionService>(context, listen: false),
              Provider.of<ArticlesRepository>(context, listen: false),
            ),
            child: ArticleNotifiedPage(
              articleNotifiedArguments: articleNotifiedArguments,
            ),
          );
        },
      ),
    ],
  );
}
