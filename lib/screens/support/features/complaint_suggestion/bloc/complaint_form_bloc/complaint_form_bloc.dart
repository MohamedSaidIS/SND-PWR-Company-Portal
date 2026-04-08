import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:company_portal/utils/export_import.dart';
part 'complaint_form_event.dart';
part 'complaint_form_state.dart';

class ComplaintFormBloc extends Bloc<ComplaintFormEvent, ComplaintFormState>{
  final BaseComplaintRepository _repo;
  ComplaintFormBloc(this._repo) : super(const ComplaintFormState()) {
    on<CreateComplaintItemEvent>(_onSubmitForm);

    on<ChangeComplaintTypeEvent>((event, emit){
      emit(state.copyWith(selectedType: event.type));
    });

    on<ToggleEvent>((event, emit){
      emit(state.copyWith(isChecked: event.isChecked));
    });

    on<ChangeComplaintCategoryEvent>((event, emit){
      emit(state.copyWith(selectedCategory: event.category));
    });

    on<ChangeComplaintPriorityEvent>((event, emit){
      emit(state.copyWith(selectedPriority: event.priority));
    });
  }



  FutureOr<void> _onSubmitForm(CreateComplaintItemEvent event, Emitter<ComplaintFormState> emit) async{
    emit(state.copyWith(status: FormStatus.loading, errorMessage: null));
    try{
      final success = await _repo.createItem(ComplaintSuggestionItem(
          id: -1,
          title: event.title,
          description: event.description,
          priority: event.selectedPriority,
          status: "New",
          department: event.selectedDepartment,
          createdDate: null,
          modifiedDate: null,
          assignedToId: null,
          authorId: event.userId,
          issueLoggedById: event.userId,
          issueLoggedByName: event.userName,
      ), event.attachedFiles);

      if(success){
        emit(state.copyWith(status: FormStatus.success, selectedType: "Complaint", isChecked: true, selectedCategory: null, selectedPriority: 'Normal'));
      }else{
        emit(state.copyWith(status: FormStatus.error, errorMessage: "Failed to create complaint item"));
      }
    }catch(e){
      emit(state.copyWith(status: FormStatus.error, errorMessage: e.toString()));
    }

  }
}
