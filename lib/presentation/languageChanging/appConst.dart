import 'package:get/get.dart';
import 'appString.dart';
import 'languageModel.dart';

class AppConstants {
  AppConstants._();

  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';
  static List<LanguageModel> languages = [
    LanguageModel(
        languageName: AppStrings.english,
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        languageName: AppStrings.danish,
        countryCode: 'DK',
        languageCode: 'da'),
    LanguageModel(
        languageName: AppStrings.swedish, countryCode: 'SE', languageCode: 'sv'),
  ];
}