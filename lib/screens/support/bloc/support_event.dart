part of 'support_bloc.dart';


sealed class SupportEvent {}

final class GetSupportDataEvent extends SupportEvent{
  final String email;
  GetSupportDataEvent(this.email);
}

final class AnimatedCardEvent extends SupportEvent{
  final int index;
  final bool value;

  AnimatedCardEvent(this.index, this.value);
}
