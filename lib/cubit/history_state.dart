part of 'history_cubit.dart';

abstract class HistoryState {
  final List<Map<String, dynamic>> calculations;
  final String? error;

  const HistoryState({this.calculations = const [], this.error});
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded({required super.calculations});
}

class HistoryError extends HistoryState {
  const HistoryError({required super.error});
}