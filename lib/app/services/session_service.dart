// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

import 'package:asocapp/app/services/storage_service.dart';
import 'package:asocapp/app/utils/utils.dart';

import '../models/models.dart';

class UserMessages {
  final String text;
  final String date;
  bool isRead;

  UserMessages({
    required this.text,
    required this.date,
    this.isRead = false,
  });
}

class SessionService extends ChangeNotifier {
  static final SessionService _instance = SessionService._internal();

  SessionService._internal();

  factory SessionService() {
    return _instance;
  }

  final StorageService storage = StorageService();

  String nextNotifications = '';

  bool _thereIsInternetconnection = false;
  bool get thereIsInternetconnection => _thereIsInternetconnection;
  set thereIsInternetconnection(bool value) {
    _thereIsInternetconnection = value;
    notifyListeners();
  }

  bool _isThereTask = false;
  bool get isThereTask => _isThereTask;
  set isThereTask(bool value) {
    _isThereTask = value;
    notifyListeners();
  }

  bool _hasData = false;
  bool get hasData => _hasData;
  set hasData(bool value) {
    _hasData = value;
    notifyListeners();
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;
  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  bool _isExpired = false;
  bool get isExpired => _isExpired;
  set isExpired(bool value) {
    _isExpired = value;
    notifyListeners();
  }

  final List<UserMessages> _listUserMessages = <UserMessages>[];
  List<UserMessages> get listUserMessages => _listUserMessages;
  void setListUserMessages(String value) {
    _listUserMessages.add(
      UserMessages(
        text: value,
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      ),
    );
    notifyListeners();
  }

  set checkUserMessage(int value) {
    _listUserMessages[value].isRead = !_listUserMessages[value].isRead;
    notifyListeners();
  }

  int get toReadmessages =>
      _listUserMessages.where((message) => message.isRead == false).length;

  bool _checkEdit = false;
  bool get checkEdit => _checkEdit;
  set checkEdit(bool value) {
    _checkEdit = value;
    notifyListeners();
  }

  // final _userConnected = Rx<UserConnected>(UserConnected.clear());
  UserConnected? _userConnected;
  UserConnected? get userConnected => _userConnected;

// Update the logged in data user in session and shared preferences
  Future<void> updateUserConnected(UserConnected value,
      {bool loadTask = false}) async {
    _userConnected = value;

    if (userConnected!.userNameUser != '') {
      // _hasData = true;
      // _isLogin = true;

      // Hora actual
      // Sumar 6 horas a la hora actual
      //  Obtener el valor en segundos para hacerlo comparable con PHP
      // int tokenExpUserInSeconds = (DateTime.now().add(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000);
      int tokenExpUserInSeconds =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000);

      _isExpired = (tokenExpUserInSeconds > userConnected!.tokenExpUser);

      await storage.writeObject(userConnectedKey, userConnected);

      await registerTask(userConnected!.tokenUser, loadTask);
      notifyListeners();
      return;
    }

    await exitSession();
    notifyListeners();
  }

  get getAuthToken => userConnected?.tokenUser;

  // authToken() async {
  //   await checkUserConnected();
  //   return userConnected?.tokenUser;
  // }

  // refreshGetAuthToken() async {
  //   bool isConnected = await checkUserConnected();
  //   return isConnected ? userConnected?.tokenUser : '';
  // }

  Future<SessionService> init() async {
    _listUserMessages.add(UserMessages(
      text: 'Registro de prueba',
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    ));

    Map<String, dynamic> userMap = storage.readObject(userConnectedKey);
    // bool isConnected = await checkUserConnected();

    if (userMap.isEmpty) {
      _userConnected ??= UserConnected.clear();
      // _userConnected!.value = UserConnected.clear();
    } else {
      _userConnected ??= UserConnected.fromJson(userMap);
      if (_userConnected!.userNameUser != '') {
        // _hasData = true;
        // _isLogin = true;
        await registerTask(_userConnected!.tokenUser, true);
      }
    }
    _checkEdit = false;
    notifyListeners();
    return this;
  }

  // Future<bool> checkUserConnected() async {
  //   Map<String, dynamic> userMap = storage.readObject(userConnectedKey);
  //   bool res = false;

  //   if (userMap.isEmpty) {
  //     _userConnected ??= Rx<UserConnected>(UserConnected.clear());
  //     // _userConnected!.value = UserConnected.clear();
  //     res = false;
  //   } else {
  //     _userConnected ??= Rx<UserConnected>(UserConnected.fromJson(userMap));
  //     // _userConnected!.value = UserConnected.fromJson(userMap);
  //     res = true;
  //   }
  //   return Future.value(res);
  // }

  // Initialize the logged in data user in session
  void userClear() {
    // _hasData = false;
    // _isLogin = false;
    _checkEdit = false;
    // _isExpired = false;
    _userConnected = UserConnected.clear();
    notifyListeners();
  }

  Future<void> registerTask(String token, bool loadTask) async {
    if (_isLogin) {
      EglHelper.eglLogger(
          'i', 'Session -> loadDataUser: isLogin? ${_isLogin.toString()}');
      //   if (!isThereTask) {
      if (loadTask) {
        EglHelper.eglLogger('i',
            'Session -> loadDataUser: isThereTask? ${_isThereTask.toString()}');
        // Workmanager().cancelAll();
        _isThereTask = false;
        if (userConnected?.timeNotificationsUser == 99) {
          Workmanager().cancelAll();
        } else {
          final Map<String, dynamic> inputDataMap = <String, dynamic>{
            "token": token
          };
          // final int frequency = userConnected.timeNotificationsUser * 60;  // minutes
          const int frequency = 5;
          // final int initialDelay = calcInitialDelay(userConnected.timeNotificationsUser);  // seconds
          const int initialDelay = 60;

          EglHelper.eglLogger('i', 'Session -> loadDataUser: token $token');
          EglHelper.eglLogger('i',
              'Session -> loadDataUser: inputDataMap ${inputDataMap['token']}');
          EglHelper.eglLogger('i',
              'Session -> loadDataUser: totokenUserken ${userConnected?.tokenUser}');
          EglHelper.eglLogger('i',
              'Session -> loadDataUser: timeNotificationsUser? ${userConnected?.timeNotificationsUser.toString()}');
          _isThereTask = true;
          EglHelper.eglLogger('i',
              'Session -> loadDataUser: Workmanager().registerPeriodicTask');

          Workmanager().registerPeriodicTask(
            "5",
            simplePeriodicTask,
            existingWorkPolicy: ExistingWorkPolicy.replace,
            // inputData: <String, dynamic>{"token": token},
            inputData: inputDataMap,
            frequency: const Duration(
                minutes: frequency), //when should it check the link
            initialDelay: const Duration(
                seconds:
                    initialDelay), //duration before showing the notification
            constraints: Constraints(
              networkType: NetworkType.connected,
            ),
          );

          EglHelper.eglLogger('i', 'registerTask: Next date query:',
              object: EglHelper.displayAAAAMMDDHora(
                  date: EglHelper.addDurationToDate(const Duration(
                seconds: initialDelay,
              ))));
        }
        notifyListeners();
      }
    }
  }

  int calcInitialDelay(int eachHours) {
    DateTime now = DateTime.now();
    String targetTime = "";

    switch (eachHours) {
      case 1:
        targetTime = "${now.hour + 1}:00:00";
        break;
      case 6:
        if (now.hour < 10) {
          targetTime = "10:00:00";
        } else if (now.hour < 16) {
          targetTime = "16:00:00";
        } else if (now.hour < 22) {
          targetTime = "22:00:00";
        } else {
          targetTime = "10:00:00";
        }
        break;
      case 12:
        if (now.hour < 10) {
          targetTime = "10:00:00";
        } else if (now.hour < 22) {
          targetTime = "22:00:00";
        } else {
          targetTime = "10:00:00";
        }
        break;
      case 24:
        targetTime = "10:00:00";
        break;
      default:
        targetTime = "10:00:00";
    }

    DateTime targetDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(targetTime.split(":")[0]), // Obtener la hora de targetTime
      int.parse(targetTime.split(":")[1]), // Obtener los minutos de targetTime
      int.parse(targetTime.split(":")[2]), // Obtener los segundos de targetTime
    );

    int secondsDifference = targetDateTime.difference(now).inSeconds;

    EglHelper.eglLogger('i',
        'Session: calcInitialDelay -> secondsDifference: $secondsDifference');
    // return 4;
    return secondsDifference;
  }

  // Initialize the logged in data user in session and shared preferences
  Future<void> exitSession() async {
    userClear();
    Workmanager().cancelAll();
    await storage.remove(userConnectedKey);
    var locale = const Locale('es', 'ES');
    Get.updateLocale(locale);
    Intl.defaultLocale = 'es_ES';
    notifyListeners();
  }

  int setIdAsocAdmin(String profile, int asocId) {
    return ['superadmin', 'admin'].contains(profile) ? asocId : 0;
  }
}
