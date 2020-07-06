import 'package:client/core/shared_service/touch_id_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:client/core/core.dart';
import 'package:stacked/stacked.dart';

/*
 * @class   SplashViewModel
 * @extends BaseViewModel
 * @desc    This is a model class to handle application startup logic.
 *          If user already logged in and is not logged out, on starting the application
 *          is navigated to home screen and if user didn't logged in or is logged out,
 *          is navigated to login screen       
 */
class SplashViewModel extends BaseViewModel {
  // dependency injection
  final _authService = Modular.get<AuthService>();
  final _touchIdService = Modular.get<TouchIdService>();

/*
 * @desc    This function checks user log in status.
 *          if true navigates to home screen and if false navigates to login screen.
 *          and sets the view to splash screen untill login status request result
 *          completes.     
 */
  Future handleStartUpLogic() async {
    final bool loggedIn = await _authService.checkUserLoginStatus();

    if (loggedIn) {
      //  Modular.to.pushReplacementNamed(Routes.adminHome);
      await _touchIdService.handleTouchID();
    } else {
      Modular.to.pushReplacementNamed(Routes.login);
    }
  }
}
