import 'package:ditonton/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_mocktail.dart';

void main() {
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUp(() {
    registerFallbackValue(FakeTopRatedTvEvent());
    registerFallbackValue(FakeTopRatedTvState());
    mockTopRatedTvBloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>(
      create: (context) => mockTopRatedTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "The page should display progressbar when loading",
    (WidgetTester tester) async {
      // arrange
      when(() => mockTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      // act
      await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

      // assert
      expect(progressFinder, findsOneWidget);
      expect(centerFinder, findsOneWidget);
    },
  );

  testWidgets(
    "The page should display listview when load data is successful",
    (WidgetTester tester) async {
      // arrange
      when(() => mockTopRatedTvBloc.state)
          .thenReturn(TopRatedTvHasData(testTvList));

      // act
      await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
    },
  );

  testWidgets(
    "The page should display error message when load data is error",
    (WidgetTester tester) async {
      // arrange
      when(() => mockTopRatedTvBloc.state)
          .thenReturn(TopRatedTvError('Server Failure'));

      final errorTextFinder = find.byKey(Key('error_message'));

      // act
      await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

      // assert
      expect(errorTextFinder, findsOneWidget);
    },
  );
}
