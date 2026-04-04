import 'dart:async';
import 'package:company_portal/core/models/remote/complaint_suggestion_item.dart';
import 'package:company_portal/screens/support/complaint_suggestion/repo/complaint_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/local/attached_file_info.dart';

part 'complaint_form_event.dart';
part 'complaint_form_state.dart';

class ComplaintFormBloc extends Bloc<ComplaintFormEvent, ComplaintFormState>{
  final BaseComplaintRepository _repo;
  ComplaintFormBloc(this._repo) : super(const ComplaintFormState()) {
    on<CreateComplaintItemEvent>(_onSubmitForm);

    on<ChangeTypeEvent>((event, emit){
      emit(state.copyWith(selectedType: event.type));
    });

    on<ToggleEvent>((event, emit){
      emit(state.copyWith(isChecked: event.isChecked));
    });

    on<ChangeCategoryEvent>((event, emit){
      emit(state.copyWith(selectedCategory: event.category));
    });

    on<ChangePriorityEvent>((event, emit){
      emit(state.copyWith(selectedPriority: event.priority));
    });
  }



  FutureOr<void> _onSubmitForm(CreateComplaintItemEvent event, Emitter<ComplaintFormState> emit) async{
    emit(state.copyWith(isLoading: true, errorMessage: null));
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
        emit(state.copyWith(isLoading: false, isSuccess: true, selectedType: "Complaint", isChecked: true, selectedCategory: null, selectedPriority: 'Normal'));
      }else{
        emit(state.copyWith(errorMessage: "Failed to create complaint item", isLoading: false));
      }
    }catch(e){
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }

  }
}
