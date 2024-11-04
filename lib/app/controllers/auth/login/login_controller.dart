import 'dart:async';

import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/controllers/asociation/asociation_controller.dart';
import 'package:asocapp/app/models/models.dart';
import 'package:asocapp/app/repositorys/user_repository.dart';
import 'package:asocapp/app/routes/routes.dart';
import 'package:asocapp/app/services/services.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class LoginController extends ChangeNotifier {
  final BuildContext _context;
  late SessionService session;
  late AsociationController asociationController;
  late UserRepository userRepository;

  LoginController(this._context) {
    EglHelper.eglLogger('i', '$runtimeType');
    
    session = Provider.of<SessionService>(_context, listen: false);
    asociationController =
        Provider.of<AsociationController>(_context, listen: false);
    userRepository = Provider.of<UserRepository>(_context, listen: false);

    isLogin();

    _userNameFocusNode.addListener(() {
      // Utils.eglLogger('i', "UserName has focus: ${userNameFocusNode.hasFocus}");
    });
  }

  UserConnected? userConnected = UserConnected.clear();

  final Logger logger = Logger();

  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: '_loginController');

  final _asociationsFocusNode = FocusNode();
  FocusNode get asociationsFocusNode => _asociationsFocusNode;

  final _passwordFocusNode = FocusNode();
  FocusNode get passwordFocusNode => _passwordFocusNode;

  final _userNameFocusNode = FocusNode();
  FocusNode get userNameFocusNode => _userNameFocusNode;

  final _password = ''.obs;
  String get password => _password.value;
  set password(String value) {
    _password.value = value;
    notifyListeners();
  }

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(bool value) {
    _loading.value = value;
    notifyListeners();
  }

  void onClose() {
    EglHelper.eglLogger('i', '$runtimeType');

    _asociationsFocusNode.dispose();
    _passwordFocusNode.dispose();
    _userNameFocusNode.dispose();
  }

  Future<void> isLogin() async {
    if (session.isLogin) {
      if (session.userConnected?.recoverPasswordUser == 0) {
        Timer(const Duration(seconds: 3),
            () => Navigator.pushReplacementNamed(_context, Routes.dashboardRoute));
      }
      Timer(const Duration(seconds: 3), () => Navigator.pushReplacementNamed(_context, Routes.changeRoute) );
    }
  }

  bool isLogged() => session.isLogin;

  Future<void> updateUserConnected(UserConnected value,
      {bool loadTask = false}) async {
    await session.updateUserConnected(
      value,
      loadTask: loadTask,
    );
  }

  Future<List<dynamic>> refreshAsociationsList() async {
    return asociationController.refreshAsociationsList();
  }

  Future<UserAsocResponse?> login(
      String username, int asociationId, String password) async {
    loading = true;

    Future<UserAsocResponse?>? userAsocData;

    try {
      userAsocData = userRepository.login(username, asociationId, password);
      // logger.i(userAsocData.toString());
      loading = false;
      return userAsocData;
    } catch (e) {
      EglHelper.toastMessage(e.toString());
      loading = false;
      return null;
    }
  }

  int setIdAsocAdmin(String profile, int asocId) {
    return session.setIdAsocAdmin(profile, asocId);
  }
}
