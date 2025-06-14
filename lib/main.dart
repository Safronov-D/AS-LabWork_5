import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'db_provider.dart';
import 'cubit/screen_cubit.dart';
import 'views/quadratic_equation_screen.dart';

void main() {
  // Инициализация для десктопных платформ
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    ffi.sqfliteFfiInit();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Квадратное уравнение',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 23, 87, 206),
        ),
      ),
      home: RepositoryProvider(
        create: (context) => DBProvider(),
        child: BlocProvider(
          create: (context) => ScreenCubit(
            dbProvider: RepositoryProvider.of<DBProvider>(context),
          ),
          child: const QuadraticEquationScreen(),
        ),
      ),
    );
  }
}