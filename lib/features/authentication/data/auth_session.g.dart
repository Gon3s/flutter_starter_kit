// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSessionStateImpl _$$AuthSessionStateImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthSessionStateImpl(
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthSessionStateImplToJson(
        _$AuthSessionStateImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authSessionHash() => r'2aeeb6918eba4240c9e02975baa78338797a5754';

/// This is the provider for the AuthSession class.
///
/// Copied from [AuthSession].
@ProviderFor(AuthSession)
final authSessionProvider =
    NotifierProvider<AuthSession, AuthSessionState?>.internal(
  AuthSession.new,
  name: r'authSessionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthSession = Notifier<AuthSessionState?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
