import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LocaleState extends Equatable{
  final Locale locale;
  LocaleState(this.locale);

  @override
  List<Object?> get props => [locale];
}

class SelectedLocale extends LocaleState {
  SelectedLocale(Locale locale) : super(locale);
}