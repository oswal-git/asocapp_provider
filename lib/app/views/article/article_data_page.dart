import 'package:asocapp/app/controllers/controllers.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:asocapp/app/widgets/fields_widgets/egl_date_piker.dart';
import 'package:asocapp/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleDataPage extends StatefulWidget {
  const ArticleDataPage({super.key});

  @override
  State<ArticleDataPage> createState() => _ArticleDataPageState();
}

class _ArticleDataPageState extends State<ArticleDataPage> {
  late ArticleEditController articleEditController;

  String language = '';
  String country = '';

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback for context-dependent initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      articleEditController = Provider.of<ArticleEditController>(context, listen: false);

      if (articleEditController.newArticle.categoryArticle == '') {
        articleEditController.newArticle.categoryArticle = articleEditController.listArticleCategory[0]['value'];
      }
      articleEditController.actualizelistSubcategory(articleEditController.newArticle.categoryArticle);
      if (articleEditController.newArticle.subcategoryArticle == '') {
        articleEditController.newArticle.subcategoryArticle = articleEditController.listSubcategory[0]['value'];
      }
      if (articleEditController.newArticle.stateArticle == '') {
        articleEditController.newArticle.stateArticle = articleEditController.listArticleState[0]['value'];
      }

      language = articleEditController.session.userConnected.languageUser;
      country = EglHelper.getAppCountryLocale(language);

      articleEditController.firstManageDates();
    });
  }

  @override
  Widget build(BuildContext context) {
    // return const Center(child: Text('ArticleEditionPage'));
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          20.ph,
          _formUI(context, articleEditController),
        ],
      ),
    );
  }

  Widget _formUI(BuildContext context, ArticleEditController articleEditController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        20.ph,
        EglDropdownList(
          context: context,
          labelText: 'lArticleCategory',
          hintText: 'hArticleCategory',
          contentPaddingLeft: 20,
          focusNode: articleEditController.categoryFocusNode,
          nextFocusNode: articleEditController.subcategoryFocusNode,
          lstData: articleEditController.listArticleCategory,
          value: articleEditController.newArticle.categoryArticle,
          onChanged: (onChangedVal) {
            articleEditController.newArticle.categoryArticle = onChangedVal;

            articleEditController.actualizelistSubcategory(onChangedVal);
            articleEditController.newArticle.subcategoryArticle =
                articleEditController.listSubcategory.isNotEmpty ? articleEditController.listSubcategory[0]['value'] : '';
            articleEditController.checkIsFormValid();
          },
          onValidate: (onValidateVal) {
            if (onValidateVal == null) {
              return 'iselectCategory';
            }
            return null;
          },
          borderFocusColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          paddingTop: 0,
          paddingLeft: 0,
          paddingRight: 0,
          paddingBottom: 0,
          borderRadius: 10,
          optionValue: "value",
          optionLabel: "name",
          iconLabel: Icons.category,
        ),
        20.ph,
        EglDropdownList(
            context: context,
            labelText: 'lArticleSubcategory',
            hintText: 'hArticleSubcategory',
            contentPaddingLeft: 20,
            focusNode: articleEditController.subcategoryFocusNode,
            nextFocusNode: articleEditController.stateFocusNode,
            lstData: articleEditController.listSubcategory,
            value: articleEditController.newArticle.subcategoryArticle != ''
                ? articleEditController.newArticle.subcategoryArticle
                : articleEditController.listSubcategory.isNotEmpty
                    ? articleEditController.listSubcategory[0]['value']
                    : '',
            onChanged: (onChangedVal) {
              articleEditController.newArticle.subcategoryArticle = onChangedVal;
              articleEditController.checkIsFormValid();
            },
            onValidate: (onValidateVal) {
              if (onValidateVal == null) {
                return 'iselectSubcategory';
              }
              return null;
            },
            borderFocusColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(context).primaryColor,
            paddingTop: 0,
            paddingLeft: 0,
            paddingRight: 0,
            paddingBottom: 0,
            borderRadius: 10,
            optionValue: "value",
            optionLabel: "name",
            iconLabel: Icons.subject),
        20.ph,
        EglDropdownList(
          context: context,
          labelText: 'lArticleState',
          hintText: 'hArticleState',
          contentPaddingLeft: 20,
          focusNode: articleEditController.stateFocusNode,
          nextFocusNode: articleEditController.stateFocusNode,
          lstData: articleEditController.listArticleState,
          value: articleEditController.newArticle.stateArticle != ''
              ? articleEditController.newArticle.stateArticle
              : articleEditController.listArticleState.isNotEmpty
                  ? articleEditController.listArticleState[0]['value']
                  : '',
          onChanged: (onChangedVal) {
            articleEditController.newArticle.stateArticle = onChangedVal;
            articleEditController.checkIsFormValid();
          },
          onValidate: (onValidateVal) {
            if (onValidateVal == null) {
              return 'iSelectState';
            }
            return null;
          },
          borderFocusColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).primaryColor,
          paddingTop: 0,
          paddingLeft: 0,
          paddingRight: 0,
          paddingBottom: 0,
          borderRadius: 10,
          optionValue: "value",
          optionLabel: "name",
          iconLabel: Icons.security_update_warning_sharp,
        ),
        20.ph,
        EglDatePiker(
          selectedDate: articleEditController.selectedDatePublication,
          firstDate: articleEditController.firstDatePublication,
          lastDate: articleEditController.lastDatePublication,
          languageCode: language,
          countryCode: country,
          canReset: false,
          labelText: 'lPublicationDate',
          iconLabel: Icons.date_range_rounded,
          paddingTop: 0,
          paddingLeft: 30,
          paddingRight: 30,
          paddingBottom: 0,
          contentPaddingLeft: 20,
          borderColor: Theme.of(context).primaryColor,
          borderFocusColor: Theme.of(context).primaryColor,
          borderRadius: 10,
          onDateChanged: (newDate) => articleEditController.managePublicationDate(newDate),
        ),
        EglDatePiker(
          selectedDate: articleEditController.selectedDateEffective,
          firstDate: articleEditController.firstDateEffective,
          lastDate: articleEditController.lastDateEffective,
          languageCode: language,
          countryCode: country,
          canReset: false,
          labelText: 'lEffectiveDate',
          iconLabel: Icons.date_range_rounded,
          paddingTop: 0,
          paddingLeft: 30,
          paddingRight: 30,
          paddingBottom: 0,
          contentPaddingLeft: 20,
          borderColor: Theme.of(context).primaryColor,
          borderFocusColor: Theme.of(context).primaryColor,
          borderRadius: 10,
          onDateChanged: (newDate) => articleEditController.manageEffectiveDate(newDate),
        ),
        1.ph,
        EglDatePiker(
          selectedDate: articleEditController.selectedDateExpiration,
          firstDate: articleEditController.firstDateExpiration,
          lastDate: articleEditController.lastDateExpiration,
          languageCode: language,
          countryCode: country,
          labelText: 'Fecha de expiración',
          iconLabel: Icons.date_range_rounded,
          paddingTop: 0,
          paddingLeft: 30,
          paddingRight: 30,
          paddingBottom: 0,
          contentPaddingLeft: 20,
          borderColor: Theme.of(context).primaryColor,
          borderFocusColor: Theme.of(context).primaryColor,
          borderRadius: 10,
          onDateChanged: (newDate) {
            articleEditController.selectedDateExpiration = newDate;
            articleEditController.newArticle.expirationDateArticle = EglHelper.datetimeToAaaammdd(newDate);
          },
        ),
      ],
    );

    // end _formUI
  }

// End class
}
