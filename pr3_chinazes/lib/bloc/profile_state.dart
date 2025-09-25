part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String? avatarPath;
  final String userName;
  
  ProfileLoaded({
    this.avatarPath,
    this.userName = 'Осипян Лусине Геннадьевна',
  });
}

class ProfileError extends ProfileState {
  final String message;
  
  ProfileError(this.message);
}