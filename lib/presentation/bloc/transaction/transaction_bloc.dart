import 'package:bloc/bloc.dart';
import 'package:money_pilot/core/enums/state_status.dart';
import 'package:money_pilot/domain/models/transaction.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionState()) {
    on<TransactionAddEvent>((event, emit) {});
    on<TransactionRemoveEvent>((event, emit) {});
  }
}
