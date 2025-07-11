import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_app/src/features/auth/presentation/cubit/cubit/login_cubit.dart';
import 'package:try_app/src/features/auth/presentation/pages/login_page.dart';
import 'package:try_app/src/injection/injection_container.dart';

class LoginPageWrapper extends StatelessWidget {
  const LoginPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create:(_)=>sl<LoginCubit>() ,
    child: LoginPage(),
    );
  }
}