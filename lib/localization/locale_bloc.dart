import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization.dart';
import 'locale_event.dart';

const String _storageKey = "StarterApp_";
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class LocaleBloc extends Bloc<LocaleEvent, LocaleState>{

  LocaleBloc() : super(SelectedLocale(new Locale('en')));

  @override
  Stream<LocaleState> mapEventToState(LocaleEvent event) async*{
    if(event is LanguageLoadStarted){
      if(await getPreferredLanguage() == ''){
        setPreferredLanguage('en');
        yield SelectedLocale(new Locale('en'));
      }else{
        yield SelectedLocale(new Locale(await getPreferredLanguage()));
      }

    }
    else if(event is ToggleLanguage){
      setPreferredLanguage(event.newLanguage);
      if(event.newLanguage == 'en') {
        yield SelectedLocale(new Locale('en'));
      }else{
        yield SelectedLocale(new Locale('my'));
      }
    }
  }

  getPreferredLanguage() async {
    return _getApplicationSavedInformation('language');
  }

  setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation('language', lang);
  }

  Future<String> _getApplicationSavedInformation(String name) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKey + name) ?? '';
  }

  Future<bool> _setApplicationSavedInformation(String name, String value) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKey + name, value);
  }


}