import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:brainfit/classes/singleton/speech_to_text.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/provider/home_screen_povider.dart';
import 'package:brainfit/services/database_helper.dart';

import 'package:brainfit/services/local_storage.dart';
import 'package:brainfit/services/native_service.dart';
import 'package:brainfit/services/rest_api_service.dart';
import 'package:brainfit/services/secure_storage.dart';
import 'package:brainfit/services/timezone_service.dart';
import 'package:brainfit/shared/bloc/auth/auth_bloc.dart';

import 'package:brainfit/shared/bloc/profile/profile_bloc.dart';
import 'package:brainfit/shared/models/user.model.dart';
import 'package:brainfit/shared/repository/auth_repo.dart';
import 'package:brainfit/config/routes/routes.dart' as routes;
import 'package:brainfit/shared/repository/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp();
  var db = new DatabaseHelper();

  bool isLoggedIn = await db.isLoggedIn();

  if (isLoggedIn) {
    List<Map<String, dynamic>> loggedInUser = await db.getLoggedInUser();
    print(loggedInUser);
    User.saveUserParamsFromDatabase(loggedInUser.first);
  }

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  Application.localStorageService = await LocalStorageService.getInstance();
  Application.secureStorageService = SecureStorageService.getInstance();
  Application.nativeAPIService = NativeAPIService.getInstance();
  Application.timezoneService = TimezoneService.getInstance();
  Application.restService = RestAPIService.getInstance();
  Application.routeSetting = routes.AppRouteSetting.getInstance();
  runApp(App(isUserLoggedIn: isLoggedIn));
}

class App extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get globalContext => navigatorKey.currentState!.context;

  final bool isUserLoggedIn;
  const App({Key? key, required this.isUserLoggedIn}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            repository: ProfileRepositoryImpl(),
          )..add(const GetUserProfile()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(repository: authRepositoryImpl),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ],
        child: MaterialApp(
          title: 'Woofy App',
          navigatorKey: App.navigatorKey,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouteSetting.generateRoute,
          debugShowCheckedModeBanner: false,
          theme: lightThemeData['themeData'] as ThemeData,
        ),
      ),
    );
  }
}
