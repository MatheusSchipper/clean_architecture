import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../interfaces/trivia_repository_interface.dart';

class GetRandomNumberTrivia implements IUseCase<NumberTrivia, NoParams> {
  final INumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<IFailure, NumberTrivia>> call(params) async {
    return await repository.getRandomNumberTrivia();
  }
}
