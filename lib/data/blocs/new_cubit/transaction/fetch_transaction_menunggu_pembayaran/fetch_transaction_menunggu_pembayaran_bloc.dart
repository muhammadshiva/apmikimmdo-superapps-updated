import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:meta/meta.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/data/repositories/new_repositories/transaction_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'fetch_transaction_menunggu_pembayaran_event.dart';
part 'fetch_transaction_menunggu_pembayaran_state.dart';

class FetchTransactionMenungguPembayaranBloc extends Bloc<
    FetchTransactionMenungguPembayaranEvent,
    FetchTransactionMenungguPembayaranState> {
  FetchTransactionMenungguPembayaranBloc()
      : super(FetchTransactionMenungguPembayaranInitial()){
        on<TransactionMenungguPembayaranFetched>(onTransactionMenungguPembayaranFetched);
        on<TransactionMenungguPembayaranLoadedAfterDelete>(onTransactionMenungguPembayaranLoadedAfterDelete);
      }

  final TransactionRepository repository = TransactionRepository();

  onTransactionMenungguPembayaranFetched(
      TransactionMenungguPembayaranFetched event, Emitter<FetchTransactionMenungguPembayaranState> emit) async {
    emit(FetchTransactionMenungguPembayaranLoading());
    try {
      final response = await repository.fetchMenungguPembayaranTransactions();
      emit(FetchTransactionMenungguPembayaranSuccess(response.data));
    } catch (error) {
      emit(FetchTransactionMenungguPembayaranFailure(error.toString()));
    }
    
  }

  onTransactionMenungguPembayaranLoadedAfterDelete(TransactionMenungguPembayaranLoadedAfterDelete event,
      Emitter<FetchTransactionMenungguPembayaranState> emit) async {
    final menungguPembayaran = event.order.data
          .where((element) =>
              element.status.toLowerCase() == "menunggu pembayaran")
          .toList();
    emit(FetchTransactionMenungguPembayaranSuccessAfterDelete(
          menungguPembayaran));
  }


}
