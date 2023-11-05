import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apple_todo/cloud_functions/auth_firebase.dart';
import 'package:apple_todo/screens/todo/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late AuthFirebase auth;

  @override
  void initState() {
    auth = AuthFirebase();
    auth.getCurrentUser().then((value) {
      if (value != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }).catchError((e) => print(e));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _loginWithEmail,
      onRecoverPassword: _recoverPassword,
      onSignup: _signupWithEmail,
      passwordValidator: (value) {
        if (value != null) {
          if (value.length < 6) {
            return "Password must be 6 characters";
          }
        }
        return null;
      },
      loginProviders: [
        LoginProvider(
          callback: _loginWithGoogle,
          icon: FontAwesomeIcons.google,
          label: 'Google',
        )
      ],
      onSubmitAnimationCompleted: () {},
    );
  }

  Future<String?> _signupWithEmail(SignupData data) {
    return auth.signupWithEmail(data.name!, data.password!).then((value) {
      if (value != null) {
        final snackBar = SnackBar(
          content: const Text('Signup berhasil'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  Future<String?> _loginWithEmail(LoginData data) {
    return auth.loginWithEmail(data.name, data.password).then((value) {
      if (value != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        final snackBar = SnackBar(
          content: const Text('Login gagal, email atau password salah'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    });
  }

  Future<String?> _loginWithGoogle() {
    return auth.loginWithGoogle().then((value) {
      if (value != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        final snackBar = SnackBar(
          content: const Text('Login dengan akun Google gagal'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    });
  }

  Future<String>? _recoverPassword(String name) {
    return null;
  }
}
