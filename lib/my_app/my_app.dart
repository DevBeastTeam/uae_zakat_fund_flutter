import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:zakat_fund/data/network/client/dio_client.dart';
import 'package:zakat_fund/data/network/service/firebase_messaging_service.dart';
import 'package:zakat_fund/firebase_options.dart';
import 'package:zakat_fund/model/apple_info.dart';
import 'package:zakat_fund/model/cart.dart';
import 'package:zakat_fund/model/company_association_info.dart';
import 'package:zakat_fund/model/user.dart';
import 'package:zakat_fund/translation/translation.dart';
import 'package:zakat_fund/utils/routes/app_pages.dart';
import 'package:zakat_fund/utils/routes/app_routes.dart';
import 'package:zakat_fund/utils/utils.dart';
import 'package:zakat_fund/view_model/theme_view_model.dart';

VideoPlayerController? splashVideoController;

final GlobalKey<ScaffoldMessengerState> globalKey =
    GlobalKey<ScaffoldMessengerState>();
final themeViewModel = Get.find<ThemeViewModel>();
late Box userBox;
late Box appleBox;
late Box cartBox;
late Box rememberMeBox;
late Box mobileAppMessageBox;
late Box onboardingBox;
late Box fontSizeBox;
late Box colorsBox;
late Box uuidBox;
late Box showChangePasswordBox;
late Box appLangBox;
late Box biometricsBox;
late Box switchAccountBox;

Future<void> mainFunction() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessagingService();
  await Utils.getDeviceName();
  final directory = await getApplicationSupportDirectory();
  final hivePath = directory.path;
  await Hive.initFlutter(hivePath);

  Get.put(ThemeViewModel());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(AppleInfoAdapter());
  Hive.registerAdapter(CompanyAndAssociationInfoAdapter());
  Hive.registerAdapter(BiometricUserAdapter());

  await Future.wait([
    Hive.openBox<User>('userBox').then((box) => userBox = box),
    Hive.openBox<AppleInfo>('AppleInfo').then((box) => appleBox = box),
    Hive.openBox<Cart>('cartBox').then((box) => cartBox = box),
    Hive.openBox('rememberMeBox').then((box) => rememberMeBox = box),
    Hive.openBox('showChangePasswordBox')
        .then((box) => showChangePasswordBox = box),
    Hive.openBox<bool>('mobileAppMessageBox')
        .then((box) => mobileAppMessageBox = box),
    Hive.openBox<int>('fontSizeBox').then((box) => fontSizeBox = box),
    Hive.openBox<int>('colorsBox').then((box) => colorsBox = box),
    Hive.openBox<String>('uuidBox').then((box) => uuidBox = box),
    Hive.openBox<BiometricUser>('biometricsBox')
        .then((box) => biometricsBox = box),
    Hive.openBox<int>('appLanguageBox').then((box) => appLangBox = box),
    Hive.openBox<User>('switchAccountBox')
        .then((box) => switchAccountBox = box),
    Hive.openBox<bool>('onboardingBox').then((box) => onboardingBox = box),
  ]);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  DioClient();
  await _initSplashVideoController();
  runApp(const MyApp());
}

Future<void> _initSplashVideoController() async {
  splashVideoController =
      VideoPlayerController.asset('assets/mp4/ZakatPlatformSplash3a.mp4');
  //VideoPlayerController.asset('assets/mp4/ZakatSplash2a.mp4');
  await splashVideoController!.initialize();
  await splashVideoController!.setLooping(true);
  await splashVideoController!.setVolume(0);
}

class MyApp extends StatelessWidget {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Sahem Elzakwy',
          navigatorObservers: [observer],
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: globalKey,
          locale: TranslationService.locale,
          fallbackLocale: TranslationService.fallbackLocale,
          translations: TranslationService(),
          // initialRoute: appLangBox.isEmpty?AppRoutes.splashScreen:AppRoutes.mainScreen,
          initialRoute: AppRoutes.splashPage,
          getPages: AppPages.pages,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: themeViewModel.currentTheme,
          builder: (context, child) {
            return ValueListenableBuilder(
              valueListenable: colorsBox.listenable(),
              builder: (context, box, widget) {
                final isGrayscale = box.isNotEmpty && box.getAt(0) == 1;
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isGrayscale ? Colors.grey : Colors.transparent,
                    BlendMode.saturation,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: fontSizeBox.listenable(),
                    builder: (context, box, widget) {
                      final textScale =
                          (box.isNotEmpty && box.getAt(0) == 0) ? 1.1 : 1.0;
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.linear(textScale),
                        ),
                        child: child!,
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
