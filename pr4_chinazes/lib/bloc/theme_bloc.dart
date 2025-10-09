import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/repositories/theme_repository.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository _themeRepository;

  ThemeBloc(this._themeRepository) : super(const ThemeState(isDark: false)) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeLoaded>(_onThemeLoaded);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    _themeRepository.saveTheme(event.isDark);
    emit(ThemeState(isDark: event.isDark));
  }

  void _onThemeLoaded(ThemeLoaded event, Emitter<ThemeState> emit) async {
    final isDark = await _themeRepository.getTheme();
    emit(ThemeState(isDark: isDark ?? false));
  }
}