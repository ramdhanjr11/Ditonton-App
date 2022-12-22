import 'package:ditonton/presentation/bloc/tv_airing_today/tv_airing_today_bloc.dart';
import 'package:ditonton/presentation/pages/airing_today_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_mocktail.dart';

void main() {
  late MockTvAiringTodayBloc mockTvAiringTodayBloc;

  setUp(() {
    registerFallbackValue(FakeTvAiringTodayEvent());
    registerFallbackValue(FakeTvAiringTodayState());
    mockTvAiringTodayBloc = MockTvAiringTodayBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvAiringTodayBloc>(
      create: (context) => mockTvAiringTodayBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "The page should display progress bar when loading",
    (WidgetTester tester) async {
      // arrange
      when(() => mockTvAiringTodayBloc.state)
          .thenReturn(TvAiringTodayLoading());

      final centerFinder = find.byType(Center);
      final progressFinder = find.byType(CircularProgressIndicator);

      // act
      await tester.pumpWidget(_makeTestableWidget(AiringTodayTvPage()));

      // assert
      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    },
  );

  testWidgets(
    "The page should display listview when load data is success",
    (WidgetTester tester) async {
      // arrange
      when(() => mockTvAiringTodayBloc.state)
          .thenReturn(TvAiringTodayHasData(testTvList));

      final listViewFinder = find.byType(ListView);

      // act
      await tester.pumpWidget(_makeTestableWidget(AiringTodayTvPage()));

      // assert
      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    "The page should display error message when load data is error",
    (WidgetTester tester) async {
      // arrange
      when(() => mockTvAiringTodayBloc.state)
          .thenReturn(TvAiringTodayError('Server Failure'));

      final textErrorFinder = find.byKey(Key('error_message'));

      // act
      await tester.pumpWidget(_makeTestableWidget(AiringTodayTvPage()));

      // assert
      expect(textErrorFinder, findsOneWidget);
    },
  );
}
