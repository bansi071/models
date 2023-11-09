import 'package:json_annotation/json_annotation.dart';

part 'coaching_model.g.dart';

@JsonSerializable()
class User{
  String email;
   int phoneNumber;

  User({required this.phoneNumber, required this.email});

  User copyWith({
    String? email,
    int? phoneNumber,
  }) {
    return User(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }


  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}