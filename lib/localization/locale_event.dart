import 'package:equatable/equatable.dart';

abstract class LocaleEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class LanguageLoadStarted extends LocaleEvent{

}

class ToggleLanguage extends LocaleEvent{
  String newLanguage;

  ToggleLanguage({required this.newLanguage});

  @override
  List<Object> get props => [newLanguage];
}

