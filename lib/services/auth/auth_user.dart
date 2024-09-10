import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);

  // Correct usage of User from Firebase
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
