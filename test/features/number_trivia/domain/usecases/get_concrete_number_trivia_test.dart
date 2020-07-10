import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/interfaces/trivia_repository_interface.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockINumberTriviaRepository extends Mock
    implements INumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockINumberTriviaRepository mockINumberTriviaRepository;

  setUp(() {
    mockINumberTriviaRepository = MockINumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockINumberTriviaRepository);
  });

  final testNumber = 1;
  final testNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repository',
    () async {
      // Arrange
      when(mockINumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));
      // Act
      final result = await usecase(Params(number: testNumber));
      // Assert
      expect(result, Right(testNumberTrivia));
      verify(mockINumberTriviaRepository.getConcreteNumberTrivia(testNumber));
      verifyNoMoreInteractions(mockINumberTriviaRepository);
    },
  );
}
