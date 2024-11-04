import 'dart:async';
import 'dart:io';

import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/config/config.dart';
import 'package:asocapp/app/controllers/asociation/asociation_controller.dart';
import 'package:asocapp/app/models/models.dart';
import 'package:asocapp/app/repositorys/user_repository.dart';
import 'package:asocapp/app/routes/routes.dart';
import 'package:asocapp/app/services/session_service.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ProfileController extends ChangeNotifier {
  final BuildContext _context;
  final SessionService _session;
  final AsociationController _asociationController;
  final UserRepository _userRepository;

  ProfileController(this._context, this._session, this._asociationController,
      this._userRepository) {
    EglHelper.eglLogger('i', '$runtimeType');

    refreshAsociationsList();

    _userNameFocusNode.addListener(() {
      // Utils.eglLogger('i', "UserName has focus: ${userNameFocusNode.hasFocus}");
    });
  }

  final Logger logger = Logger();

  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: '_profileController');

  final _asociationsFocusNode = FocusNode();
  FocusNode get asociationsFocusNode => _asociationsFocusNode;

  final _userNameFocusNode = FocusNode();
  FocusNode get userNameFocusNode => _userNameFocusNode;

  final _languageUserFocusNode = FocusNode();
  FocusNode get languageUserFocusNode => _languageUserFocusNode;

  final _timeNotificationsFocusNode = FocusNode();
  FocusNode get timeNotificationsFocusNode => _timeNotificationsFocusNode;

  final _profileUserFocusNode = FocusNode();
  FocusNode get profileUserFocusNode => _profileUserFocusNode;

  final _statusUserFocusNode = FocusNode();
  FocusNode get statusUserFocusNode => _statusUserFocusNode;

  UserConnected userConnected = UserConnected.clear();
  UserConnected userConnectedIni = UserConnected.clear();
  UserConnected userConnectedLast = UserConnected.clear();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _isFormValid = false;
  bool get isFormValid => _isFormValid;
  set isFormValid(bool value) {
    _isFormValid = value;
    notifyListeners();
  }

  // Crop code
  String _cropImagePath = '';
  String get cropImagePath => _cropImagePath;
  set cropImagePath(String value) {
    _cropImagePath = value;
    notifyListeners();
  }

  String _cropImageSize = '';
  String get cropImageSize => _cropImageSize;
  set cropImageSize(String value) {
    _cropImageSize = value;
    notifyListeners();
  }

  // Image code
  String _selectedImagePath = '';
  String get selectedImagePath => _selectedImagePath;
  set selectedImagePath(String value) {
    _selectedImagePath = value;
    notifyListeners();
  }

  String _selectedImageSize = '';
  String get selectedImageSize => _selectedImageSize;
  set selectedImageSize(String value) {
    _selectedImageSize = value;
    notifyListeners();
  }

  // Compress code
  String _compressedImagePath = '';
  String get compressedImagePath => _compressedImagePath;
  set compressedImagePath(String value) {
    _compressedImagePath = value;
    notifyListeners();
  }

  String _compressedImageSize = '';
  String get compressedImageSize => _compressedImageSize;
  set compressedImageSize(String value) {
    _compressedImageSize = value;
    notifyListeners();
  }

  XFile? _imageAvatar = XFile('');
  XFile? get imageAvatar => _imageAvatar;
  set imageAvatar(XFile? value) {
    _imageAvatar = value;
    notifyListeners();
  }

  bool checkIsFormValid() {
    // logger.i('checkIsFormValid: ${_imageAvatar!.path}');
    // logger.i('checkIsFormValid: ${_imageAvatar!.path != ''}');
    bool check = _isFormValid = ((formKey.currentState?.validate() ?? false) &&
        (userConnected.idAsociationUser != userConnectedLast.idAsociationUser ||
            userConnected.userNameUser != userConnectedLast.userNameUser ||
            userConnected.timeNotificationsUser !=
                userConnectedLast.timeNotificationsUser ||
            (_imageAvatar == null ? false : _imageAvatar!.path != '') ||
            userConnected.languageUser != userConnectedLast.languageUser));
    notifyListeners();
    return check;
  }

  void onClose() {
    _asociationsFocusNode.dispose();
    _languageUserFocusNode.dispose();
    _timeNotificationsFocusNode.dispose();
    _userNameFocusNode.dispose();
    _profileUserFocusNode.dispose();
    _statusUserFocusNode.dispose();
  }

  bool isLogin() {
    logger.i('isLogin: ');

    try {
      if (!_session.isLogin) {
        // Timer(const Duration(seconds: 3), () => Navigator.pushNamed(context, RouteName.register));
        Navigator.pushReplacementNamed(_context, Routes.dashboardRoute);
        return false;
      }
      userConnected = _session.userConnected!.clone();
      userConnectedIni = userConnected.clone();
      userConnectedLast = userConnected.clone();
      logger.i('isLogin: ${userConnectedIni.idAsociationUser}');
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> exitSession() async {
    return _session.exitSession();
  }

  Future<List<dynamic>> refreshAsociationsList() async {
    return _asociationController.refreshAsociationsList();
  }

  Asociation getAsociationById(int idAsociation) {
    return _asociationController.getAsociationById(idAsociation);
  }

  Future<void> clearAsociations() async {
    return _asociationController.clearAsociations();
  }

  Future<HttpResult<UserAsocResponse>?> updateProfile(
    int idUser,
    String userName,
    int asociationId,
    int intervalNotifications,
    String languageUser,
    String dateUpdatedUser,
  ) async {
    loading = true;

    try {
      final Future<HttpResult<UserAsocResponse>?> response =
          _userRepository.updateProfile(
        idUser,
        userName,
        asociationId,
        intervalNotifications,
        languageUser,
        dateUpdatedUser,
        _session.userConnected!.tokenUser,
      );
      loading = false;
      return response;
    } catch (e) {
      EglHelper.toastMessage(e.toString());
      loading = false;
      return null;
    }
  }

  Future<HttpResult<UserAsocResponse>?> updateProfileAvatar(
    int idUser,
    String userName,
    int asociationId,
    int intervalNotifications,
    String languageUser,
    XFile imageAvatar,
    String dateUpdatedUser,
  ) async {
    loading = true;

    try {
      final Future<HttpResult<UserAsocResponse>?> response =
          _userRepository.updateProfileAvatar(
        idUser,
        userName,
        asociationId,
        intervalNotifications,
        languageUser,
        imageAvatar,
        dateUpdatedUser,
        _session.userConnected!.tokenUser,
      );
      loading = false;
      return response;
    } catch (e) {
      EglHelper.toastMessage(e.toString());
      loading = false;
      return null;
    }
  }

  Future<void> updateUserConnected(UserConnected value, bool loadTask) async {
    userConnected = value;
    return _session.updateUserConnected(value, loadTask: loadTask);
  }

  int setIdAsocAdmin(String profile, int asocId) {
    return _session.setIdAsocAdmin(profile, asocId);
  }

  Widget _imageWidget = const Image(
    image: AssetImage(EglImagesPath.iconUserDefaultProfile),
    fit: BoxFit.scaleDown,
    color: Colors.amberAccent,
  );

  Widget get imageWidget => _imageWidget;
  setImageWidget(XFile? imagePick) {
    _imageAvatar = imagePick;
    // const double widthOval = 200.0;
    // const double heightOval = 200.0;

    if (imagePick == null) {
      // ignore: curly_braces_in_flow_control_structures
      if (userConnected.avatarUser == '') {
        _imageWidget = const ClipOval(
          child: Image(
            image: AssetImage(EglImagesPath.iconUserDefaultProfile),
            //   fit: BoxFit.cover,
            color: Colors.amberAccent,
          ),
        );
      } else {
        _imageWidget = ClipOval(
          child: Image.network(
            userConnected.avatarUser,
            //   width: widthOval,
            //   height: heightOval,
            fit: BoxFit.cover,
          ),
        );
      }
    } else if (imagePick.path.substring(0, 4) == 'http') {
      _imageWidget = ClipOval(
        child: Image.network(
          imagePick.path,
          //   width: widthOval,
          //   height: heightOval,
          fit: BoxFit.cover,
        ),
      );
    } else {
      _imageWidget = ClipOval(
        child: Image.file(
          File(imagePick.path).absolute,
          //   width: widthOval,
          //   height: heightOval,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  pickImage(String option) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
        source: option == 'camera' ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      //   selectedImagePath = File(pickedFile.path);
      selectedImagePath = pickedFile.path;
      selectedImageSize =
          "${(File(selectedImagePath).lengthSync() / 1024 / 1024).toStringAsFixed(2)} Mb";

      // Crop
      final cropImageFile = await ImageCropper().cropImage(
          sourcePath: selectedImagePath,
          maxWidth: 512,
          maxHeight: 512,
          compressFormat: ImageCompressFormat.png);
      cropImagePath = cropImageFile!.path;
      cropImageSize =
          "${(File(cropImagePath).lengthSync() / 1024 / 1024).toStringAsFixed(2)} Mb";

      // Compress
      final dir = Directory.systemTemp;
      final targetPath = '${dir.absolute.path}/tempimage.png';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        cropImagePath,
        targetPath,
        quality: 90,
        format: CompressFormat.png,
      );
      compressedImagePath = compressedFile!.path;
      compressedImageSize =
          "${(File(compressedImagePath).lengthSync() / 1024 / 1024).toStringAsFixed(2)} Mb";

      // final String imageBase64 = base64Encode(imageFile.readAsBytesSync());
      EglHelper.eglLogger('i', 'isLogin: $userConnected');
      setImageWidget(compressedFile);
    }
    //   Helper.eglLogger('i', 'isLogin: ${profileController.imageAvatar!.path}');
    //   Helper.eglLogger('i', 'isLogin: ${profileController.imageAvatar!.path != ''}');
    checkIsFormValid();
  }
}
