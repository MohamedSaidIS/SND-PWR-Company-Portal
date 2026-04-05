import 'dart:async';

import 'package:company_portal/screens/support/repo/support_repo.dart';
import 'package:company_portal/utils/export_import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final BaseSupportRepository _repo;
  SupportBloc(this._repo) : super(SupportState()) {
    on<GetSupportDataEvent>(_getData);
    on<AnimatedCardEvent>((event, emit) {
      final updated = Map<int, bool>.from(state.animatedCards);
      updated[event.index] = event.value;

      emit(state.copyWith(animatedCards: updated));
    });
  }

  FutureOr<void> _getData(GetSupportDataEvent event, Emitter<SupportState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try{
      final result = await _repo.fetchAllEnsureUser(event.email);
      emit(state.copyWith(
        isLoading: false,
        itUser: result.itUser,
        alsanidiUser: result.alsanidiUser,
        dynamicsUser: result.dynamicsUser,
      ));
    }catch(e){
      emit(state.copyWith(isLoading: false, errorMessage: e.toString(),));
    }
  }
}
