import 'dart:async';

import 'package:asocapp/app/apirest/api_models/api_models.dart';
import 'package:asocapp/app/models/models.dart';
import 'package:asocapp/app/repositorys/user_repository.dart';
import 'package:asocapp/app/services/session_service.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:asocapp/app/views/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserItemController extends ChangeNotifier {
  final SessionService _session;
  final UserRepository _userRepository;

  UserItemController(this._session, this._userRepository);

  GlobalKey<FormState> formKey = GlobalKey<FormState>(debugLabel: '_profileController');

  final _profileUserFocusNode = FocusNode().obs;
  FocusNode get profileUserFocusNode => _profileUserFocusNode.value;

  final _statusUserFocusNode = FocusNode().obs;
  FocusNode get statusUserFocusNode => _statusUserFocusNode.value;

  Rx<UserItem> userItem = Rx<UserItem>(UserItem.clear());
  Rx<UserItem> userItemIni = Rx<UserItem>(UserItem.clear());
  Rx<UserItem> userItemLast = Rx<UserItem>(UserItem.clear());

  final loading = false.obs;

  final _isFormValid = false.obs;
  bool get isFormValid => _isFormValid.value;

  bool checkIsFormValid() {
    // Helper.eglLogger('i','checkIsFormValid: ${_imageAvatar.value!.path}');
    // Helper.eglLogger('i','checkIsFormValid: ${_imageAvatar.value!.path != ''}');
    return _isFormValid.value = ((formKey.currentState?.validate() ?? false) &&
        (userItem.value.profileUser != userItemLast.value.profileUser || userItem.value.statusUser != userItemLast.value.statusUser));
  }

  void onClose() {
    _profileUserFocusNode.value.dispose();
    _statusUserFocusNode.value.dispose();
  }

  bool isLogin(UserItem user) {
    EglHelper.eglLogger('i', 'isLogin: ');

    try {
      if (!_session.isLogin) {
        // Timer(const Duration(seconds: 3), () => Navigator.pushNamed(context, RouteName.register));
        Get.to(() => DashboardPage);
        return false;
      }
      userItem.value = user.clone();
      userItemIni.value = user.clone();
      userItemLast.value = user.clone();
      EglHelper.eglLogger('i', 'isLogin: ${userItemIni.value.idAsociationUser}');
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<HttpResult<UserAsocResponse>?> updateProfile(
    int idUser,
    String userName,
    int asociationId,
    int intervalNotifications,
    String languageUser,
    String dateUpdatedUser,
  ) async {
    loading.value = true;

    try {
      final Future<HttpResult<UserAsocResponse>?> response = _userRepository.updateProfile(
          idUser, userName, asociationId, intervalNotifications, languageUser, dateUpdatedUser, _session.userConnected.tokenUser);
      loading.value = false;
      return response;
    } catch (e) {
      EglHelper.toastMessage(e.toString());
      loading.value = false;
      return null;
    }
  }

  Future<HttpResult<UserAsocResponse>?> updateProfileStatus(int idUser, String profileUser, String statusUser, String dateUpdatedUser) async {
    loading.value = true;

    try {
      final Future<HttpResult<UserAsocResponse>?> response =
          _userRepository.updateProfileStatus(idUser, profileUser, statusUser, dateUpdatedUser, _session.userConnected.tokenUser);
      loading.value = false;
      return response;
    } catch (e) {
      EglHelper.toastMessage(e.toString());
      loading.value = false;
      return null;
    }
  }

  Future<void> updateUserConnected(UserConnected value, bool loadTask) async {
    return _session.updateUserConnected(value, loadTask: loadTask);
  }

  int setIdAsocAdmin(String profile, int asocId) {
    return _session.setIdAsocAdmin(profile, asocId);
  }
}
