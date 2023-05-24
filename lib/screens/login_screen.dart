import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_screen_layout.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/register_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  bool _isLoading = false;

// method untuk menghancurkan sesuatu
  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  void signinUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().siginUser(
        _emailEditingController.text, _passwordEditingController.text);

    setState(() {
      _isLoading = false;
    });

    if (res != "success") {
      showSnackBar(
          Text(
            res,
            style: TextStyle(color: Colors.red),
          ),
          context);
      return;
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const ResponsiveScreenLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout()),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
              ),
              const SizedBox(height: 64),
              TextFieldInput(
                  textEditingController: _emailEditingController,
                  hintText: "Enter email",
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 24),
              TextFieldInput(
                  textEditingController: _passwordEditingController,
                  hintText: "Password",
                  isPass: true,
                  textInputType: TextInputType.text),
              const SizedBox(height: 24),
              InkWell(
                onTap: signinUser,
                child: Container(
                  child: const Text("Log in"),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: blueColor),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an accound? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ));
                    },
                    child: const Text(
                      "Sing up.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
