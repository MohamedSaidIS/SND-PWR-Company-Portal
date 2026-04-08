import 'dart:async';
import 'package:company_portal/core/models/remote/new_user_request.dart';
import 'package:company_portal/screens/support/features/user_new_requests/repo/new_user_repo.dart';
import 'package:company_portal/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_user_form_event.dart';
part 'new_user_form_state.dart';

class NewUserFormBloc extends Bloc<NewUserFormEvent, NewUserFormState> {
  final BaseNewUserRepository _repo;
  NewUserFormBloc(this._repo) : super(NewUserFormState()) {
    on<SubmitNewUserFormEvent>(_onSubmit);
    on<ChangeDeviceTypeEvent>((event, emit){
      emit(state.copyWith(deviceType: event.selectedType));
    });
    on<ChangeNewEmailEvent>((event, emit){
      emit(state.copyWith(newEmail: event.newEmail));
    });
    on<ChangeNeedPhoneEvent>((event, emit){
      emit(state.copyWith(needPhone: event.needPhone));
    });
    on<ChangeUseDynamicsEvent>((event, emit){
      emit(state.copyWith(useDynamics: event.useDynamics));
    });

  }

  FutureOr<void> _onSubmit(SubmitNewUserFormEvent event, Emitter<NewUserFormState> emit) async{
    emit(state.copyWith(status: FormStatus.loading, errorMessage: null));
    try{
      bool success;
      if(event.isUpdate){
        success = await _repo.updateItem(event.item, event.itemId);
      }else{
        success = await _repo.createItem(event.item);
      }

      if(success){
        emit(state.copyWith(status: FormStatus.success));
      }else {
        emit(state.copyWith(status: FormStatus.error, errorMessage: "Something went wrong",
        ));
      }
    }catch(e){
      emit(state.copyWith(status: FormStatus.error, errorMessage: e.toString()));
    }
  }
}
