import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/settings_cubit.dart';
import '../ui/settings_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: state.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: SettingsScreen(),
        );
      },
    );
  }
}