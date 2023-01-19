import 'dart:convert';

import 'package:black_panda/input_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'panda_form_state.dart';

class PandaFormCubit extends Cubit<PandaFormState> {
  PandaFormCubit() : super(PandaFormInitial());

  void loadForm(String formString, String columnInput) {
    
    try {
      final columnsCount = int.parse(columnInput);
      if (formString.isEmpty) {
        emit(PandaFormError(message: 'Input text is empty!'));
        return;
      }
      List<InputModel> inputModels = [];
      LineSplitter.split(formString).forEach((line) {
        inputModels.add(InputModel.fromLine(line));
      });
      emit(PandaFormLoaded(inputModels: inputModels, columnsCount: columnsCount));
    } catch (e) {
      emit(PandaFormError(message: e.toString()));
    }
  }
}
