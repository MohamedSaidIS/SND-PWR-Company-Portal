import 'dart:async';
import 'package:company_portal/core/models/remote/direct_report.dart';
import 'package:company_portal/screens/account/profile/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/remote/user_info.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo _repo;
  ProfileBloc(this._repo) : super(ProfileState()) {
    on<FetchAllHierarchyEvent>(_fetchAllHierarchy);
  }

  FutureOr<void> _fetchAllHierarchy(FetchAllHierarchyEvent event, Emitter<ProfileState> emit)async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try{
      final result = await Future.wait([
        _repo.getManager(),
        _repo.getReports()
      ]);

      final manager = result[0] as UserInfo;
      final reports = result[1] as List<DirectReport>;

      emit(state.copyWith(isLoading:  false, errorMessage:  null, managerInfo: manager, reportItems: reports));

    }catch(e){
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
