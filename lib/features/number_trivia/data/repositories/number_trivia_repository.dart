import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info_interface.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/interfaces/trivia_repository_interface.dart';
import '../datasources/number_trivia_local_data_source_interface.dart';
import '../datasources/number_trivia_remote_data_source_interface.dart';

class NumberTriviaRepository implements INumberTriviaRepository {
  final INumberTriviaRemoteDataSource remoteDataSource;
  final INumberTriviaLocalDataSource localDataSource;
  final INetworkInfo networkInfo;

  NumberTriviaRepository(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});
  @override
  Future<Either<IFailure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    networkInfo.isConnected;
    return null;
  }

  @override
  Future<Either<IFailure, NumberTrivia>> getRandomNumberTrivia() {
    return null;
  }
}
