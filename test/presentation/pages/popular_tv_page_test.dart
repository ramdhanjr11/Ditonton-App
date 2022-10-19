import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_page_test.mocks.dart';

@GenerateMocks([PopularTvNotifier])
void main() {
  late MockPopularTvNotifier mockPopularTvNotifier;

  setUp(() {
    mockPopularTvNotifier = MockPopularTvNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<PopularTvNotifier>.value(
      value: mockPopularTvNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'The page should display progressbar when loading',
    (widgetTester) async {
      // arrange
      when(mockPopularTvNotifier.state).thenReturn(RequestState.Loading);
      when(mockPopularTvNotifier.result).thenReturn(testTvList);

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
      when(mockPopularTvNotifier.state).thenReturn(RequestState.Loaded);
      when(mockPopularTvNotifier.result).thenReturn(testTvList);

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
      when(mockPopularTvNotifier.state).thenReturn(RequestState.Error);
      when(mockPopularTvNotifier.message).thenReturn('Failed');

      final textFinder = find.byKey(Key('error_message'));

      // act
      await widgetTester.pumpWidget(_makeTestableWidget(PopularTvPage()));

      // assert
      expect(textFinder, findsOneWidget);
    },
  );
}
