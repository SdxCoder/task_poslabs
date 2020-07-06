import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../core.dart';



/*
  * @class TouchIdService
  * @desc  This class holds functions to handle authentication by facebook,
  *        instagram, and touch id(fingure print)
*/
class TouchIdService {
  final _localAuth = LocalAuthentication();

  /*
  * @desc  Handles navigation on the bases of authentication success 
  *        status
  */
   Future handleTouchID() async {
    var result = await _authenticateWithTouchID();
    if (result is String) {
      await showDialogBox(title: "Failed", description: result);
    } else {
      if (result == true) {
        Modular.to.pushReplacementNamed(Routes.adminHome);
      }
      else{
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
      
    }
  }

  
/*
  * @desc  Configures the touch id for each platform.
  *        Returns authentication status or error string
  *
  * @returns  True, if authentication is successful otherwise false.
  *           string error, on exception.
*/
  Future _authenticateWithTouchID() async {
    const iosStrings = const IOSAuthMessages(
        cancelButton: 'cancel',
        goToSettingsButton: 'settings',
        goToSettingsDescription: 'Please set up your Touch ID.',
        lockOut: 'Please reenable your Touch ID');

    const androidStrings = const AndroidAuthMessages(
      cancelButton: 'cancel',
      goToSettingsButton: 'settings',
      goToSettingsDescription: 'Please set up your Touch ID.',
      fingerprintNotRecognized: "Unable to recognise fingureprint",
    );

    try {
      bool isAuthenticated = await _localAuth.authenticateWithBiometrics(
          stickyAuth: true,
          iOSAuthStrings: iosStrings,
          androidAuthStrings: androidStrings,
          sensitiveTransaction: true,
          localizedReason: 'Access app with your fingure print');

      return isAuthenticated;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        return "Fingure Print Not Available";
      }

      return e.message;
    }
  }
}
