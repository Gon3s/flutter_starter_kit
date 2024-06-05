// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthSessionState _$AuthSessionStateFromJson(Map<String, dynamic> json) {
  return _AuthSessionState.fromJson(json);
}

/// @nodoc
mixin _$AuthSessionState {
  AppUser get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthSessionStateCopyWith<AuthSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthSessionStateCopyWith<$Res> {
  factory $AuthSessionStateCopyWith(
          AuthSessionState value, $Res Function(AuthSessionState) then) =
      _$AuthSessionStateCopyWithImpl<$Res, AuthSessionState>;
  @useResult
  $Res call({AppUser user});

  $AppUserCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthSessionStateCopyWithImpl<$Res, $Val extends AuthSessionState>
    implements $AuthSessionStateCopyWith<$Res> {
  _$AuthSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AppUser,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AppUserCopyWith<$Res> get user {
    return $AppUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthSessionStateImplCopyWith<$Res>
    implements $AuthSessionStateCopyWith<$Res> {
  factory _$$AuthSessionStateImplCopyWith(_$AuthSessionStateImpl value,
          $Res Function(_$AuthSessionStateImpl) then) =
      __$$AuthSessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AppUser user});

  @override
  $AppUserCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthSessionStateImplCopyWithImpl<$Res>
    extends _$AuthSessionStateCopyWithImpl<$Res, _$AuthSessionStateImpl>
    implements _$$AuthSessionStateImplCopyWith<$Res> {
  __$$AuthSessionStateImplCopyWithImpl(_$AuthSessionStateImpl _value,
      $Res Function(_$AuthSessionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AuthSessionStateImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AppUser,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthSessionStateImpl implements _AuthSessionState {
  const _$AuthSessionStateImpl({required this.user});

  factory _$AuthSessionStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthSessionStateImplFromJson(json);

  @override
  final AppUser user;

  @override
  String toString() {
    return 'AuthSessionState(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSessionStateImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSessionStateImplCopyWith<_$AuthSessionStateImpl> get copyWith =>
      __$$AuthSessionStateImplCopyWithImpl<_$AuthSessionStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthSessionStateImplToJson(
      this,
    );
  }
}

abstract class _AuthSessionState implements AuthSessionState {
  const factory _AuthSessionState({required final AppUser user}) =
      _$AuthSessionStateImpl;

  factory _AuthSessionState.fromJson(Map<String, dynamic> json) =
      _$AuthSessionStateImpl.fromJson;

  @override
  AppUser get user;
  @override
  @JsonKey(ignore: true)
  _$$AuthSessionStateImplCopyWith<_$AuthSessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
