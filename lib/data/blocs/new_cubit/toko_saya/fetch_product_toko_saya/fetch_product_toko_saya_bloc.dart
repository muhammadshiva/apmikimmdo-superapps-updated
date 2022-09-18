import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';

part 'fetch_product_toko_saya_event.dart';
part 'fetch_product_toko_saya_state.dart';

class FetchProductTokoSayaBloc
    extends Bloc<FetchProductTokoSayaEvent, FetchProductTokoSayaState> {
  FetchProductTokoSayaBloc() : super(FetchProductTokoSayaState()){
    on<FetchedProductTokoSaya>(onFetchedProductTokoSaya);
    on<FetchedNextProductTokoSaya>(onFetchedNextProductTokoSaya);
  }

  final JoinUserRepository _shopRepo = JoinUserRepository();

  onFetchedProductTokoSaya(
    FetchedProductTokoSaya event, Emitter<FetchProductTokoSayaState> emit)async{
    emit(FetchProductTokoSayaLoading());
      try {
        final response = await _shopRepo.getProductList();
        emit(FetchProductTokoSayaSuccess(
            tokoSayaProduct: response.data,
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage));
      } catch (error) {
        if (error is NetworkException) {
          emit(FetchProductTokoSayaFailure.network(error.toString())) ;
          return;
        }
        emit(FetchProductTokoSayaFailure.general(error.toString()));
      }
  }

  onFetchedNextProductTokoSaya(
    FetchedNextProductTokoSaya event, Emitter<FetchProductTokoSayaState> emit
  )async{
    try {
        if (event.currentPage < event.lastPage) {
          List<TokoSayaProducts> tokoSayaProducts = [];
          tokoSayaProducts.addAll(event.tokoSayaProduct);
          final response = await _shopRepo.getProductListWithoutBaseurl(
            kDebugMode ?
              "/reseller/products?page=${event.currentPage + 1}" :
              "/reseller/products?page=${event.currentPage + 1}");
          if (tokoSayaProducts.length < response.meta.total) {
            tokoSayaProducts.addAll(response.data.toList());
          }
          // print(response.meta.total);
          // print(tokoSayaProducts.length);
          emit(FetchProductTokoSayaSuccess(
              tokoSayaProduct: tokoSayaProducts,
              currentPage: response.meta.currentPage,
              lastPage: response.meta.lastPage));
        }
      } catch (error) {
        if (error is NetworkException) {
          emit(FetchProductTokoSayaFailure.network(error.toString()));
          return;
        }
        emit(FetchProductTokoSayaFailure.general(error.toString()));
      }
  }

}
