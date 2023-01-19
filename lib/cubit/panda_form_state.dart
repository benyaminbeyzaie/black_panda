part of 'panda_form_cubit.dart';

abstract class PandaFormState {}

class PandaFormInitial extends PandaFormState {}

class PandaFormLoaded extends PandaFormState {
  final List<InputModel> inputModels;
  final int columnsCount;

  PandaFormLoaded({
    required this.inputModels,
    required this.columnsCount,
  });
}

class PandaFormLoading extends PandaFormState {}

class PandaFormError extends PandaFormState {
  final String message;

  PandaFormError({required this.message});
}
