import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

abstract class INumberTriviaRepository {
  Future<Either<IFailure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<IFailure, NumberTrivia>> getRandomNumberTrivia();
}
