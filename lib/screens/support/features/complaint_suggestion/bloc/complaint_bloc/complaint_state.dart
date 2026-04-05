part of 'complaint_bloc.dart';


sealed class ComplaintState extends Equatable{
  const ComplaintState();
}

final class ComplaintLoading extends ComplaintState {
  const ComplaintLoading();

  @override
  List<Object?> get props => [];
}
final class ComplaintLoaded extends ComplaintState {
  final List<ComplaintSuggestionItem> complaintItems;
  const ComplaintLoaded(this.complaintItems);

  @override
  List<Object?> get props => [complaintItems];
}

final class ComplaintEmpty extends ComplaintState {
  const ComplaintEmpty();

  @override
  List<Object?> get props => [];
}
final class ComplaintError extends ComplaintState {
  final String? errorMessage;
  const ComplaintError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
