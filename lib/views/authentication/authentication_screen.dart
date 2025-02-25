import 'package:flutter_level_01/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // checkLogin().then((value) =>
    //     value ? Navigator.pushReplacementNamed(context, Routes.home) : null);

    return Scaffold(
        body: SafeArea(
      child: LoginScreen(),
    ));
  }

  // Future<bool> checkLogin() async {
  //   final pref = await SharedPreferences.getInstance();
  //   bool isLogin = pref.getBool('isLogin') ?? false;
  //   return isLogin;
  // }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController
  final _usernametxt = TextEditingController();
  final _passwordtxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: upperSection(context),
          ),
          lowerSection(context),
        ],
      ),
    );
  }

  Widget upperSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NET',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.local_police,
              color: Colors.grey.shade600,
              size: 44,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 20,
            children: [
              inputField(
                controller: _usernametxt,
                placeholder: 'username',
                isSuffixIcon: false,
              ),
              inputField(
                controller: _passwordtxt,
                placeholder: 'password',
              ),
              loginButton(callback: () async {
                // read data from shared preferences
                // final pref = await SharedPreferences.getInstance();

                // String username = pref.getString('username') ?? "";
                // String password = pref.getString('password') ?? "";

                // Check if login credentials are correct
                if (_usernametxt.text == "" && _passwordtxt.text == "" ||
                    _usernametxt.text == 'root' &&
                        _passwordtxt.text == 'root') {
                  // Store login status in shared preferences
                  // pref.setBool('isLogin', true);

                  // Navigate to Home Screen
                  Navigator.pushReplacementNamed(context, Routes.home);
                } else {
                  // Show error message
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        spacing: 8,
                        children: [
                          Text('Invalid login'),
                          Icon(Icons.error, size: 30),
                        ],
                      ),
                      content: Text('Invalid username or password'),
                      actions: [
                        loginButton(
                          callback: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                }
              })
            ],
          ),
        ),
      ],
    );
  }

  // Widget loginButton({required Function() callback}) {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: OutlinedButton(
  //       onPressed: callback,
  //       style: OutlinedButton.styleFrom(
  //           backgroundColor: Colors.black,
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
  //       child: Text('Login',
  //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  //     ),
  //   );
  // }

  Widget lowerSection(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text(
            "Don't have account?",
            style: TextStyle(fontSize: 18),
          ),
          Bounceable(
            onTap: () {},
            // onTap: () => Navigator.pushNamed(context, Routes.register),
            child: Text(
              'Register',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // text field controllers
  final _lastnameTxt = TextEditingController();
  final _firstnameTxt = TextEditingController();
  final _usernameTxt = TextEditingController();
  final _passwordTxt = TextEditingController();
  final _confirmPasswordTxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Register'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 35,
              children: [
                profileSection(),
                Column(
                  spacing: 20,
                  children: [
                    inputField(
                        controller: _lastnameTxt, placeholder: 'Last name'),
                    inputField(
                        controller: _firstnameTxt, placeholder: 'First name'),
                    inputField(
                        controller: _usernameTxt, placeholder: 'Username'),
                    inputField(
                        controller: _passwordTxt,
                        placeholder: 'Password',
                        isSuffixIcon: true),
                    inputField(
                        controller: _confirmPasswordTxt,
                        placeholder: 'Confirm password',
                        isSuffixIcon: true),
                  ],
                ),
                loginButton(
                  content: 'Register',
                  callback: () {
                    setState(() {
                      writeToSharedPreferences(context).then(
                        (value) => {
                          if (value)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Registration successful!')),
                              ),
                              Navigator.pushReplacementNamed(
                                  context, Routes.home)
                            }
                        },
                      );
                    });
                  },
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> writeToSharedPreferences(BuildContext context) async {
    if (_firstnameTxt.text.isNotEmpty &&
        _lastnameTxt.text.isNotEmpty &&
        _usernameTxt.text.isNotEmpty &&
        _passwordTxt.text.isNotEmpty &&
        _confirmPasswordTxt.text.isNotEmpty) {
      // Write registration data to Shared Preferences
      // final pref = await SharedPreferences.getInstance();

      // pref.setString('username', _usernameTxt.text);
      // pref.setString('password', _passwordTxt.text);
      // pref.setString('firstName', _firstnameTxt.text);
      // pref.setString('lastName', _lastnameTxt.text);
      // pref.setBool('isLogin', true);
      return true;
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              spacing: 5,
              children: [
                Text('Missing fields'),
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ],
            ),
            content: Text('Please fill out all the fields.',
                style: TextStyle(fontSize: 16)),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        },
      );
      return false;
    }
  }

  Future<void> deleteLoginData() async {
    // final pref = await SharedPreferences.getInstance();
    // await pref.remove('isLogin');
    // await pref.remove('username');
    // await pref.remove('password');
    // await pref.remove('firstName');
    // await pref.remove('lastName');
  }

  Widget profileSection() => Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
            child: Icon(
              Icons.person,
              size: 55,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Icon(Icons.camera_alt),
          ),
        ],
      );
}

Widget inputField(
    {String? placeholder,
    bool isSuffixIcon = false,
    Widget? suffixWidget,
    required TextEditingController controller}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      suffixIcon: isSuffixIcon
          ? suffixWidget ?? Icon(Icons.remove_red_eye_outlined)
          : null,
      labelText: placeholder ?? "placeholder",
      border: OutlineInputBorder(),
    ),
  );
}

Widget loginButton(
    {Widget? child,
    required Function() callback,
    ButtonStyle? style,
    String? content}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
        onPressed: callback,
        style: style ??
            ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
        child: child ??
            Text(
              content ?? 'Login',
              style: TextStyle(color: Colors.white),
            )),
  );
}
