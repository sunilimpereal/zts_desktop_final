import 'dart:developer';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_bloc.dart';
import 'package:zts_counter_desktop/authentication/login/bloc/login_stream.dart';
import 'package:zts_counter_desktop/authentication/login/login_page.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

// database
import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/open.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zts_counter_desktop/constants/appstyles.dart';
import 'package:zts_counter_desktop/constants/config_.dart';
import 'package:zts_counter_desktop/constants/themes/theme.dart';
import 'package:zts_counter_desktop/dashboard/dashboard.dart';
import 'package:zts_counter_desktop/utils/shared_pref.dart';

import 'constants/app_fonts.dart';

AppStyles appStyles = AppStyles();
AppFonts appFonts = AppFonts();
// Config config = Config();
SharedPref sharedPref = SharedPref();
void main() async {
  //database
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  open.overrideFor(OperatingSystem.windows, _openOnWindows);

  WidgetsFlutterBinding.ensureInitialized();
  await sharedPref.init();
  runApp( Phoenix(child:AppWrapperProvider()));
  doWhenWindowReady(() {
    final win = appWindow;

    final initialSize = Size(1920, 1080);
    win.minSize = const Size(800, 600);
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = 'ZTS Counter';
    win.show();
  });
}

DynamicLibrary _openOnWindows() {
  // final script = File(Platform.script.toFilePath(windows: true).trimLeft());
  // final libraryNextToScript = File('sqlite3.dll');
  return DynamicLibrary.open('sqlite3.dll');
}

class AppWrapperProvider extends StatelessWidget {
  const AppWrapperProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckLoginProvider(
      child: LoginProvider(
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.logout();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  logout() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'ZTS Counter',
      initialRoute: '/login',
      onGenerateRoute: onGeneratedRoute,
    );
  }

  Route onGeneratedRoute(RouteSettings routeSettings) {
    if (routeSettings.name == '/login') {
      return MaterialPageRoute(builder: (_) => const LoginPage());
    }
    if (routeSettings.name == '/dashboard') {
      return MaterialPageRoute(builder: (_) => const DashBoardWrapper());
    }
    if (routeSettings.name == '/forgot_password') {
      return MaterialPageRoute(builder: (_) => const LoginPage());
    }
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }
}

class WinScaffold extends StatefulWidget {
  final Scaffold child;
  final Color? tabcolor;
  const WinScaffold({
    Key? key,
    required this.child,
    this.tabcolor,
  }) : super(key: key);

  @override
  _WinScaffoldState createState() => _WinScaffoldState();
}

class _WinScaffoldState extends State<WinScaffold> {
  @override
  Widget build(BuildContext context) {
    // log('dimen width  : ${MediaQuery.of(context).size.width}');
    // log('dimen height : ${MediaQuery.of(context).size.height}');
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            widget.child,
            Positioned(
              top: -5,
              child: SizedBox(
                //color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                child: Row(
                  children: [Expanded(child: MoveWindow()), WindowButtons()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: Colors.black,
      mouseOver: Theme.of(context).primaryColor,
      mouseDown: Theme.of(context).hoverColor.withOpacity(0.4),
      iconMouseOver: Theme.of(context).colorScheme.onPrimary,
      iconMouseDown: Theme.of(context).colorScheme.primary,
    );

    final closeButtonColors = WindowButtonColors(
      mouseOver: Color(0xFFD32F2F),
      mouseDown: Color(0xFFB71C1C),
      iconNormal: Colors.black,
      iconMouseOver: Colors.white,
    );

    return Row(
      children: [
        MinimizeWindowButton(
          colors: buttonColors,
          animate: true,
        ),
        MaximizeWindowButton(
          colors: buttonColors,
          animate: true,
        ),
        CloseWindowButton(
          colors: closeButtonColors,
          animate: true,
        ),
      ],
    );
  }
}

// buttonColors = WindowButtonColors(
//       iconNormal: Color(0xFF805306),
//       mouseOver: Color(0xFFF6A00C),
//       mouseDown: Color(0xFF805306),
//       iconMouseOver: Color(0xFF805306),
//       iconMouseDown: Color(0xFFFFD500));