import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:client/modules/mod-auth/views/login_view.dart';
import 'package:client/modules/spash/view/splash_screen.dart';

import 'core/core.dart';
import 'core/shared_service/location_service.dart';
import 'core/shared_service/notification_service.dart';
import 'main.dart';
import 'modules/home/view/home_view.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        // Bind services for DI
        Bind((i) => AuthService()),
        Bind((i) => PushNotificationsService()),
        Bind((i) => LocationService()),
      ];

  @override
  Widget get bootstrap => App();

  @override
  List<Router> get routers => [
        Router("/", child: (_, args) => SplashScreen()),
        Router("/login", child: (_, args) => LoginView()),
        Router("/adminHome", child: (_, args) => HomeView()),
      ];
}
