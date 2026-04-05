import 'dart:async';
import 'package:company_portal/utils/export_import.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'e_commerce_event.dart';
part 'e_commerce_state.dart';

class ECommerceBloc extends Bloc<ECommerceEvent, ECommerceState> {
  final BaseEcommerceRepository _repo;
  ECommerceBloc(this._repo) : super(const ECommerceLoading()) {
    on<GetECommerceItemsEvent>(_getItems);
  }


  FutureOr<void> _getItems(GetECommerceItemsEvent event, Emitter<ECommerceState> emit) async{
    emit(const ECommerceLoading());
    try{
      final items = await _repo.getItems(event.userId);
      emit(ECommerceLoaded(items));
    }catch(e){
      emit(ECommerceError(e.toString()));
    }
  }

}
