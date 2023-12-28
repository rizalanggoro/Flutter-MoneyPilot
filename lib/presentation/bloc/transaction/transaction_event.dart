part of 'transaction_bloc.dart';

sealed class TransactionEvent {}

class TransactionAddEvent extends TransactionEvent {
  final Transaction transaction;
  TransactionAddEvent({
    required this.transaction,
  });
}

class TransactionRemoveEvent extends TransactionEvent {
  final Transaction transaction;
  TransactionRemoveEvent({
    required this.transaction,
  });
}
