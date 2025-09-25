import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_storage_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ImageStorageService _storageService;
  
  ProfileBloc(this._storageService) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<PickImageEvent>(_onPickImage);
    on<DeleteImageEvent>(_onDeleteImage);
    on<SaveImageEvent>(_onSaveImage);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event, 
    Emitter<ProfileState> emit
  ) async {
    emit(ProfileLoading());
    try {
      final avatarPath = await _storageService.getAvatarPath();
      emit(ProfileLoaded(avatarPath: avatarPath));
    } catch (e) {
      emit(ProfileError('Ошибка загрузки профиля: $e'));
    }
  }

  Future<void> _onPickImage(
    PickImageEvent event, 
    Emitter<ProfileState> emit
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        add(SaveImageEvent(image.path));
      }
    } catch (e) {
      emit(ProfileError('Ошибка выбора изображения: $e'));
    }
  }

  Future<void> _onDeleteImage(
    DeleteImageEvent event, 
    Emitter<ProfileState> emit
  ) async {
    try {
      await _storageService.deleteAvatar();
      emit(ProfileLoaded(avatarPath: null));
    } catch (e) {
      emit(ProfileError('Ошибка удаления изображения: $e'));
    }
  }

  Future<void> _onSaveImage(
    SaveImageEvent event, 
    Emitter<ProfileState> emit
  ) async {
    try {
      final savedPath = await _storageService.saveAvatar(event.imagePath);
      emit(ProfileLoaded(avatarPath: savedPath));
    } catch (e) {
      emit(ProfileError('Ошибка сохранения изображения: $e'));
    }
  }
}