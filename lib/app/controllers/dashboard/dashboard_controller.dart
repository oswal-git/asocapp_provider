import 'dart:async';

import 'package:asocapp/app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  final BuildContext _context;

  DashboardController(this._context) {
    isLogin();
  }

  final Logger logger = Logger();

  final _loading = true.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  Future<void> isLogin() async {
    final session = Provider.of<SessionService>(_context, listen: false);
    if (session.isLogin) {
      // Utils.eglLogger('e', 'ArticlesListView: init State isLogin');
      if (session.userConnected.recoverPasswordUser != 0) {
        Timer(const Duration(seconds: 3), () => Navigator.pushReplacementNamed(_context, '/change'));
      } else {
        _loading.value = false;
      }
    } else {
      Timer(const Duration(seconds: 3), () => Navigator.pushReplacementNamed(_context, '/login'));
    }
  }
}
