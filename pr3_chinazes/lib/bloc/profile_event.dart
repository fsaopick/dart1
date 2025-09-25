part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class PickImageEvent extends ProfileEvent {}

class DeleteImageEvent extends ProfileEvent {}

class SaveImageEvent extends ProfileEvent {
  final String imagePath;
  
  SaveImageEvent(this.imagePath);
}