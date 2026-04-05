import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:company_portal/utils/export_import.dart';
part 'dynamics_event.dart';
part 'dynamics_state.dart';

class DynamicsBloc extends Bloc<DynamicsEvent, DynamicsState> {
  final BaseDynamicsRepository _repo;
  DynamicsBloc(this._repo) : super(const DynamicsLoading()) {
    on<GetDynamicsItemsEvent>(_getItems);
  }

  FutureOr<void> _getItems(GetDynamicsItemsEvent event, Emitter<DynamicsState> emit) async{
    emit(const DynamicsLoading());
    try{
      final items = await _repo.getItems(event.userId);
      if(items.isEmpty || items == []){
        emit(const DynamicsEmpty());
      }
      emit(DynamicsLoaded(items));
    }catch(e){
      emit(DynamicsError(e.toString()));
    }
  }
}
