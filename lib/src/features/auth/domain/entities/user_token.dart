import 'package:equatable/equatable.dart';

class UserTokenEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const UserTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        expiresIn,
      ];
}
