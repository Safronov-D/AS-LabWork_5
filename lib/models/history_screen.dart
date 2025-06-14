import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/history_cubit.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История расчетов'),
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is HistoryError) {
            return Center(child: Text(state.error!));
          }
          
          if (state is HistoryLoaded && state.calculations.isEmpty) {
            return const Center(
              child: Text('Нет сохраненных расчетов', style: TextStyle(fontSize: 18)),
            );
          }
          
          return _buildHistoryList(state as HistoryLoaded);
        },
      ),
    );
  }

  Widget _buildHistoryList(HistoryLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.calculations.length,
      itemBuilder: (context, index) {
        final calc = state.calculations[index];
        final createdAt = DateTime.fromMillisecondsSinceEpoch(calc['created_at']);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Уравнение: ${calc['a']}x² + ${calc['b']}x + ${calc['c']} = 0',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Результат: ${calc['result']}'),
                const SizedBox(height: 8),
                Text(
                  'Дата: ${_formatDate(createdAt)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
           '${date.month.toString().padLeft(2, '0')}.'
           '${date.year} '
           '${date.hour.toString().padLeft(2, '0')}:'
           '${date.minute.toString().padLeft(2, '0')}';
  }
}