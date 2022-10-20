import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/services/navigation_service.dart';
import 'package:chatify_app/widgets/custom_input_fields.dart';
import 'package:chatify_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
// import 'package:provider/single_child_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider _authP;
  late NavigationService _navigation;

  final _loginFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _authP = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.02),
        // height: deviceHeight * 0.98,
        // width: deviceWidth * 0.97,
        // decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  _pageTitle(),
                  SizedBox(
                    height: 15.0,
                  ),
                  _loginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      height: deviceHeight * 0.10,
      // decoration: BoxDecoration(color: Colors.white),
      child: Text(
        "Chatify",
        style: TextStyle(
            color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      // height: deviceHeight * 0.18,
      // decoration: BoxDecoration(color: Colors.white),
      child: Form(
        key: _loginFormKey,
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _email = _value;
                  });
                },
                textInputAction: TextInputAction.next,
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: "Email",
                obscureText: false),
            SizedBox(
              height: 20.0,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              textInputAction: TextInputAction.done,
              regEx: r".{2,}",
              hintText: "Password",
              obscureText: true,
            ),
            SizedBox(
              height: 30.0,
            ),
            _loginButton(),
            SizedBox(
              height: 15.0,
            ),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return RoundedButton(
      name: "Login",
      height: 50,
      width: 200,
      onPressed: () {
        if (_loginFormKey.currentState!.validate()) {
          _loginFormKey.currentState!.save();
          _authP.loginUsingEmailAndPassword(_email!, _password!);
          // print("Email :$_email,Password:$_password");
        }
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => _navigation.navigateToRoute('/register'),
      child: Container(
        child: Text(
          'Don\'t have an account?',
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
