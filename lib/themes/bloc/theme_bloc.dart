import 'package:flutter_bloc/flutter_bloc.dart';

import '../themes.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(): super(ThemeState(themeData: AppThemes.appThemeData[AppTheme.lightTheme],),);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeEvent) {
      yield ThemeState(themeData: AppThemes.appThemeData[event.appTheme],);
    }
  }
}