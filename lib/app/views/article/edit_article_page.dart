import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/apirest/api_models/article_plain_api_model.dart';
import 'package:asocapp/app/config/config.dart';
import 'package:asocapp/app/controllers/article/article_controller.dart';
import 'package:asocapp/app/controllers/article/article_edit_controller.dart';
import 'package:asocapp/app/models/image_article_model.dart';
import 'package:asocapp/app/services/services.dart';
import 'package:asocapp/app/translations/messages.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:asocapp/app/views/views.dart';
import 'package:asocapp/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({
    super.key,
    required this.articleArguments,
  });

  final IArticleArguments articleArguments;

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> with SingleTickerProviderStateMixin {
  late SessionService _session;
  late ArticleController _articleController;
  late ArticleEditController _articleEditController;

  late TabController controller;

  final List<Tab> articleTabs = <Tab>[
    const Tab(text: "Article editor"),
    const Tab(text: "Article data"),
  ];

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);

    // Use addPostFrameCallback for context-dependent initialization
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    _session = Provider.of<SessionService>(context, listen: false);
    _articleController = Provider.of<ArticleController>(context, listen: false);
    _articleEditController = Provider.of<ArticleEditController>(context, listen: false);
    _articleEditController.oldArticle = widget.articleArguments.article.copyWith();
    _articleEditController.newArticle = widget.articleArguments.article.copyWith();
    // articleEditController.oldArticleItems = List<ItemArticle>.from(articleArguments.article.itemsArticle);
    // articleEditController.newArticleItems = List<ItemArticle>.from(articleArguments.article.itemsArticle);

    // articleEditController.oldArticleItems = articleArguments.article.itemsArticle.map((item) => item.copyWith()).toList();
    // articleEditController.newArticleItems = articleArguments.article.itemsArticle.map((item) => item.copyWith()).toList();

    if (widget.articleArguments.hasArticle) {
      _articleEditController.isNew = false;
      _articleEditController.titleOk = true;
      _articleEditController.abstractOk = true;
      // _articleEditController.checkIsFormValid();
      // _articleEditController.imagePropertie.value = Image.network(_articleEditController.newArticle.coverImageArticle.src);
    } else {
      _articleEditController.isNew = true;
      int asoc = _session.userConnected.idAsociationUser == 0 ? int.parse('9' * 9) : _session.userConnected.idAsociationUser;
      _articleEditController.oldArticle.modify(
        idAsociationArticle: asoc,
        idUserArticle: _session.userConnected.idUser,
      );
      _articleEditController.oldArticle.coverImageArticle.modify(
        src: EglImagesPath.appCoverDefault,
        nameFile: EglHelper.getNameFilePath(EglImagesPath.appCoverDefault),
        isDefault: true,
      );

      _articleEditController.newArticle.modify(
        idAsociationArticle: asoc,
        idUserArticle: _session.userConnected.idUser,
      );
      _articleEditController.newArticle.coverImageArticle.modify(
        src: EglImagesPath.appCoverDefault,
        nameFile: EglHelper.getNameFilePath(EglImagesPath.appCoverDefault),
        isDefault: true,
      );

      // _articleEditController.imagePropertie.value = Image.asset(EglImagesPath.appIconUserDefault);
    }

    _articleEditController.checkIsFormValid();
    // });
  }

  @override
  void dispose() {
    controller.dispose();
    _articleEditController.onClose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final myTranslation = Messages.of(context);
    final currentLocale = Localizations.localeOf(context); // Get the current locale

    leadingOnPressed() {
      // Callback for confirmation)
      bool articleChanged = !(_articleEditController.newArticle == _articleEditController.oldArticle);
      bool itemsChanged = !(EglHelper.listsAreEqual(_articleEditController.newArticle.itemsArticle, _articleEditController.oldArticle.itemsArticle));
      if (articleChanged || itemsChanged) {
        EglHelper.showConfirmationPopup(
          context: context,
          title: 'Descartar modificaciones del artículo',
          textOkButton: 'Descartar',
          message: 'Seguro que quieres descartar los cambios en el artículo ${_articleEditController.newArticle.titleArticle}',
        ).then((value) {
          // Manejar el resultado aquí si es necesario
          if (value != null && value == true) {
            // Confirmado
            articleChanged ? _articleEditController.newArticle = _articleEditController.oldArticle.copyWith() : null;
            itemsChanged
                ? _articleEditController.newArticle.itemsArticle = EglHelper.copyListItems(_articleEditController.oldArticle.itemsArticle)
                : null;

            // Navigator.pop(context);
            context.pop();
            return true;
          } else {
            // Cancelado
            return false;
          }
        });
      } else {
        context.pop();
        return true;
      }
    }

    Future<bool> createArticle() async {
      ArticlePlain articlePlain = ArticlePlain.fromArticle(article: _articleEditController.newArticle);
      ImageArticle imageCoverArticle = _articleEditController.newArticle.coverImageArticle;
      EglHelper.eglLogger('i', _articleEditController.newArticle.toString());
      EglHelper.eglLogger('i', _articleEditController.newArticle.itemsArticle.toString());
      HttpResult<ArticleUserResponse>? httpResult = await _articleEditController.createArticle(
        context,
        articlePlain,
        imageCoverArticle,
        _articleEditController.newArticle.itemsArticle,
      );
      if (httpResult!.statusCode == 200) {
        if (httpResult.data != null) {
          if (context.mounted) {
            EglHelper.popMessage(context, MessageType.info, 'Article created', _articleEditController.newArticle.titleArticle);
          }
          await _articleController.getArticles();
          context.pop();
          context.pop();
          // Navigator.pop(context);
          // Navigator.pop(context);
          return true;
        } else {
          EglHelper.toastMessage(httpResult.error.toString());
          return false;
        }
      } else if (httpResult.statusCode == 400) {
        if (context.mounted) {
          EglHelper.popMessage(
              context, MessageType.info, myTranslation.translate('mUnexpectedError', currentLocale.languageCode), httpResult.error?.data);
          EglHelper.eglLogger('e', httpResult.error?.data);
        }
        return false;
      } else if (httpResult.statusCode == 404) {
        if (context.mounted) {
          EglHelper.popMessage(context, MessageType.info, myTranslation.translate('mUnexpectedError', currentLocale.languageCode),
              myTranslation.translate('mNoScriptAvailable', currentLocale.languageCode));
          EglHelper.eglLogger('e', httpResult.error?.data);
        }
        return false;
      } else {
        if (context.mounted) {
          EglHelper.popMessage(
              context, MessageType.info, myTranslation.translate('mUnexpectedError', currentLocale.languageCode), httpResult.error?.data);
          EglHelper.eglLogger('e', httpResult.error?.data);
        }
        return false;
      }
    }

    modifyArticle() async {
      ArticlePlain articlePlain = ArticlePlain.fromArticle(article: _articleEditController.newArticle);
      ImageArticle imageCoverArticle = _articleEditController.newArticle.coverImageArticle;
      // EglHelper.eglLogger('i', _articleEditController.newArticle.toString());
      // EglHelper.eglLogger('i', _articleEditController.newArticleItems.toString());
      HttpResult<ArticleUserResponse>? httpResult = await _articleEditController.modifyArticle(
        context,
        articlePlain,
        imageCoverArticle,
        _articleEditController.newArticle.itemsArticle,
      );
      if (httpResult!.statusCode == 200) {
        if (httpResult.data != null) {
          if (context.mounted) {
            await EglHelper.popMessage(context, MessageType.info, 'Article modified', _articleEditController.newArticle.titleArticle);
            context.pop();
            // Navigator.pop(context);
          }
          await _articleController.getArticles();
          if (context.mounted) {
            context.pop();
            // Navigator.pop(context);
          }
          return;
        } else {
          EglHelper.toastMessage(httpResult.error.toString());
          return;
        }
      } else if (httpResult.statusCode == 400) {
        if (context.mounted) {
          EglHelper.popMessage(
              context, MessageType.info, myTranslation.translate('mUnexpectedError', currentLocale.languageCode), httpResult.error?.data);
          EglHelper.eglLogger('e', httpResult.error?.data);
        }
        return;
      } else if (httpResult.statusCode == 404) {
        if (context.mounted) {
          EglHelper.popMessage(context, MessageType.info, myTranslation.translate('mUnexpectedError', currentLocale.languageCode),
              myTranslation.translate('mNoScriptAvailable', currentLocale.languageCode));
          EglHelper.eglLogger('e', httpResult.error?.data['message']);
        }
        return;
      } else if (httpResult.statusCode == 503) {
        if (context.mounted) {
          EglHelper.popMessage(context, MessageType.info, 'Sin conexión.', myTranslation.translate('mNoScriptAvailable', currentLocale.languageCode));
          EglHelper.eglLogger('e', httpResult.error?.data['message']);
        }
        return;
      } else if (httpResult.statusCode == 513) {
        if (context.mounted) {
          EglHelper.popMessage(
              context, MessageType.info, httpResult.data!.message, myTranslation.translate('mNoScriptAvailable', currentLocale.languageCode));
          EglHelper.eglLogger('e', httpResult.error?.data['message']);
        }
        return;
      } else {
        if (context.mounted) {
          EglHelper.popMessage(
              context, MessageType.info, myTranslation.translate('mUnexpectedError', currentLocale.languageCode), httpResult.error?.data);
          EglHelper.eglLogger('e', httpResult.error?.data);
        }
        return;
      }
    }

    return Scaffold(
        appBar: EglAppBar(
            //   elevation: 5,
            title: myTranslation.translate('tArticle', currentLocale.languageCode),
            //   titleWidget: Text("tArticles".tr),
            //   leadingWidget: const Icon(Icons.menu),
            //   hasDrawer: false,
            toolbarHeight: 80,
            showBackArrow: false,
            leadingIcon: Icons.arrow_back,
            leadingOnPressed: () => leadingOnPressed(),
            leadingWidget: null,
            bottom: TabBar(
              controller: controller,
              tabs: articleTabs,
            ),
            actions: [
              // Save article
              EglCircleIconButton(
                color: EglColorsApp.iconColor,
                backgroundColor: EglColorsApp.transparent,
                icon: Icons.save, // Cambiar a tu icono correspondiente
                size: 30,
                enabled: _articleEditController.canSave,
                onPressed: () async {
                  bool articleNotChanged = (_articleEditController.newArticle == _articleEditController.oldArticle);
                  bool itemsNotChanged =
                      (EglHelper.listsAreEqual(_articleEditController.newArticle.itemsArticle, _articleEditController.oldArticle.itemsArticle));
                  if (articleNotChanged && itemsNotChanged) {
                    // if (_articleEditController.newArticle == _articleEditController.oldArticle) {
                    await EglHelper.showPopMessage(context, 'No ha cambiado nada', '', withImage: false, onPressed: () {
                      Navigator.pop(context);
                    });
                    return;
                  }
                  if (_articleEditController.isNew) {
                    final res = await createArticle();
                    if (res) {
                      context.pop();
                    }
                  } else {
                    modifyArticle();
                  }
                },
              ),
              // : 1.pw;
              5.pw,

              // Browse article
              EglCircleIconButton(
                color: Colors.indigo.shade900,
                backgroundColor: EglColorsApp.transparent,
                icon: Icons.monitor, // Cambiar a tu icono correspondiente
                size: 30,
                enabled: _articleEditController.canSave,
                onPressed: () {
                  IArticleUserArguments args = IArticleUserArguments(
                    ArticleUser.fromArticle(
                      article: _articleEditController.newArticle,
                      numOrder: 0,
                      idUser: _session.userConnected.idUser,
                      idAsociationUser: _session.userConnected.idAsociationUser,
                      emailUser: _session.userConnected.emailUser,
                      profileUser: _session.userConnected.profileUser,
                      nameUser: _session.userConnected.nameUser,
                      lastNameUser: _session.userConnected.lastNameUser,
                      avatarUser: _session.userConnected.avatarUser,
                      longNameAsociation: _session.userConnected.longNameAsoc,
                      shortNameAsociation: _session.userConnected.shortNameAsoc,
                    ),
                  );
                  context.goNamed('article', extra: args);
                },
              ),
              // : 1.pw;
              5.pw,
            ]),
        body: TabBarView(
          controller: controller,
          children: const [
            ArticleEditionPage(),
            ArticleDataPage(),
          ],
        ));
  }
}
