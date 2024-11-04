import 'dart:convert';

import 'package:asocapp/app/models/models.dart';
import 'package:asocapp/app/utils/utils.dart';

Article articleRequestFromJson(String str) => Article.fromJson(json.decode(str));

String articleRequestToJson(Article data) => json.encode(data.toJson());

class Article extends ArticleNotCover {
  ImageArticle coverImageArticle;

  Article({
    required super.idArticle,
    required super.idAsociationArticle,
    required super.idUserArticle,
    required super.categoryArticle,
    required super.subcategoryArticle,
    required super.classArticle,
    required super.stateArticle,
    required super.publicationDateArticle,
    required super.effectiveDateArticle,
    required super.expirationDateArticle,
    required this.coverImageArticle,
    required super.titleArticle,
    required super.abstractArticle,
    required super.ubicationArticle,
    required super.dateDeletedArticle,
    required super.dateCreatedArticle,
    required super.dateUpdatedArticle,
    required super.itemsArticle,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        idArticle: int.parse(json["id_article"]),
        idAsociationArticle: int.parse(json["id_asociation_article"]),
        idUserArticle: int.parse(json["id_user_article"]),
        categoryArticle: json["category_article"],
        subcategoryArticle: json["subcategory_article"],
        classArticle: json["class_article"],
        stateArticle: json["state_article"],
        publicationDateArticle: (json["publication_date_article"]),
        effectiveDateArticle: (json["effective_date_article"]),
        expirationDateArticle: json["expiration_date_article"],
        coverImageArticle: ImageArticle.fromJson(json["cover_image_article"]),
        titleArticle: json["title_article"],
        abstractArticle: json["abstract_article"],
        ubicationArticle: json["ubication_article"],
        dateDeletedArticle: json["date_deleted_article"],
        dateCreatedArticle: (json["date_created_article"]),
        dateUpdatedArticle: (json["date_updated_article"]),
        itemsArticle: List<ItemArticle>.from(json["items_article"].map((x) => ItemArticle.fromJson(x))),
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> toJson = {
      ...super.toJson(),
      "cover_image_article": coverImageArticle.toJson(),
    };

    return toJson;
  }

  @override
  String toString() {
    String cadena = '';

    cadena = '$cadena Article { ';
    cadena = '$cadena idArticle: $idArticle,';
    cadena = '$cadena idAsociationArticle: $idAsociationArticle,';
    cadena = '$cadena idUserArticle: $idUserArticle,';
    cadena = '$cadena categoryArticle: $categoryArticle,';
    cadena = '$cadena subcategoryArticle: $subcategoryArticle,';
    cadena = '$cadena classArticle: $classArticle,';
    cadena = '$cadena stateArticle: $stateArticle,';
    cadena = '$cadena publicationDateArticle: $publicationDateArticle,';
    cadena = '$cadena effectiveDateArticle: $effectiveDateArticle,';
    cadena = '$cadena expirationDateArticle: $expirationDateArticle,';
    cadena = '$cadena coverImageArticle: ${coverImageArticle.toString()},';
    cadena = '$cadena titleArticle: $titleArticle,';
    cadena = '$cadena abstractArticle: $abstractArticle,';
    cadena = '$cadena ubicationArticle: $ubicationArticle,';
    cadena = '$cadena dateDeletedArticle: $dateDeletedArticle,';
    cadena = '$cadena dateCreatedArticle: $dateCreatedArticle,';
    cadena = '$cadena dateUpdatedArticle: $dateUpdatedArticle,';
    itemsArticle.map((e) {
      cadena = '$cadena itemsArticle[${e.idItemArticle}]: ${e.toString()},';
      return;
    });

    return cadena;
  }

  @override
  bool operator ==(Object other) {
    bool bIdentical = identical(this, other);
    bool isArticle = other is Article;

    bool bRuntimeType = false;
    bool bIdArticle = false;
    bool bIdAsociationArticle = false;
    bool bIdUserArticle = false;
    bool bCategoryArticle = false;
    bool bSubcategoryArticle = false;
    bool bClassArticle = false;
    bool bStateArticle = false;
    bool bPublicationDateArticle = false;
    bool bEffectiveDateArticle = false;
    bool bExpirationDateArticle = false;
    bool bCoverImageArticle = false;
    bool bTitleArticle = false;
    bool bAbstractArticle = false;
    bool bUbicationArticle = false;
    bool bDateDeletedArticle = false;
    bool bDateCreatedArticle = false;
    bool bDateUpdatedArticle = false;
    bool bItemsArticle = false;

    if (isArticle) {
      bRuntimeType = runtimeType == other.runtimeType;
      bIdArticle = idArticle == other.idArticle;
      bIdAsociationArticle = idAsociationArticle == other.idAsociationArticle;
      bIdUserArticle = idUserArticle == other.idUserArticle;
      bCategoryArticle = categoryArticle == other.categoryArticle;
      bSubcategoryArticle = subcategoryArticle == other.subcategoryArticle;
      bClassArticle = classArticle == other.classArticle;
      bStateArticle = stateArticle == other.stateArticle;
      bPublicationDateArticle = publicationDateArticle == other.publicationDateArticle;
      bEffectiveDateArticle = effectiveDateArticle == other.effectiveDateArticle;
      bExpirationDateArticle = expirationDateArticle == other.expirationDateArticle;
      bCoverImageArticle = coverImageArticle == other.coverImageArticle;
      bTitleArticle = titleArticle == other.titleArticle;
      bAbstractArticle = abstractArticle == other.abstractArticle;
      bUbicationArticle = ubicationArticle == other.ubicationArticle;
      bDateDeletedArticle = dateDeletedArticle == other.dateDeletedArticle;
      bDateCreatedArticle = dateCreatedArticle == other.dateCreatedArticle;
      bDateUpdatedArticle = dateUpdatedArticle == other.dateUpdatedArticle;
      bItemsArticle = itemsArticle == other.itemsArticle;
      bItemsArticle = EglHelper.listsAreEqual(itemsArticle, other.itemsArticle);
    }

    return bIdentical ||
        (isArticle &&
            bRuntimeType &&
            bIdArticle &&
            bIdAsociationArticle &&
            bIdUserArticle &&
            bCategoryArticle &&
            bSubcategoryArticle &&
            bClassArticle &&
            bStateArticle &&
            bPublicationDateArticle &&
            bEffectiveDateArticle &&
            bExpirationDateArticle &&
            bCoverImageArticle &&
            bTitleArticle &&
            bAbstractArticle &&
            bUbicationArticle &&
            bDateDeletedArticle &&
            bDateCreatedArticle &&
            bDateUpdatedArticle &&
            bItemsArticle);
  }

  @override
  int get hashCode =>
      idArticle.hashCode ^
      idAsociationArticle.hashCode ^
      idUserArticle.hashCode ^
      categoryArticle.hashCode ^
      subcategoryArticle.hashCode ^
      classArticle.hashCode ^
      stateArticle.hashCode ^
      publicationDateArticle.hashCode ^
      effectiveDateArticle.hashCode ^
      expirationDateArticle.hashCode ^
      coverImageArticle.hashCode ^
      titleArticle.hashCode ^
      abstractArticle.hashCode ^
      ubicationArticle.hashCode ^
      dateDeletedArticle.hashCode ^
      dateCreatedArticle.hashCode ^
      dateUpdatedArticle.hashCode ^
      itemsArticle.hashCode;

  factory Article.clear() {
    return Article(
      idArticle: 0,
      idAsociationArticle: 0,
      idUserArticle: 0,
      categoryArticle: '',
      subcategoryArticle: '',
      classArticle: '',
      stateArticle: 'redacción',
      publicationDateArticle: '', // DateFormat('yyyy-MM-dd').format(DateTime.now()),
      effectiveDateArticle: '',
      expirationDateArticle: '',
      coverImageArticle: ImageArticle.clear(),
      titleArticle: '',
      abstractArticle: '',
      ubicationArticle: '',
      dateDeletedArticle: '',
      dateCreatedArticle: '',
      dateUpdatedArticle: '',
      itemsArticle: [],
    );
  }

  @override
  Article copyWith({
    int? idArticle,
    int? idAsociationArticle,
    int? idUserArticle,
    String? categoryArticle,
    String? subcategoryArticle,
    String? classArticle,
    String? stateArticle,
    String? publicationDateArticle,
    String? effectiveDateArticle,
    String? expirationDateArticle,
    ImageArticle? coverImageArticle,
    String? titleArticle,
    String? abstractArticle,
    String? ubicationArticle,
    String? dateDeletedArticle,
    String? dateCreatedArticle,
    String? dateUpdatedArticle,
    List<ItemArticle>? itemsArticle,
  }) {
    return Article(
      idArticle: idArticle ?? this.idArticle,
      idAsociationArticle: idAsociationArticle ?? this.idAsociationArticle,
      idUserArticle: idUserArticle ?? this.idUserArticle,
      categoryArticle: categoryArticle ?? this.categoryArticle,
      subcategoryArticle: subcategoryArticle ?? this.subcategoryArticle,
      classArticle: classArticle ?? this.classArticle,
      stateArticle: stateArticle ?? this.stateArticle,
      publicationDateArticle: publicationDateArticle ?? this.publicationDateArticle,
      effectiveDateArticle: effectiveDateArticle ?? this.effectiveDateArticle,
      expirationDateArticle: expirationDateArticle ?? this.expirationDateArticle,
      coverImageArticle: coverImageArticle ?? this.coverImageArticle,
      titleArticle: titleArticle ?? this.titleArticle,
      abstractArticle: abstractArticle ?? this.abstractArticle,
      ubicationArticle: ubicationArticle ?? this.ubicationArticle,
      dateDeletedArticle: dateDeletedArticle ?? this.dateDeletedArticle,
      dateCreatedArticle: dateCreatedArticle ?? this.dateCreatedArticle,
      dateUpdatedArticle: dateUpdatedArticle ?? this.dateUpdatedArticle,
      itemsArticle: itemsArticle ?? this.itemsArticle,
    );
  }

  void modify({
    int? idArticle,
    int? idAsociationArticle,
    int? idUserArticle,
    String? categoryArticle,
    String? subcategoryArticle,
    String? classArticle,
    String? stateArticle,
    String? publicationDateArticle,
    String? effectiveDateArticle,
    String? expirationDateArticle,
    ImageArticle? coverImageArticle,
    String? titleArticle,
    String? abstractArticle,
    String? ubicationArticle,
    String? dateDeletedArticle,
    String? dateCreatedArticle,
    String? dateUpdatedArticle,
    List<ItemArticle>? itemsArticle,
  }) {
    this.idArticle = idArticle ?? this.idArticle;
    this.idAsociationArticle = idAsociationArticle ?? this.idAsociationArticle;
    this.idUserArticle = idUserArticle ?? this.idUserArticle;
    this.categoryArticle = categoryArticle ?? this.categoryArticle;
    this.subcategoryArticle = subcategoryArticle ?? this.subcategoryArticle;
    this.classArticle = classArticle ?? this.classArticle;
    this.stateArticle = stateArticle ?? this.stateArticle;
    this.publicationDateArticle = publicationDateArticle ?? this.publicationDateArticle;
    this.effectiveDateArticle = effectiveDateArticle ?? this.effectiveDateArticle;
    this.expirationDateArticle = expirationDateArticle ?? this.expirationDateArticle;
    this.coverImageArticle = coverImageArticle ?? this.coverImageArticle;
    this.titleArticle = titleArticle ?? this.titleArticle;
    this.abstractArticle = abstractArticle ?? this.abstractArticle;
    this.ubicationArticle = ubicationArticle ?? this.ubicationArticle;
    this.dateDeletedArticle = dateDeletedArticle ?? this.dateDeletedArticle;
    this.dateCreatedArticle = dateCreatedArticle ?? this.dateCreatedArticle;
    this.dateUpdatedArticle = dateUpdatedArticle ?? this.dateUpdatedArticle;
    this.itemsArticle = itemsArticle ?? this.itemsArticle;
  }

  // end class
}
