import 'package:flutter_application_1/models/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences prefs;

  SettingsCubit(this.prefs)
      : super(SettingsState(
          isDarkTheme: false,
          userName: '',
          showChinazes: false,
        ));

  void loadSettings() {
    final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    final userName = prefs.getString('userName') ?? '';
    final showChinazes = prefs.getBool('showChinazes') ?? false;

    emit(SettingsState(
      isDarkTheme: isDarkTheme,
      userName: userName,
      showChinazes: showChinazes,
    ));
  }

  void toggleTheme(bool value) {
    prefs.setBool('isDarkTheme', value);
    emit(state.copyWith(isDarkTheme: value));
  }

  void updateUserName(String name) {
    prefs.setString('userName', name);
    emit(state.copyWith(userName: name));
  }

  void toggleChinazes(bool value) {
    prefs.setBool('showChinazes', value);
    emit(state.copyWith(showChinazes: value));
  }
}