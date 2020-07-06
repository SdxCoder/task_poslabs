import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';
import '../view_model/auth_view_model.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => AuthViewModel(),
        builder: (context, AuthViewModel model, child) =>
            Scaffold(body: _loginForm(model)));
  }

  Widget _loginForm(AuthViewModel model) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Sign-in with"),
          SizedBox(height: 8,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: Icon(FontAwesome.instagram), onPressed: () {}),
              SizedBox(width: 8),
              IconButton(
                  icon: Icon(FontAwesome.facebook_official),
                  onPressed: () async {
                    print("login");
                    await model.loginWithFacebook();
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
