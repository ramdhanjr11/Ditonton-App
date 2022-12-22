import 'package:ditonton/presentation/bloc/tv_airing_today/tv_airing_today_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-airing-today';

  @override
  _AiringTodayTvPageState createState() => _AiringTodayTvPageState();
}

class _AiringTodayTvPageState extends State<AiringTodayTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<TvAiringTodayBloc>(context).add(FetchTvAiringToday()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airing today Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvAiringTodayBloc, TvAiringTodayState>(
          builder: (context, state) {
            if (state is TvAiringTodayLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvAiringTodayHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is TvAiringTodayError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text('oops something error, try again later..'),
              );
            }
          },
        ),
      ),
    );
  }
}
