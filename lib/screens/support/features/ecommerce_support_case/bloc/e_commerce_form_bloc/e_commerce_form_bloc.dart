import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:company_portal/utils/export_import.dart';

part 'e_commerce_form_event.dart';
part 'e_commerce_form_state.dart';

class ECommerceFormBloc extends Bloc<EcommerceFormEvent, EcommerceFormState> {
  final BaseEcommerceRepository _repo;
  ECommerceFormBloc(this._repo) : super(EcommerceFormState()) {
    on<CreateEcommerceItemEvent>(_onSubmitForm);

    on<ChangeEcommercePriorityEvent>((event,emit){
      emit(state.copyWith(selectedPriority: event.selectedPriority));
    });

    on<ChangeEcommerceAppEvent>((event,emit){
      emit(state.copyWith(selectedApp: event.selectApp));
    });

    on<ChangeEcommerceTypeEvent>((event,emit){
      emit(state.copyWith(selectedType: event.selectedType));
    });


  }

  FutureOr<void> _onSubmitForm(CreateEcommerceItemEvent event, Emitter<EcommerceFormState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try{
      final  success = await _repo.createItem(EcommerceItem(
        id: -1,
        title: event.title,
        description: event.description,
        priority: event.selectedPriority ?? "Normal",
        status: "New",
        assignedToId: null,
        authorId: event.userId,
        createdDate: null,
        modifiedDate: null,
        issueLoggedById: null,
        type: event.selectedType,
        app: [event.selectedApp!],
      ),
        event.attachedFiles,
      );
      if (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true, selectedApp: null, selectedPriority: "Normal", selectedType: null));
      } else {
        emit(state.copyWith(isLoading: false,errorMessage: "Failed to create ecommerce item"));
      }
    }catch(e){
      emit(state.copyWith(isLoading:false, errorMessage: e.toString()));
    }
  }
}
