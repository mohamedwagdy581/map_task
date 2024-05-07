import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/modules/splash/splash_screen.dart';

import 'home_layout/home_layout.dart';
import 'shared/network/cubit/cubit.dart';
import 'shared/network/cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (BuildContext context)=> AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state)
        {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashView(),
          );
        },
      ),
    );
  }
}

