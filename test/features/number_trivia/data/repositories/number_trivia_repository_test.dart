import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/platform/network_info_interface.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source_interface.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source_interface.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
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

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

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
      runTestsOnline(() {
        test(
          'should return remote data when the call to remote data source is successfull',
          () async {
            // Arrange
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => testNumberTriviaModel);
            // Act
            final result = await repository.getConcreteNumberTrivia(testNumber);
            //Assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
            expect(result, equals(Right(testNumberTrivia)));
          },
        );

        test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
            // Arrange
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => testNumberTriviaModel);
            // Act
            await repository.getConcreteNumberTrivia(testNumber);
            //Assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
            verify(
                mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessfull',
          () async {
            // Arrange
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenThrow(ServerException());
            // Act
            final result = await repository.getConcreteNumberTrivia(testNumber);
            //Assert
            verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      runTestsOffline(() {
        test(
          'should return last locally cached data when the cached data is present',
          () async {
            // Arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => testNumberTriviaModel);
            // Act
            final result = await repository.getConcreteNumberTrivia(testNumber);
            //Assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(testNumberTrivia)));
          },
        );

        test(
          'should return CacheFailure  when there is no cached data  present',
          () async {
            // Arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            // Act
            final result = await repository.getConcreteNumberTrivia(testNumber);
            //Assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
      });
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      final testNumberTriviaModel =
          NumberTriviaModel(text: 'test trivia', number: 123);
      final NumberTrivia testNumberTrivia = testNumberTriviaModel;
      test(
        'should check if device is online',
        () async {
          // Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          // Act
          repository.getRandomNumberTrivia();
          //Assert
          verify(mockNetworkInfo.isConnected);
        },
      );
      runTestsOnline(() {
        test(
          'should return remote data when the call to remote data source is successfull',
          () async {
            // Arrange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => testNumberTriviaModel);
            // Act
            final result = await repository.getRandomNumberTrivia();
            //Assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            expect(result, equals(Right(testNumberTrivia)));
          },
        );

        test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
            // Arrange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => testNumberTriviaModel);
            // Act
            await repository.getRandomNumberTrivia();
            //Assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verify(
                mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessfull',
          () async {
            // Arrange
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());
            // Act
            final result = await repository.getRandomNumberTrivia();
            //Assert
            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      runTestsOffline(() {
        test(
          'should return last locally cached data when the cached data is present',
          () async {
            // Arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => testNumberTriviaModel);
            // Act
            final result = await repository.getRandomNumberTrivia();
            //Assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Right(testNumberTrivia)));
          },
        );

        test(
          'should return CacheFailure  when there is no cached data  present',
          () async {
            // Arrange
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());
            // Act
            final result = await repository.getRandomNumberTrivia();
            //Assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
      });
    },
  );
}
