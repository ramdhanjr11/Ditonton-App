import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_watchlist_status/tv_watchlist_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv_detail';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<TvDetailBloc>(context).add(FetchTvDetail(widget.id));
      BlocProvider.of<TvRecommendationBloc>(context)
          .add(FetchTvRecommendation(widget.id));
      BlocProvider.of<TvWatchlistStatusBloc>(context)
          .add(FetchTvWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailHasData) {
            return SafeArea(
              child: DetailTvContent(state.result),
            );
          } else if (state is TvDetailError) {
            return Text(state.message);
          } else {
            return Text('Oops someting wrong, try again later..');
          }
        },
      ),
    );
  }
}

class DetailTvContent extends StatelessWidget {
  final TvDetail tv;
  late List<Tv> recommendations;
  late bool isAddedWatchlist;

  DetailTvContent(this.tv);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        BlocListener<TvWatchlistStatusBloc, TvWatchlistStatusState>(
          listener: (context, state) {
            if (state is TvWatchlistStatus) {
              if (state.message.isNotEmpty) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            } else if (state is TvWatchlistStatusError) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(state.message),
                  );
                },
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tv.name!,
                                style: kHeading5,
                              ),
                              BlocBuilder<TvWatchlistStatusBloc,
                                  TvWatchlistStatusState>(
                                builder: (context, state) {
                                  if (state is TvWatchlistStatus) {
                                    isAddedWatchlist = state.status;
                                    return ElevatedButton(
                                      onPressed: () async {
                                        if (!isAddedWatchlist) {
                                          context
                                              .read<TvWatchlistStatusBloc>()
                                              .add(AddWatchlist(tv));
                                        } else {
                                          context
                                              .read<TvWatchlistStatusBloc>()
                                              .add(DeleteWatchlist(tv));
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          isAddedWatchlist
                                              ? Icon(Icons.check)
                                              : Icon(Icons.add),
                                          Text('Watchlist'),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                              Text(
                                showGenres(tv.genres),
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: tv.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text('${tv.voteAverage}')
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Seasons/Episodes',
                                style: kHeading6,
                              ),
                              _buildTvSeasons(),
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: kHeading6,
                              ),
                              Text(
                                tv.overview!,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Recommendations',
                                style: kHeading6,
                              ),
                              BlocBuilder<TvRecommendationBloc,
                                  TvRecommendationState>(
                                builder: (context, state) {
                                  if (state is TvRecommendationLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is TvRecommendationError) {
                                    return Text(state.message);
                                  } else if (state is TvRecommendationHasData) {
                                    recommendations = state.result;
                                    return _buildTvRecommendations();
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          height: 4,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                );
              },
              // initialChildSize: 0.5,
              minChildSize: 0.25,
              // maxChildSize: 1.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Container _buildTvRecommendations() {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: recommendations.length,
      ),
    );
  }

  Container _buildTvSeasons() {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final season = tv.seasons[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Coming soon feature'),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/w500${season.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tv.seasons.length,
      ),
    );
  }
}
