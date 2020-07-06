import 'package:client/core/shared_service/touch_id_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:client/core/core.dart';
import 'package:stacked/stacked.dart';

/*
 * @class   AuthViewModel
 * @extends BaseViewModel
 * @desc    This is a model class to manage state and buisness logic of login view 
 */

class AuthViewModel extends BaseViewModel {
  // Dependency Injection
  final _authService = Modular.get<AuthService>();
   final _touchIdService = Modular.get<TouchIdService>();

  /*
   * @desc  Consumes auth service's sign in with facebook function
   *        and on result navigates to home view if result is user object
   *        or promts user if result is a string error.
   */
  Future loginWithFacebook() async {
    var result = await _authService.signInWithFaceBook();

    if (result is String) {
      await showDialogBox(title: "Error", description: result);
    } else {
      _touchIdService.handleTouchID();
    }
  }


 

}
