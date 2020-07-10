import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../interfaces/trivia_repository_interface.dart';

class GetConcreteNumberTrivia implements IUseCase<NumberTrivia, Params> {
  final INumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);
  @override
  Future<Either<IFailure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number}) : super();

  @override
  List<Object> get props => [number];
}
