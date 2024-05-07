
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/network/cubit/cubit.dart';
import '../shared/network/cubit/states.dart';


class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) { },
      builder: (BuildContext context, AppStates state)
      {
        var cubit = AppCubit.get(context);
        return Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.black38,
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            backgroundColor: Colors.black38,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
            },
            items: cubit.bottomNavItem,
          ),
        );
      },
    );
  }
}