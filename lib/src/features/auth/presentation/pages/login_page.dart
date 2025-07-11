import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_app/src/core/extensions/context_extensions.dart';
import 'package:try_app/src/core/utils/validators.dart';
import 'package:try_app/src/features/auth/presentation/cubit/cubit/login_cubit.dart';
import 'package:try_app/src/features/site_listing/presentation/cubit/site_listing_cubit.dart';
import 'package:try_app/src/features/site_listing/presentation/pages/homepage1.dart';
import 'package:try_app/src/features/site_listing/presentation/pages/homepageWrapper.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
   
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) {
        return current is LoginSuccess || current is LoginFailure;
      },
      buildWhen: (previous, current) {
        return current is! LoginInitial || current is! LoginLoading;
      },
      listener: (context, state) {
        if (state is LoginSuccess) {
          print("login success state");
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => Homepagewrapper()));
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("Login Page")),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // FormField(builder: builder)
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(hintText: "Username"),
                        
                        validator: (value) => Validators.validateUsername(value),
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(hintText: "Password"),
                        validator: (value) => Validators.validatePassword(value),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: context.screenHeight * 0.08),

                ElevatedButton(
                  onPressed: () {
                
                  
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginCubit>().login(
                        usernameController.text.trim(),
                        passwordController.text.trim(),
                      );
                    }

                  },
                  child:
                      state is LoginLoading
                          ? CircularProgressIndicator(color: Colors.black)
                          : Text("Log In"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
