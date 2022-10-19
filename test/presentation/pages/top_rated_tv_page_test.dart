import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_page_test.mocks.dart';

@GenerateMocks([TopRatedTvNotifier])
void main() {
  late MockTopRatedTvNotifier mockTopRatedTvNotifier;

  setUp(() {
    mockTopRatedTvNotifier = MockTopRatedTvNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTvNotifier>.value(
      value: mockTopRatedTvNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    "The page should display progressbar when loading",
    (WidgetTester tester) async {
      // arrange
      when(mockTopRatedTvNotifier.state).thenReturn(RequestState.Loading);

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
      when(mockTopRatedTvNotifier.state).thenReturn(RequestState.Loaded);
      when(mockTopRatedTvNotifier.result).thenReturn(testTvList);

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
      when(mockTopRatedTvNotifier.state).thenReturn(RequestState.Error);
      when(mockTopRatedTvNotifier.message).thenReturn('Failed');

      final errorTextFinder = find.byKey(Key('error_message'));

      // act
      await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

      // assert
      expect(errorTextFinder, findsOneWidget);
    },
  );
}
