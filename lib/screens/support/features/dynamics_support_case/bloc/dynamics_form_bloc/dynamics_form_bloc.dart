import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:company_portal/utils/export_import.dart';
part 'dynamics_form_event.dart';
part 'dynamics_form_state.dart';

class DynamicsFormBloc extends Bloc<DynamicsFormEvent, DynamicsFormState> {
  final BaseDynamicsRepository _repo;
  DynamicsFormBloc(this._repo) : super(DynamicsFormState()) {
    on<CreateDynamicsItemEvent>(_onSubmitForm);
    on<ChangeDynamicsPriorityEvent>((event, emit){
      emit(state.copyWith(selectedPriority: event.selectedPriority));
    });
    on<ChangeDynamicsPurposeEvent>((event, emit){
      emit(state.copyWith(selectedPurpose: event.selectedPurpose));
    });
  }


  FutureOr<void> _onSubmitForm(CreateDynamicsItemEvent event, Emitter<DynamicsFormState> emit) async{
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try{
      final success = await _repo.createItem(
          DynamicsItem(
            id: -1,
            title: event.title,
            description: event.description,
            priority: event.selectedPriority,
            status: "New",
            authorId: event.userId,
            createdDate: null,
            modifiedDate: null,
            dateReported: DatesHelper.parseTimeToSend(event.dateReported),
            area: event.selectedArea,
            purpose: event.selectedPurpose,
          ), event.attachedFiles,
      );
      if(success){
        emit(state.copyWith(isLoading: false, isSuccess: true, selectedPurpose: null, selectedPriority: 'Normal'));
      }else {
        emit(state.copyWith(isLoading: false, errorMessage: "Failed to create dynamics item"));
      }
    }catch(e){
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

}
