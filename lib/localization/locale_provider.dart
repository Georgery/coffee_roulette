import 'package:flutter/material.dart';
import 'app_localizations.dart';

class LocaleProvider extends InheritedWidget {
  final AppLocale locale;
  final void Function(AppLocale) setLocale;

  const LocaleProvider({
    super.key,
    required this.locale,
    required this.setLocale,
    required super.child,
  });

  static LocaleProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleProvider>()!;
  }

  AppLocalizations get l10n => AppLocalizations(locale);

  @override
  bool updateShouldNotify(LocaleProvider oldWidget) {
    return locale != oldWidget.locale;
  }
}
