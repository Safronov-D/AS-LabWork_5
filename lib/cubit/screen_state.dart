part of 'screen_cubit.dart';

abstract class ScreenState {
  final String? aError;
  final String? bError;
  final String? cError;
  final String? checkboxError;
  final String? result;
  final bool isProcessing;
  final String? dbError;

  const ScreenState({
    this.aError,
    this.bError,
    this.cError,
    this.checkboxError,
    this.result,
    this.isProcessing = false,
    this.dbError,
  });

  bool get hasError => aError != null || bError != null || cError != null || checkboxError != null;
}

class ScreenInitial extends ScreenState {
  const ScreenInitial();
}

class ScreenData extends ScreenState {
  const ScreenData({
    super.aError,
    super.bError,
    super.cError,
    super.checkboxError,
    super.result,
    super.isProcessing,
    super.dbError,
  });
}