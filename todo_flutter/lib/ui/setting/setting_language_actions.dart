import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/app_localizations.dart';
import 'package:todo_flutter/providers/language_provider.dart';

enum LanguagesActions { english, tunisian }

class SettingLanguageActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of(context);
    Locale _appCurrentLocale = languageProvider.appLocale;

    return PopupMenuButton<LanguagesActions>(
      icon: Icon(Icons.language),
      onSelected: (LanguagesActions result) {
        switch (result) {
          case LanguagesActions.english:
            languageProvider.updateLanguage("en");
            break;
          case LanguagesActions.tunisian:
            languageProvider.updateLanguage("tn");
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<LanguagesActions>>[
        PopupMenuItem<LanguagesActions>(
          value: LanguagesActions.english,
          enabled: _appCurrentLocale == Locale("en") ? false : true,
          child: Text(AppLocalizations.of(context)
              .translate("settingPopUpToggleEnglish")),
        ),
        PopupMenuItem<LanguagesActions>(
          value: LanguagesActions.tunisian,
          enabled: _appCurrentLocale == Locale("tn") ? false : true,
          child: Text(AppLocalizations.of(context)
              .translate("settingPopUpToggleTunisian")),
        ),
      ],
    );
  }
}
