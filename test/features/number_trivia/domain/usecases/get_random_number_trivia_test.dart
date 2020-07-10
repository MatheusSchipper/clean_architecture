import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/interfaces/trivia_repository_interface.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockINumberTriviaRepository extends Mock
    implements INumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockINumberTriviaRepository mockINumberTriviaRepository;

  setUp(() {
    mockINumberTriviaRepository = MockINumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockINumberTriviaRepository);
  });

  final testNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia from the repository',
    () async {
      // Arrange
      when(mockINumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(testNumberTrivia));
      // Act
      final result = await usecase(NoParams());
      // Assert
      expect(result, Right(testNumberTrivia));
      verify(mockINumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockINumberTriviaRepository);
    },
  );
}
