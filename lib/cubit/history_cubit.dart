import 'package:flutter_bloc/flutter_bloc.dart';
import '../db_provider.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final DBProvider dbProvider;

  HistoryCubit({required this.dbProvider}) : super(HistoryInitial());

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    try {
      final calculations = await dbProvider.getAllCalculations();
      emit(HistoryLoaded(calculations: calculations));
    } catch (e) {
      emit(HistoryError(error: 'Ошибка загрузки: ${e.toString()}'));
    }
  }
}