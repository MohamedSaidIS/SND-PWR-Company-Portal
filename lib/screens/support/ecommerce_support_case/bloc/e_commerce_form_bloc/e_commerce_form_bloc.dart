import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/local/attached_file_info.dart';
import '../../../../../core/models/remote/e_commerce_item.dart';
import '../../repo/ecommerce_repo.dart';

part 'e_commerce_form_event.dart';
part 'e_commerce_form_state.dart';

class ECommerceFormBloc extends Bloc<ECommerceFormEvent, ECommerceFormState> {
  final BaseEcommerceRepository _repo;
  ECommerceFormBloc(this._repo) : super(ECommerceFormInitial()) {
    on<CreateECommerceItemEvent>(_onSubmitForm);
  }

  FutureOr<void> _onSubmitForm(CreateECommerceItemEvent event, Emitter<ECommerceFormState> emit) async {
    emit(ECommerceFormLoading());
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
        emit(ECommerceFormSuccess());
      } else {
        emit(ECommerceFormError("Failed to create ecommerce item"));
      }
    }catch(e){
      emit(ECommerceFormError(e.toString()));
    }
  }
}
