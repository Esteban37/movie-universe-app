import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Current [ThemeMode] for the app. Defaults to dark per the premium redesign.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);
