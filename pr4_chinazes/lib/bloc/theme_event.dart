part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final bool isDark;

  const ThemeChanged(this.isDark);

  @override
  List<Object> get props => [isDark];
}

class ThemeLoaded extends ThemeEvent {}