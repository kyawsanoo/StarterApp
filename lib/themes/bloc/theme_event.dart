import 'package:equatable/equatable.dart';

import '../app_themes.dart';

class ThemeEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class ToggleTheme extends ThemeEvent{
  final AppTheme appTheme;

  ToggleTheme(this.appTheme);

  @override
  List<Object?> get props => [appTheme];
}

class GetDarkThemeBool extends ThemeEvent{

  @override
  List<Object?> get props => [];
}
