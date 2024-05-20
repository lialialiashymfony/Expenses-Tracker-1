part of 'balance_cubit.dart';

@immutable
class BalanceState {
  final int balance;
  const BalanceState({required this.balance});
}

final class BalanceInitial extends BalanceState {
  const BalanceInitial() : super(balance: 0);
}
