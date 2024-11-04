import 'package:asocapp/app/resources/resources.dart';
import 'package:asocapp/app/routes/app_router.dart';
import 'package:asocapp/app/services/services.dart';
import 'package:asocapp/app/translations/messages.dart';
import 'package:asocapp/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final sessionService = SessionService();
  await sessionService.init();
  await NotificationService.init();

  // Load translations before running the app
  await Messages().loadTranslations();

  runApp(
    MultiProvider(
      providers: [
        // Provide services using ChangeNotifierProvider
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => SessionService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.setListeners(context);
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionService>(context, listen: false);

    String language = 'es';
    String country = 'ES';

    if (session.isLogin) {
      language = session.userConnected.languageUser;
      country = EglHelper.getAppCountryLocale(language);
    }

    initializeDateFormatting(country == '' ? language : '${language}_$country', null);
    Intl.defaultLocale = country == '' ? language : '${language}_$country';
    final esES = numberFormatSymbols['es_ES'] as NumberSymbols;
    final caVL = numberFormatSymbols['ca'] as NumberSymbols;
    final enGB = numberFormatSymbols['en_GB'] as NumberSymbols;

    numberFormatSymbols['es_ES'] = esES.copyWith(currencySymbol: r'€');
    numberFormatSymbols['ca'] = caVL.copyWith(currencySymbol: r'€');
    numberFormatSymbols['en_GB'] = enGB.copyWith(currencySymbol: r'$');

    return MaterialApp.router(
      routerConfig: AppRouter.router,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
      // initialRoute: Routes.initialRoute, // Use the constant from Routes
      // routes: Routes.routes, // Use the routes map from Routes
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        Messages(), // Add your Messages delegate
      ],
      supportedLocales: const [
        Locale('en', 'GB'),
        Locale('es', 'ES'),
        Locale('ca'),
      ],
      locale: Locale(language, country),
      debugShowCheckedModeBanner: false,
      title: 'Asociaciones',
      theme: ThemeData(
        primarySwatch: AppColors.primaryMaterialColor,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: EglInputTheme().theme(),
        appBarTheme: const AppBarTheme(
          color: AppColors.whiteColor,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            color: AppColors.primaryTextTextColor,
          ),
          toolbarTextStyle: TextStyle(
            fontSize: 40,
            color: AppColors.primaryTextTextColor,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
        ),
      ),
      // home: const HomePage(),
    );
  }
}
