import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:company_portal/utils/export_import.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final BaseComplaintRepository _repo;
  ComplaintBloc(this._repo) : super(const ComplaintLoading()) {
    on<GetComplaintItemsEvent>(_getItems);
  }

  FutureOr<void> _getItems(GetComplaintItemsEvent event, Emitter<ComplaintState> emit) async {
    emit(const ComplaintLoading());
    try{
      final items = await _repo.getItems(event.userId);
      if(items.isEmpty || items == []){
        emit(const ComplaintEmpty());
        return;
      }
      emit(ComplaintLoaded(items));
    }catch(e){
      emit(ComplaintError(e.toString()));
    }

  }
}
