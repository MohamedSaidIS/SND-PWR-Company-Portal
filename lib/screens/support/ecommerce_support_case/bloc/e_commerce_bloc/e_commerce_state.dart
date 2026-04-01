part of 'e_commerce_bloc.dart';

sealed class ECommerceState extends Equatable{
  const ECommerceState();

  @override
  List<Object?> get props => [];
}

final class ECommerceLoading extends ECommerceState {
  const ECommerceLoading();

  @override
  List<Object?> get props => [];

}
final class ECommerceData extends ECommerceState {
  final List<EcommerceItem> ecommerceItems;
  const ECommerceData(this.ecommerceItems);


  @override
  List<Object?> get props => [ecommerceItems];
}
final class ECommerceError extends ECommerceState {
  final String? errorMessage;
  const ECommerceError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

final class ECommerceSuccess extends ECommerceState{
  const ECommerceSuccess();

  @override
  List<Object?> get props => [];
}
