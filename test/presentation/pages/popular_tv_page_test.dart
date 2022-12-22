import 'package:ditonton/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_mocktail.dart';

void main() {
  late MockPopularTvBloc mockPopularTvBloc;

  setUp(() {
    registerFallbackValue(FakePopularTvEvent());
    registerFallbackValue(FakePopularTvState());
    mockPopularTvBloc = MockPopularTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>(
      create: (context) => mockPopularTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'The page should display progressbar when loading',
    (widgetTester) async {
      // arrange
      when(() => mockPopularTvBloc.state).thenReturn(PopularTvLoading());

      final centerFinder = find.byType(Center);
      final progressFinder = find.byType(CircularProgressIndicator);

      // act
      await widgetTester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      // assert
      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    },
  );

  testWidgets(
    'The page should display listview when data is loaded',
    (widgetTester) async {
      // arrange
      when(() => mockPopularTvBloc.state)
          .thenReturn(PopularTvHasData(testTvList));

      // act
      await widgetTester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      // assert
      expect(find.byType(ListView), findsOneWidget);
    },
  );

  testWidgets(
    'The page should display error message when load data is error',
    (widgetTester) async {
      // arrange
      when(() => mockPopularTvBloc.state)
          .thenReturn(PopularTvError('Server Failure'));

      final textFinder = find.byKey(Key('error_message'));

      // act
      await widgetTester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      // assert
      expect(textFinder, findsOneWidget);
    },
  );
}
