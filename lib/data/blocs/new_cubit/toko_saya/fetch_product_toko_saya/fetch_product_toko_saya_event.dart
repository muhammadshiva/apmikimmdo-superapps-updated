part of 'fetch_product_toko_saya_bloc.dart';

class FetchProductTokoSayaEvent extends Equatable {
  const FetchProductTokoSayaEvent();

  @override
  List<Object> get props => [];
}

class FetchedProductTokoSaya extends FetchProductTokoSayaEvent {}

class FetchedNextProductTokoSaya extends FetchProductTokoSayaEvent {
  final List<TokoSayaProducts> tokoSayaProduct;
  final int currentPage,lastPage;

  FetchedNextProductTokoSaya({this.tokoSayaProduct,this.currentPage,this.lastPage});

  @override
  List<Object> get props => [tokoSayaProduct,currentPage,lastPage];
}
