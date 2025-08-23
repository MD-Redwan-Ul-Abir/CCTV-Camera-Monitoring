import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../infrastructure/utils/secure_storage_helper.dart';
import 'appConst.dart';
import 'languageModel.dart';

class LocalizationController extends GetxController implements GetxService {

  LocalizationController() {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode,
      AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    if (_locale.languageCode == 'sv') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    saveLanguage(_locale);
    update();
  }

  void loadCurrentLanguage() async {
    String languageCode = await SecureStorageHelper.getString(
        AppConstants.LANGUAGE_CODE, 
        defaultValue: AppConstants.languages[0].languageCode);
    String countryCode = await SecureStorageHelper.getString(
        AppConstants.COUNTRY_CODE, 
        defaultValue: AppConstants.languages[0].countryCode);
    
    _locale = Locale(languageCode, countryCode);
    _isLtr = _locale.languageCode != 'sv';
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    await SecureStorageHelper.setString(
        AppConstants.LANGUAGE_CODE, locale.languageCode);
    await SecureStorageHelper.setString(
        AppConstants.COUNTRY_CODE, locale.countryCode ?? "");
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = [];
      _languages = AppConstants.languages;
    } else {
      _selectedIndex = -1;
      _languages = [];
      AppConstants.languages.forEach((language) async {
        if (language.languageName.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(language);
        }
      });
    }
    update();
  }
}