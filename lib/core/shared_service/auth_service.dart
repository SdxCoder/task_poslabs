import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:client/core/core.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

/*
  * @class AuthService
  * @desc  This class holds functions to handle authentication by facebook,
  *        instagram, and touch id(fingure print)
*/

class AuthService {
  final Dio _dio = Dio();
  final _facebookLogin = FacebookLogin();
  final _localAuth = LocalAuthentication();

  // current logged in user
  User _currentUser;
  User get currentUser => _currentUser;

  /* 
   * @desc    This function authenticates user with facebook login
   * @returns User - a user object if result is loggedin.
   *          String - an error string if result is not loggedin.
   */
  Future signInWithFaceBook() async {
    // set facebook login dialog behaviour that how it should be presented
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    try {
      /*
      * @desc   Logs-in user with requested read permissions and returns
      *         facebook login result which holds current login status - 
      *
      * @returns FacebookLoginResult - loggedIn, cancelledByUser, error 
      *
      * @throws  Exception from native side if permission list contains any 
      *          permissions that are not classified as read permissions. 
      */

      final result = await _facebookLogin.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          // Token to access facebook API'S
          final token = result.accessToken.token;

          return await _requestAccess(token);

          break;
        case FacebookLoginStatus.cancelledByUser:
          return "Authentication request cancelled";
          break;
        case FacebookLoginStatus.error:
          return result.errorMessage;
          break;
      }
    } catch (e) {
      return e.message;
    }
  }

  /*
   * @desc  populates a current user which can be used anywhere in the app.
   * @param user - an User Object representing currently logged in user. 
   */
  void _populateCurrentUser(User user) {
    _currentUser = user;
  }

  /*
   * @desc    Makes a get request to facebook api, populates and returns user object or error string
   * @param   token - a string token to access facebook api.
   * @returns User - a user object if response status code is 200.
   *          String - an error string if response status code
   *          is not 200
   */
  Future _requestAccess(String token) async {
    final response = await _dio.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');

    if (response.statusCode == 200) {
      // interceptor to log response of get request
      _dio.interceptors.add(LogInterceptor(responseBody: true));

      // json response
      final profile = response.data;

      // create user object with json response
      User user = User.fromJson(json.decode(profile));

      // populate current user with the user object
      _populateCurrentUser(user);

      return user;
    } else {
      return "Access Denied. ${response.statusCode.toString()}";
    }
  }

  /*
   * @desc logs out the current logged in user
   */
  Future checkUserLoginStatus() async {
    final isLoggedIn = await _facebookLogin.isLoggedIn;

    // if user is logged in, request facebook api and populate current user
    print(isLoggedIn);
    if (isLoggedIn) {
      FacebookAccessToken accessToken = await _facebookLogin.currentAccessToken;
      await _requestAccess(accessToken.token);
    }
    return isLoggedIn;
  }

  /*
   * @desc logs out the current logged in user
   */
  Future signOut() async {
    await _facebookLogin.logOut();
  }

  Future authenticateWithTouchID() async {
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
        return "";
      }

      print(e.message);
    }
  }
}
