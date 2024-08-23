import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:oxoo/firebase_options.dart';
import 'package:oxoo/service/get_config_service.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'data/repository/config_repository.dart';
import 'models/configuration.dart';
import 'models/user_model.dart';
import 'service/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FlutterDownloader.initialize();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  // Hive not only supports primitives, lists and maps but also any Dart object you like. You need to generate a type adapter before you can store objects.
  Hive.registerAdapter(ConfigurationModelAdapter());
  Hive.registerAdapter(AppConfigAdapter());
  Hive.registerAdapter(AdsConfigAdapter());
  Hive.registerAdapter(PaymentConfigAdapter());
  Hive.registerAdapter(ApkVersionInfoAdapter());
  Hive.registerAdapter(GenreAdapter());
  Hive.registerAdapter(CountryAdapter());
  Hive.registerAdapter(TvCategoryAdapter());
  Hive.registerAdapter(AuthUserAdapter());
  await Hive.openBox<ConfigurationModel>('configBox');
  await Hive.openBox<AppConfig>('appConfigbox');
  await Hive.openBox<AdsConfig>('adsConfigbox');
  await Hive.openBox<PaymentConfig>('paymentConfigbox');
  await Hive.openBox<AuthUser>('oxooUser');
  await Hive.openBox('appModeBox');

  var height = WidgetsBinding.instance.window.physicalSize.height;
  var width = WidgetsBinding.instance.window.physicalSize.width;

  Hive.box("appModeBox").put("ratioScreen", height / width);
  ConfigurationModel? configurationModel;
  configurationModel =
      await ConfigurationRepositoryImpl().getConfigurationData();
  GetConfigService().updateGetConfig(configurationModel);
  setupLocator();
  runApp(MyApp());
}
