// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:asocapp/app/controllers/controllers.dart';
import 'package:asocapp/app/repositorys/repositorys.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:asocapp/app/views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/models/models.dart';

import '../../../services/services.dart';

class ChangeController extends ChangeNotifier {
  final SessionService _session;
  final UserRepository userRepository;

  final AsociationController asociationController;

  ChangeController(
    this._session,
    this.userRepository,
    this.asociationController,
  ) {
    userConnected = _session.userConnected;

    passwordFocusNode.addListener(() {
      logger.i("Password has focus: ${passwordFocusNode.hasFocus}");
    });
    newPasswordFocusNode.addListener(() {
      logger.i("New password has focus: ${newPasswordFocusNode.hasFocus}");
    });
  }

  UserConnected? userConnected = UserConnected.clear();
  final Logger logger = Logger();

  GlobalKey<FormState> formKey = GlobalKey<FormState>(debugLabel: '_changeController');

  TextEditingController passwordTextController = TextEditingController();
  TextEditingController newPasswordTextController = TextEditingController();

  final _passwordFocusNode = FocusNode().obs;
  FocusNode get passwordFocusNode => _passwordFocusNode.value;

  final _newPasswordFocusNode = FocusNode().obs;
  FocusNode get newPasswordFocusNode => _newPasswordFocusNode.value;

  final password = ''.obs;
  final newPassword = ''.obs;

  final _loading = true.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  void onClose() {
    _passwordFocusNode.value.dispose();
    _newPasswordFocusNode.value.dispose();
  }

  void isLogin() {
    if (!_session.isLogin) {
      Get.offAll(() => const LoginPage());
    }
    _loading.value = false;
  }

//   Future<List<dynamic>> refreshAsociations() async {
//     return asociationController.refreshAsociationsList();
//   }

  Future<UserAsocResponse?> login(BuildContext context, String username, int asociationId, String password) async {
    _loading.value = true;

    Future<UserAsocResponse?>? userAsocData;

    try {
      userAsocData = userRepository.login(username, asociationId, password);
      // logger.i(userAsocData.toString());
      _loading.value = false;
      return userAsocData;
    } catch (e) {
      EglHelper.toastMessage(e.toString());
      _loading.value = false;
      return null;
    }
  }

  Future<UserAsocResponse?> change(BuildContext context, String username, int asociationId, String password, String newPassword) async {
    _loading.value = true;

    Future<UserAsocResponse?>? userAsocData;

    try {
      userAsocData = userRepository.change(username, asociationId, password, newPassword, _session.userConnected.tokenUser);
      // logger.i(userAsocData.toString());
      _loading.value = false;
      return userAsocData;
    } catch (e) {
      EglHelper.toastMessage((e.toString()));
      _loading.value = false;
      return null;
    }
  }

  Future<void> updateUserConnected(UserConnected value) async {
    return _session.updateUserConnected(value);
  }

  setIdAsocAdmin(String profile, int asocId) {
    return ['superadmin', 'admin'].contains(profile) ? asocId : 0;
  }

  Future<List<dynamic>> refreshAsociationsList() async {
    return asociationController.refreshAsociationsList();
  }

  Future<void> exitSession() => _session.exitSession();
}
