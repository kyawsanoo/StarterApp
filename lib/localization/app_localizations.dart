import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_localizations_delegate.dart';


class AppLocalizations {
  late final Locale? locale;

  AppLocalizations({required this.locale});

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = new Map<String, String>();

  Future<void> load() async {
    String jsonString = await rootBundle.loadString('./assets/locale/i18n_${locale!.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map<String, String>((key, value) {
      return MapEntry(key, value.toString());
    });
  }


  String translate(String key) => _localizedStrings[key] == null? "not found $key" : _localizedStrings[key]!;

  bool get isEnLocale => locale!.languageCode == 'en';
}
