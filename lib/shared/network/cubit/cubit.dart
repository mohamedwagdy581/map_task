import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../modules/home/home_screen.dart';
import '../../../modules/map/map_screen.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  // Get context to Easily use in a different places in all Project
  static AppCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;

  List<Widget> screens = const [
    HomeScreen(),
    MapScreen(),
  ];

  List<String> titles = [
    'Home Screen',
    'Map Screen',
  ];

  // The List of BottomNavigationBar Items to move between Screens
  List<BottomNavigationBarItem> bottomNavItem = const
  [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
        ),
        label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.map_outlined,
      ),
      label: 'Map',
    ),
  ];

  // Function To Change BottomNavigationBar Items by emit The State
  void changeBottomNavBar (int index)
  {
    currentIndex = index;
    if (index == 0) {
      const HomeScreen();
    }
    if (index == 1) {
      const MapScreen();
    }
    emit(AppChangeBottomNavigationState());
  }




  // Function to Change Theme mode
  bool isDark = false;

  void changeAppModeTheme({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeThemeState());
    } else {
      isDark = !isDark;
      //CashHelper.setBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeThemeState());
      }
    }

}