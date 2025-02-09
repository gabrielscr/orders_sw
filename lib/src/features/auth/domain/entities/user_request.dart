import 'package:equatable/equatable.dart';

class UserRequestEntity extends Equatable {
  final String email;
  final String password;

  const UserRequestEntity({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
