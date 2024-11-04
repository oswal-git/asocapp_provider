import 'dart:async';

import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/apirest/api_models/article_plain_api_model.dart';
import 'package:asocapp/app/config/config.dart';
import 'package:asocapp/app/models/article_model.dart';
import 'package:asocapp/app/models/image_article_model.dart';
import 'package:asocapp/app/models/item_article_model.dart';
import 'package:asocapp/app/repositorys/repositorys.dart';
import 'package:asocapp/app/resources/resources.dart';
import 'package:asocapp/app/services/services.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ArticleEditController extends ChangeNotifier {
  final BuildContext _context;
  late SessionService session;

  ArticleEditController(this._context) {
    session = Provider.of<SessionService>(_context, listen: false);

    EglImagesPath.getAppIconUserDefault().then((value) {
      _iconUserDefaultProfile = value;
    }, onError: (error) {
      _iconUserDefaultProfile = '';
    });
    // // Escucha cambios en selectedDatePublication
    // ever(selectedDatePublication, (DateTime date) {
    // });
  }
  final ArticlesRepository articlesRepository = ArticlesRepository();

  bool isNew = true;

  Article _oldArticle = (Article.clear());
  Article get oldArticle => _oldArticle;
  set oldArticle(Article value) {
    _oldArticle = value;
    notifyListeners();
  }

  Article _newArticle = Article.clear();
  Article get newArticle => _newArticle;
  set newArticle(Article value) {
    _newArticle = value;
    notifyListeners();
  }

  int get articleItemsCount => _newArticle.itemsArticle.length;

  set addItemArticle(ItemArticle value) {
    // _newArticleItems.add(value);
    _newArticle.itemsArticle.add(value);
    // _newArticle.itemsArticle = _newArticleItems;
    notifyListeners();
  }

  void insertItemArticle(int index, ItemArticle item) {
    // _newArticleItems.insert(index, item);
    _newArticle.itemsArticle.insert(index, item);
    // _newArticle.itemsArticle = _newArticleItems;
    notifyListeners();
  }

  ItemArticle deleteItemArticle(int value) {
    // final ItemArticle item = _newArticleItems.removeAt(value);
    final ItemArticle item = _newArticle.itemsArticle.removeAt(value);
    // _newArticle.itemsArticle = _newArticleItems;
    notifyListeners();
    return item;
  }

  discardItemArticle(ItemArticle value) {
    // _newArticleItems.removeWhere((item) => item.idItemArticle == value.idItemArticle);
    _newArticle.itemsArticle.removeWhere((item) => item.idItemArticle == value.idItemArticle);
    notifyListeners();
  }

  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();

  DateTime selectedDatePublication = DateTime.now();
  DateTime firstDatePublication = DateTime.now();
  DateTime lastDatePublication = DateTime(3000);
  String textDatePublication = 'dd/mm/aaaa';
  DateTime selectedDateEffective = DateTime.now();
  DateTime firstDateEffective = DateTime.now();
  DateTime lastDateEffective = DateTime(3000);
  String textDateEffective = 'dd/mm/aaaa';
  DateTime selectedDateExpiration = DateTime(4000);
  DateTime firstDateExpiration = DateTime.now();
  DateTime lastDateExpiration = DateTime(4001);
  String textDateExpiration = 'dd/mm/aaaa';

  final _titleArticleFocusNode = FocusNode();
  FocusNode get titleArticleFocusNode => _titleArticleFocusNode;

  final _abstractArticleFocusNode = FocusNode();
  FocusNode get abstractArticleFocusNode => _abstractArticleFocusNode;

  final _categoryFocusNode = FocusNode();
  FocusNode get categoryFocusNode => _categoryFocusNode;

  final _subcategoryFocusNode = FocusNode();
  FocusNode get subcategoryFocusNode => _subcategoryFocusNode;

  final _stateFocusNode = FocusNode();
  FocusNode get stateFocusNode => _stateFocusNode;

  List<dynamic> listArticleCategory = ArticleCategory.getListArticleCategory();
  List<dynamic> listArticleSubcategory = ArticleSubcategory.getListArticleSubcategory();
  List<dynamic> listArticleState = ArticleState.getListArticleState();

  List<dynamic> _listSubcategory = [];
  List<dynamic> get listSubcategory => _listSubcategory;
  void actualizelistSubcategory(String value) {
    _listSubcategory = [];

    final List<dynamic> list = listArticleSubcategory
        .where((element) => element['category'].toString() == value)
        .map((e) => {'value': e['value'], 'name': e['name']})
        .toList();

    _listSubcategory = list;
  }

  bool _imageCoverChanged = false;
  bool get imageCoverChanged => _imageCoverChanged;
  set imageCoverChanged(bool value) => _imageCoverChanged = value;

  XFile? _imageCover = (XFile(''));
  XFile? get imageCover => _imageCover;
  set imageCover(XFile? value) => _imageCover = value;

  final _appLogo = '';
  String get appLogo => _appLogo;

  String _iconUserDefaultProfile = '';
  String get iconUserDefaultProfile => _iconUserDefaultProfile;
  set iconUserDefaultProfile(String value) => _iconUserDefaultProfile = value;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) => _loading = value;

  bool _isFormValid = false;
  bool get isFormValid => _isFormValid;
  set isFormValid(bool value) => _isFormValid = value;

  bool _canSave = false;
  bool get canSave => _canSave;

  bool titleOk = false;
  int minLengthTitle = 4;
  int maxLengthTitle = 100;
  bool abstractOk = false;
  int minLengthAbstract = 4;
  int maxLengthAbstract = 200;

  bool checkIsFormValid() {
    // Helper.eglLogger('i','checkIsFormValid: ${_imageCover!.path}');
    // Helper.eglLogger('i','checkIsFormValid: ${_imageCover!.path != ''}');
    bool valid = checkFields();
    _isFormValid = valid;
    notifyListeners();
    return _isFormValid;
  }

  bool checkFields() {
    // Helper.eglLogger('i','checkIsFormValid: ${_imageCover!.path}');
    // Helper.eglLogger('i','checkIsFormValid: ${_imageCover!.path != ''}');
    bool valid = (titleOk && abstractOk && (_imageCoverChanged || !_newArticle.coverImageArticle.isDefault));

    if (valid && _newArticle.itemsArticle.isNotEmpty) {
      valid = _newArticle.itemsArticle.every((ItemArticle item) {
        bool value = (item.textItemArticle != '' || !item.imageItemArticle.isDefault);
        return value;
      });
      // Llamar al método 'myMethod' dinámicamente
    }

    _canSave = valid;
    return _canSave;
  }

  void onClose() {
    _titleArticleFocusNode.dispose();
    _abstractArticleFocusNode.dispose();
    _categoryFocusNode.dispose();
    _subcategoryFocusNode.dispose();
    _stateFocusNode.dispose();
  }

  Future<HttpResult<ArticleUserResponse>?> createArticle(
      BuildContext context, ArticlePlain articlePlain, ImageArticle imageCoverArticle, List<ItemArticle> articleItems) async {
    loading = true;

    try {
      loading = false;
      return articlesRepository.createArticle(articlePlain, imageCoverArticle, articleItems, session.userConnected);
    } catch (e) {
      EglHelper.toastMessage((e.toString()));
      loading = false;
      return null;
    }
  }

  Future<HttpResult<ArticleUserResponse>?> modifyArticle(
      BuildContext context, ArticlePlain articlePlain, ImageArticle imageCoverArticle, List<ItemArticle> articleItems) async {
    loading = true;

    try {
      loading = false;
      return articlesRepository.modifyArticle(articlePlain, imageCoverArticle, articleItems, session.userConnected);
    } catch (e) {
      EglHelper.toastMessage((e.toString()));
      loading = false;
      return null;
    }
  }

  firstManageDates() {
    newArticle.publicationDateArticle =
        newArticle.publicationDateArticle == '' ? EglHelper.datetimeToAaaammdd(DateTime.now()) : newArticle.publicationDateArticle;

    newArticle.effectiveDateArticle = newArticle.effectiveDateArticle == ''
        ? newArticle.publicationDateArticle
        : newArticle.effectiveDateArticle.compareTo(newArticle.publicationDateArticle) < 0
            ? newArticle.publicationDateArticle
            : newArticle.effectiveDateArticle;

    newArticle.expirationDateArticle = newArticle.expirationDateArticle == ''
        ? EglHelper.datetimeToAaaammdd(DateTime(4000))
        : newArticle.expirationDateArticle.compareTo(newArticle.effectiveDateArticle) < 0
            ? newArticle.effectiveDateArticle
            : newArticle.expirationDateArticle;

    selectedDatePublication = EglHelper.aaaammddToDatetime(newArticle.publicationDateArticle);
    firstDatePublication = selectedDatePublication;
    textDatePublication =
        selectedDatePublication.isAtSameMomentAs(DateTime(4000)) ? 'dd/mm/aaaa' : DateFormat('dd/MM/yyyy').format(selectedDatePublication);

    selectedDateEffective = EglHelper.aaaammddToDatetime(newArticle.effectiveDateArticle);
    firstDateEffective = selectedDatePublication;
    textDateEffective =
        selectedDateEffective.isAtSameMomentAs(DateTime(4000)) ? 'dd/mm/aaaa' : DateFormat('dd/MM/yyyy').format(selectedDateEffective);

    selectedDateExpiration = EglHelper.aaaammddToDatetime(newArticle.expirationDateArticle);
    firstDateExpiration = selectedDateEffective;
    textDateExpiration =
        selectedDateExpiration.isAtSameMomentAs(DateTime(4000)) ? 'dd/mm/aaaa' : DateFormat('dd/MM/yyyy').format(selectedDateExpiration);
  }

  managePublicationDate(DateTime newDate) {
    selectedDatePublication = newDate;
    newArticle.publicationDateArticle = EglHelper.datetimeToAaaammdd(newDate);
    textDatePublication = newDate.isAtSameMomentAs(DateTime(4000)) ? 'dd/mm/aaaa' : DateFormat('dd/MM/yyyy').format(newDate);

    if (newDate.isAfter(selectedDateEffective)) {
      selectedDateEffective = newDate;
      firstDateEffective = newDate;

      newArticle.effectiveDateArticle = EglHelper.datetimeToAaaammdd(newDate);
      textDateEffective = newDate.isAtSameMomentAs(DateTime(4000)) ? 'dd/mm/aaaa' : DateFormat('dd/MM/yyyy').format(newDate);

      if (newDate.isAfter(selectedDateExpiration)) {
        selectedDateExpiration = newDate;
        firstDateExpiration = newDate;
        newArticle.expirationDateArticle = EglHelper.datetimeToAaaammdd(newDate);
        textDateExpiration = newDate.isAtSameMomentAs(DateTime(4000)) ? 'dd/mm/aaaa' : DateFormat('dd/MM/yyyy').format(newDate);
      } else {
        firstDateExpiration = newDate;
      }
    } else {
      firstDateEffective = newDate;
      firstDateExpiration = selectedDateEffective;
    }
  }

  manageEffectiveDate(DateTime newDate) {
    selectedDateEffective = newDate;
    newArticle.effectiveDateArticle = EglHelper.datetimeToAaaammdd(newDate);
    textDateEffective = newDate.isAtSameMomentAs(DateTime(4000)) ? 'dd/mm/aaaa' : DateFormat('dd/MM/yyyy').format(newDate);

    if (newDate.isAfter(selectedDateExpiration)) {
      selectedDateExpiration = newDate;
      firstDateExpiration = newDate;
      newArticle.expirationDateArticle = EglHelper.datetimeToAaaammdd(newDate);
      textDateExpiration = newDate.isAtSameMomentAs(DateTime(4000)) ? 'dd/mm/aaaa' : DateFormat('dd/MM/yyyy').format(newDate);
    } else {
      firstDateExpiration = newDate;
    }
  }

  // fin class
}
