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
final class ECommerceLoaded extends ECommerceState {
  final List<EcommerceItem> ecommerceItems;
  const ECommerceLoaded(this.ecommerceItems);


  @override
  List<Object?> get props => [ecommerceItems];
}
final class ECommerceEmpty extends ECommerceState {
  const ECommerceEmpty();


  @override
  List<Object?> get props => [];
}
final class ECommerceError extends ECommerceState {
  final String? errorMessage;
  const ECommerceError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

