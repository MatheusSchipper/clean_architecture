import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info_interface.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/interfaces/trivia_repository_interface.dart';
import '../datasources/number_trivia_local_data_source_interface.dart';
import '../datasources/number_trivia_remote_data_source_interface.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepository implements INumberTriviaRepository {
  final INumberTriviaRemoteDataSource remoteDataSource;
  final INumberTriviaLocalDataSource localDataSource;
  final INetworkInfo networkInfo;

  NumberTriviaRepository(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});
  @override
  Future<Either<IFailure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<IFailure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<IFailure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteNumberTrivia) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteNumberTrivia();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
