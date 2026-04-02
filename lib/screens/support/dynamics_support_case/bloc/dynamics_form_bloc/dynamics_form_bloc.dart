import 'dart:async';
import 'package:company_portal/core/models/remote/dynamics_item.dart';
import 'package:company_portal/screens/support/dynamics_support_case/repo/dynamics_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/local/attached_file_info.dart';
import '../../../../../utils/app_helper.dart';

part 'dynamics_form_event.dart';
part 'dynamics_form_state.dart';

class DynamicsFormBloc extends Bloc<DynamicsFormEvent, DynamicsFormState> {
  final BaseDynamicsRepository _repo;
  DynamicsFormBloc(this._repo) : super(const DynamicsFormInitial()) {
    on<CreateDynamicsItemEvent>(_onSubmitForm);
  }


  FutureOr<void> _onSubmitForm(CreateDynamicsItemEvent event, Emitter<DynamicsFormState> emit) async{
    emit(const DynamicsFormLoading());
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
        emit(const DynamicsFormSuccess());
      }else {
        emit(const DynamicsFormError("Failed to create dynamics item"));
      }
    }catch(e){
      emit(DynamicsFormError(e.toString()));
    }
  }

}
