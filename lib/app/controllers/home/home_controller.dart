import 'dart:async';

import 'package:asocapp/app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeController extends ChangeNotifier {
  final BuildContext _context;

  HomeController(this._context){
    isLogin();
  }

  Future<void> isLogin() async {
    final session = Provider.of<SessionService>(_context, listen: false);
    if (session.isLogin) {
      Timer(const Duration(seconds: 3), () => Navigator.pushReplacementNamed(_context, '/dashboard') );
    } else {
      // Timer(const Duration(seconds: 3), () => Navigator.pushNamed(context, RouteName.register));
      Timer(const Duration(seconds: 3), () => Navigator.pushReplacementNamed(_context, '/login'));
    }
  }
}
