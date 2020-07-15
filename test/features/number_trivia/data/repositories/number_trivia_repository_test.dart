import 'package:clean_architecture/core/platform/network_info_interface.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source_interface.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source_interface.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements INumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements INumberTriviaLocalDataSource {
}

class MockNetworkInfo extends Mock implements INetworkInfo {}

void main() {
  NumberTriviaRepository repository;

  MockRemoteDataSource mockRemoteDataSource;

  MockLocalDataSource mockLocalDataSource;

  MockNetworkInfo mockNetworkInfo;

  setUp(
    () {
      mockRemoteDataSource = MockRemoteDataSource();
      mockLocalDataSource = MockLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = NumberTriviaRepository(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
    },
  );

  group(
    'getConcreteNumberTrivia',
    () {
      final testNumber = 1;
      final testNumberTriviaModel =
          NumberTriviaModel(text: 'test trivia', number: testNumber);
      final NumberTrivia testNumberTrivia = testNumberTriviaModel;
      test(
        'should check if device is online',
        () async {
          // Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          // Act
          repository.getConcreteNumberTrivia(testNumber);
          //Assert
          verify(mockNetworkInfo.isConnected);
        },
      );
    },
  );
}
