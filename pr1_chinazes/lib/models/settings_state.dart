class SettingsState {
  final bool isDarkTheme;
  final String userName;
  final bool showChinazes;

  SettingsState({
    required this.isDarkTheme,
    required this.userName,
    required this.showChinazes,
  });

  SettingsState copyWith({
    bool? isDarkTheme,
    String? userName,
    bool? showChinazes,
  }) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      userName: userName ?? this.userName,
      showChinazes: showChinazes ?? this.showChinazes,
    );
  }
}