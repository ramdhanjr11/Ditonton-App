import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/airing_today_tv_page.dart';
import 'package:ditonton/presentation/provider/airing_today_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'airing_today_tv_page_test.mocks.dart';

@GenerateMocks([AiringTodayTvNotifier])
void main() {
  late MockAiringTodayTvNotifier mockAiringTodayTvNotifier;

  setUp(() {
    mockAiringTodayTvNotifier = MockAiringTodayTvNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<AiringTodayTvNotifier>.value(
      value: mockAiringTodayTvNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "The page should display progress bar when loading",
    (WidgetTester tester) async {
      // arrange
      when(mockAiringTodayTvNotifier.state).thenReturn(RequestState.Loading);

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
      when(mockAiringTodayTvNotifier.state).thenReturn(RequestState.Loaded);
      when(mockAiringTodayTvNotifier.result).thenReturn(testTvList);

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
      when(mockAiringTodayTvNotifier.state).thenReturn(RequestState.Error);
      when(mockAiringTodayTvNotifier.message).thenReturn('Failed');

      final textErrorFinder = find.byKey(Key('error_message'));

      // act
      await tester.pumpWidget(_makeTestableWidget(AiringTodayTvPage()));

      // assert
      expect(textErrorFinder, findsOneWidget);
    },
  );
}
