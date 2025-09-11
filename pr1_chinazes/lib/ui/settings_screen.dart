import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/settings_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (_nameController.text != state.userName) {
            _nameController.text = state.userName;
          }

          return Stack(
            children: [
              // chinazes по центру если включено
              if (state.showChinazes)
                Center(
                  child: Text(
                    'chinazes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

              // Основной контент
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    const Text(
                      'Практос чиназес',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Поле для имени
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        context.read<SettingsCubit>().updateUserName(value);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Переключатель chinazes
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Показывать кое-что',
                              style: TextStyle(fontSize: 16),
                            ),
                            Switch(
                              value: state.showChinazes,
                              onChanged: (value) {
                                context.read<SettingsCubit>().toggleChinazes(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Переключатель темы внизу
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Тёмная тема',
                              style: TextStyle(fontSize: 16),
                            ),
                            Switch(
                              value: state.isDarkTheme,
                              onChanged: (value) {
                                context.read<SettingsCubit>().toggleTheme(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}