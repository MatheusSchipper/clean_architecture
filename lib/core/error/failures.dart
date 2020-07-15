import 'package:equatable/equatable.dart';

abstract class IFailure extends Equatable {
  IFailure([List properties = const <dynamic>[]]) : super();
}

// General failures

class ServerFailure extends IFailure {
  @override
  List<Object> get props => [];
}

class CacheFailure extends IFailure {
  @override
  List<Object> get props => [];
}
