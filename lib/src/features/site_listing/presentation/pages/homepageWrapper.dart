import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_app/src/features/site_listing/presentation/cubit/site_listing_cubit.dart';
import 'package:try_app/src/features/site_listing/presentation/pages/homepage1.dart';
import 'package:try_app/src/injection/injection_container.dart';

class Homepagewrapper extends StatelessWidget {
  const Homepagewrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SiteListingCubit>(

      create: (BuildContext context) => sl<SiteListingCubit>(),
      child: Homepage1(),
      
    );
  }
}