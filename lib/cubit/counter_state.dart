part of 'counter_cubit.dart';

@immutable
class CounterState {
  final int counter;
  const CounterState({required this.counter, required this.status});
  final String status;
}

final class CounterInitial extends CounterState {
  const CounterInitial() : super(counter: 0, status: "Genap");
}
