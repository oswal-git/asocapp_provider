// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:asocapp/app/config/config.dart';
import 'package:asocapp/app/resources/resources.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:asocapp/app/views/article/argument_article_interface.dart';
import 'package:asocapp/app/views/article/item_article_widget.dart';
import 'package:asocapp/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({
    super.key,
    required this.articleArguments,
  });

  final IArticleUserArguments articleArguments;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {

  @override
  Widget build(BuildContext context) {
    // String translatTitle = '';

    return Scaffold(
      // drawer: const NavBar(),
      appBar: EglAppBar(
        // backgroundColor: Colors.redAccent,
        showBackArrow: true,
        title: 'tArticle'.tr,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            color: Colors.grey[100],
          ),
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.articleArguments.article.titleArticle,
                        textAlign: TextAlign.center,
                        style: AppTheme.headline4.copyWith(
                          height: 0.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Avatar user
              Container(
                margin: const EdgeInsets.all(8.0),
                // decoration: BoxDecoration(
                //   // color: Colors.transparent,
                //   border: Border.all(
                //     color: Colors.green, // color del borde
                //     width: 2.0, // ancho del borde
                //   ),
                // ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          child: Image.network(
                            widget.articleArguments.article.avatarUser,
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.articleArguments.article.nameUser} ${widget.articleArguments.article.lastNameUser}',
                            style: AppTheme.bodyText2.copyWith(
                              fontSize: 10,
                              height: 0.0,
                            ),
                          ),
                          2.ph,
                          Text(
                            '${'lDate'.tr}: ${DateFormat('fDateFormat'.tr).format(DateTime.parse(widget.articleArguments.article.effectiveDateArticle))}',
                            style: AppTheme.bodyText2.copyWith(
                              fontSize: 9,
                              height: 0.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Cover
              if (widget.articleArguments.article.itemsArticle.isEmpty)
                AnimatedContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 8.00),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(
                    //   color: Colors.blue, // color del borde
                    //   width: 2.0, // ancho del borde
                    // ),
                  ),
                  duration: 1.seconds,
                  child: Container(
                    // width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0), // ajusta el radio según sea necesario
                      border: Border.all(
                        color: Colors.transparent, // color del borde
                        width: 2.0, // ancho del borde
                      ),
                    ),
                    child: EglImageWidget(
                      image: widget.articleArguments.article.coverImageArticle,
                      defaultImage: EglImagesPath.appCoverDefault,
                      isEditable: false,
                      canDefault: false,
                      onPressedDefault: (_) {},
                      onPressedRestore: (_) {},
                    ),
                  ),
                ),
              // Abstract
              if (widget.articleArguments.article.itemsArticle.isEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[100],
                  //   border: Border.all(
                  //     width: 1.0,
                  //     color: Colors.brown,
                  //   ),
                  // ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.justify,
                          '   ${widget.articleArguments.article.abstractArticle}',
                          style: AppTheme.bodyText2.copyWith(
                            height: 1.5,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.articleArguments.article.itemsArticle.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: widget.articleArguments.article.itemsArticle.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(10),
                        //   color: Colors.grey[100],
                        //   border: Border.all(
                        //     width: 1.0,
                        //     color: Colors.red,
                        //   ),
                        // ),
                        child: ItemArticleWidget(item: item),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
