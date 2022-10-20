import 'dart:io';

import 'package:chatify_app/providers/authentication_provider.dart';
import 'package:chatify_app/services/cloud_storage_service.dart';
import 'package:chatify_app/services/database_service.dart';
import 'package:chatify_app/services/media_service.dart';

import 'package:chatify_app/services/navigation_service.dart';
import 'package:chatify_app/widgets/custom_input_fields.dart';
import 'package:chatify_app/widgets/rounded_button.dart';
import 'package:chatify_app/widgets/rounded_image.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late NavigationService _navigation;

  PlatformFile? _profileImage;

  late AuthenticationProvider _authP;
  late DatabaseService _db;
  late CloudStorageService _cloudStorageService;

  String? _email;
  String? _password;
  String? _name;

  final _registerFormKey = GlobalKey<FormState>();

  // PlatformFile? _profileImage;
  @override
  Widget build(BuildContext context) {
    _authP = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _navigation = GetIt.instance.get<NavigationService>();
    return _buildUi();
  }

  Widget _buildUi() {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(35.0),
          child: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _profileImageField(),
                SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _name = _value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  regEx: r".{6,}",
                  hintText: "Name",
                  obscureText: false,
                ),
                SizedBox(
                  height: 15.0,
                ),
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
                  obscureText: false,
                ),
                SizedBox(
                  height: 15.0,
                ),
                CustomTextFormField(
                  onSaved: (_value) {
                    setState(() {
                      _password = _value;
                    });
                  },
                  textInputAction: TextInputAction.done,
                  regEx: r".{6,}",
                  hintText: "Password",
                  obscureText: true,
                ),
                SizedBox(
                  height: 19.0,
                ),
                _registerButton(),
                SizedBox(
                  height: 10.0,
                ),
                _loginAccountLink(),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((_file) {
          setState(() {
            _profileImage = _file;
            // final path1 = _profileImage!.path;
            // file1 = File(path1!);
          });
        });
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(image: _profileImage!);
        } else {
          return RoundedImageNetwork(
              imagePath:
                  "https://static.vecteezy.com/system/resources/previews/002/318/271/original/user-profile-icon-free-vector.jpg",
              size: 150);
        }
      }(),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: "Register",
      height: 50,
      width: 200,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate()) {
          _registerFormKey.currentState!.save();

          String? _uid = await _authP.registerUserUsingEmailAndPassword(
              _email!, _password!);

          String? _imageURL = await _cloudStorageService.SaveUserImageToStorage(
              _uid!, _profileImage!);
          await _db.createUser(_uid, _email!, _name!, _imageURL!);
          await _authP.logout();
          await _authP.loginUsingEmailAndPassword(_email!, _password!);
        }
      },
    );
  }

  Widget _loginAccountLink() {
    return GestureDetector(
      onTap: () => _navigation.navigateToRoute('/login'),
      child: Container(
        // height: 20,
        child: Text(
          'Already have an account? Login',
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
