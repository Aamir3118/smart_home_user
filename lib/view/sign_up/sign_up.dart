import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:smart_home/view/sign_up/sign_up_model.dart';
import 'package:smart_home/widgets/widgets.dart';
import 'dart:ui' as ui;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ImageProvider logo = const AssetImage("assets/images/icon.png");
  ImageProvider bgimg = const AssetImage("assets/images/bg-7.jpg");

  @override
  Widget build(BuildContext context) {
    return /*Scaffold(
      backgroundColor: bgColor,
      body: Consumer<SignUpModel>(
        builder: (context, model, _) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          // filterQuality: FilterQuality.high,
                          image: bgimg,
                          fit: BoxFit.cover,
                          opacity: 0.9)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        blendMode: ui.BlendMode.srcIn,
                        shaderCallback: (bounds) => ui.Gradient.linear(
                            Offset(4.0, 24.0),
                            Offset(24.0, 4.0),
                            [Colors.blue.shade900, Colors.blue.shade300]),
                        child: Icon(
                          MdiIcons.homeAutomation,
                          size: 55,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Wrap(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Smart",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                    letterSpacing: 2),
                              ),
                              Text(
                                "User",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade400,
                                    letterSpacing: 2),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Opacity(
                    opacity: model.isLoading ? 0.4 : 1,
                    child: AbsorbPointer(
                      absorbing: model.isLoading,
                      child: SafeArea(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(60),
                                  topRight: Radius.circular(60))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildForm(context, model),
                              _buildButtons(context, model),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                showLoading(model),
              ],
            ),
          ),
        ),
      ),
    );*/
        Scaffold(
      body: Consumer<SignUpModel>(
        builder: (context, model, _) => SingleChildScrollView(
            child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  // filterQuality: FilterQuality.high,
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1584280795027-321f4d68e77b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1374&q=80"),
                  fit: BoxFit.cover,
                )),
              ),
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(image: DecorationImage(image: logo)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120),
                child: Opacity(
                    opacity: model.isLoading ? 0.4 : 1,
                    child: AbsorbPointer(
                        absorbing: model.isLoading,
                        child: SafeArea(
                          // padding: const EdgeInsets.all(25.0),
                          child: Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    topRight: Radius.circular(60))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildForm(context, model),
                                _buildButtons(context, model),
                              ],
                            ),
                          ),
                        ))),
              ),
              showLoading(model),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildForm(BuildContext context, SignUpModel model) {
    return Form(
      key: model.formKey,
      autovalidateMode: model.autoValidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 19),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showText("Sign up"),
            ],
          ),
          const SizedBox(height: 30),
          _buildNameField(model),
          const SizedBox(height: 20),
          buildEmailField(model, "Email"),
          const SizedBox(height: 20),
          buildPasswordField(model, context, "Password"),
          const SizedBox(height: 20),
          buildButton(model, context, "Sign up"),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, SignUpModel model) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Already have an account ?",
              style: style(fontSize: 16),
            ),
            TextButton(
              onPressed: () => model.goBack(context),
              child: Text(
                "Sign in",
                style: style(fontSize: 16, color: Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  TextFormField _buildNameField(SignUpModel model) {
    return TextFormField(
      controller: model.nameController,
      focusNode: model.nameFocusNode,
      validator: validateName,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Color.fromRGBO(55, 59, 94, 1),
        ),
        hintText: "Full Name",
        enabledBorder: enabledBorder,
        focusedBorder: focusBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}
