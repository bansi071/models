// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coaching_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      phoneNumber: json['phoneNumber'] as int,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };
