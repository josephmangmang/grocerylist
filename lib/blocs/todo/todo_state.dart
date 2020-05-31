import 'package:equatable/equatable.dart';

abstract class TodoState extends Equatable {}

class InitialState extends TodoState {
  @override
  List<Object> get props => [];
}
