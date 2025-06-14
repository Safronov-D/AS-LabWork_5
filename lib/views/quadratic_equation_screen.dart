import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/screen_cubit.dart';
import 'package:flutter_application_3/cubit/history_cubit.dart';
import 'package:flutter_application_3/models/history_screen.dart';
import '../db_provider.dart';

const String student = "Сафронов Дмитрий Иванович";

class QuadraticEquationScreen extends StatefulWidget {
  const QuadraticEquationScreen({super.key});

  @override
  State<QuadraticEquationScreen> createState() => _QuadraticEquationScreenState();
}

class _QuadraticEquationScreenState extends State<QuadraticEquationScreen> {
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();
  bool _isAgreed = false;

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => _openHistoryScreen(context),
        ),
        title: const Text('Лабораторная работа №4'),
      ),
      body: BlocConsumer<ScreenCubit, ScreenState>(
        listener: (context, state) {
          if (state.dbError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.dbError!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Выполнил: $student", style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                const Text(
                  "Квадратное уравнение",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _aController,
                  label: 'Коэффициент a',
                  errorText: state.aError,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _bController,
                  label: 'Коэффициент b',
                  errorText: state.bError,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _cController,
                  label: 'Коэффициент c',
                  errorText: state.cError,
                ),
                const SizedBox(height: 16),
                _buildConsentCheckbox(state),
                const SizedBox(height: 24),
                _buildCalculateButton(state),
                if (state.result != null) _buildResultSection(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String? errorText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildConsentCheckbox(ScreenState state) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _isAgreed,
              onChanged: (value) => setState(() => _isAgreed = value ?? false),
            ),
            const Text('Согласен на обработку данных'),
          ],
        ),
        if (state.checkboxError != null)
          Text(
            state.checkboxError!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
      ],
    );
  }

  Widget _buildCalculateButton(ScreenState state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: state.isProcessing
            ? null
            : () => context.read<ScreenCubit>().calculateRoots(
                  a: _aController.text,
                  b: _bController.text,
                  c: _cController.text,
                  isAgreed: _isAgreed,
                ),
        child: state.isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Вычислить корни', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildResultSection(ScreenState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Результат:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              state.result!,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _openHistoryScreen(BuildContext context) {
    // Получаем DBProvider из контекста
    final dbProvider = RepositoryProvider.of<DBProvider>(context);
  
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepositoryProvider.value(
          value: dbProvider,
          child: BlocProvider(
            create: (context) => HistoryCubit(
              dbProvider: RepositoryProvider.of<DBProvider>(context),
            )..loadHistory(),
            child: const HistoryScreen(),
          ),
        ),
      ),
    );
  }
}