import 'dart:async';

import 'package:company_portal/core/models/remote/new_user_request.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/new_user_repo.dart';

part 'new_user_event.dart';
part 'new_user_state.dart';

class NewUserBloc extends Bloc<NewUserEvent,NewUserState> {
  final BaseNewUserRepository _repo;
  NewUserBloc(this._repo) : super(const NewUserLoading()) {
    on<GetNewUserItemsEvent>(_getItems);
  }

  FutureOr<void> _getItems(GetNewUserItemsEvent event, Emitter<NewUserState> emit) async{
    emit(const NewUserLoading());
    try{
      final items = await _repo.getItems(event.userId);
      emit(NewUserLoaded(items));
    }catch(e){
      emit(NewUserError(e.toString()));
    }
  }
}
