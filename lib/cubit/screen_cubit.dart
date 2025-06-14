import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../db_provider.dart';

part 'screen_state.dart';

class ScreenCubit extends Cubit<ScreenState> {
  final DBProvider dbProvider;

  ScreenCubit({required this.dbProvider}) : super(const ScreenInitial());

  Future<void> calculateRoots({
    required String a,
    required String b,
    required String c,
    required bool isAgreed,
  }) async {
    // Сброс ошибок
    emit(const ScreenData());
    
    // Валидация
    final aError = _validateCoefficient(a, 'A');
    final bError = _validateCoefficient(b, 'B');
    final cError = _validateCoefficient(c, 'C');
    final checkboxError = isAgreed ? null : 'Необходимо согласие';

    if (aError != null || bError != null || cError != null || checkboxError != null) {
      emit(ScreenData(
        aError: aError,
        bError: bError,
        cError: cError,
        checkboxError: checkboxError,
      ));
      return;
    }

    emit(ScreenData(isProcessing: true));

    try {
      final double aVal = double.parse(a);
      final double bVal = double.parse(b);
      final double cVal = double.parse(c);

      final result = _solveQuadraticEquation(aVal, bVal, cVal);
      
      // Сохраняем в базу данных
      await dbProvider.insertCalculation({
        'a': aVal,
        'b': bVal,
        'c': cVal,
        'result': result,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
      
      emit(ScreenData(result: result));
    } catch (e) {
      emit(ScreenData(
        result: 'Ошибка вычисления: ${e.toString()}',
        dbError: 'Ошибка сохранения',
      ));
    }
  }

  String? _validateCoefficient(String value, String coefficientName) {
    if (value.isEmpty) {
      return 'Введите коэффициент $coefficientName';
    }
    final parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return 'Некорректное число';
    }
    return null;
  }

  String _solveQuadraticEquation(double a, double b, double c) {
    if (a == 0) {
      if (b == 0) {
        return c == 0 ? 'Бесконечное множество решений' : 'Нет решений';
      }
      final x = -c / b;
      return 'Линейное уравнение: x = ${x.toStringAsFixed(2)}';
    }

    final discriminant = b * b - 4 * a * c;

    if (discriminant > 0) {
      final x1 = (-b + sqrt(discriminant)) / (2 * a);
      final x2 = (-b - sqrt(discriminant)) / (2 * a);
      return 'Два действительных корня:\nx₁ = ${x1.toStringAsFixed(2)}\nx₂ = ${x2.toStringAsFixed(2)}';
    } else if (discriminant == 0) {
      final x = -b / (2 * a);
      return 'Один действительный корень:\nx = ${x.toStringAsFixed(2)}';
    } else {
      final realPart = -b / (2 * a);
      final imaginaryPart = sqrt(-discriminant) / (2 * a);
      return 'Два комплексных корня:\nx₁ = ${realPart.toStringAsFixed(2)} + ${imaginaryPart.toStringAsFixed(2)}i\n'
             'x₂ = ${realPart.toStringAsFixed(2)} - ${imaginaryPart.toStringAsFixed(2)}i';
    }
  }
}