import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes.dart';

final key = 'dark_theme';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(): super(ThemeState(themeData: AppThemes.appThemeData[AppTheme.lightTheme],),){
    saveTheme(false);
  }

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if(event is GetDarkThemeBool){
      bool isDarkTheme = await getTheme() ;
      yield ThemeState(
          themeData: isDarkTheme? AppThemes.appThemeData[AppTheme.darkTheme]:AppThemes.appThemeData[AppTheme.lightTheme]);
    }
    if (event is ToggleTheme) {
      saveTheme(event.appTheme == AppTheme.darkTheme);
      yield ThemeState(themeData: AppThemes.appThemeData[event.appTheme],);
    }
  }


  Future<void> saveTheme(bool isDarkTheme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, isDarkTheme);
  }

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool? darkTheme = prefs.getBool(key) != null? true : false;
    return darkTheme;

  }

}