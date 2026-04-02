import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/local/attached_file_info.dart';

part 'complaint_form_event.dart';
part 'complaint_form_state.dart';

class ComplaintFormBloc extends Bloc<ComplaintFormEvent, ComplaintFormState>{
  ComplaintFormBloc() : super(const ComplaintFormInitial()) {
    on<CreateComplaintItemEvent>(_onSubmit);
  }

  FutureOr<void> _onSubmit(CreateComplaintItemEvent event, Emitter<ComplaintFormState> emit) {
  }
}
