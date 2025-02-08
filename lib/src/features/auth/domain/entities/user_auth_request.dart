import 'package:equatable/equatable.dart';

class UserAuthRequestEntity extends Equatable {
  final String email;
  final String password;

  const UserAuthRequestEntity({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
