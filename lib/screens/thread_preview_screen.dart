import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexity_mobile/blocs/blocs.dart';
import 'package:lexity_mobile/screens/screens.dart';
import 'package:lexity_mobile/utils/test_keys.dart';
import 'package:lexity_mobile/utils/utils.dart';

class ThreadPreviewScreen extends StatelessWidget {
  const ThreadPreviewScreen();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ThreadPreviewScreen());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.bloc<AuthenticationBloc>().state.user;
    final tweets = context.bloc<NotesCubit>().state.tweets;
    final urlLauncher = UrlLauncher();

    return BlocBuilder<NotesCubit, NotesState>(builder: (context, state) {
      return Scaffold(
        appBar: state is TweetSucceeded
            // hide appbar after tweeting
            ? AppBar(
                leadingWidth: 70,
                leading: Container(),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.teal[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push<void>(context, MainScreen.route());
                    },
                  ),
                ],
              )
            : AppBar(
                leadingWidth: 70,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  'Preview Thread',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      child: const Text(
                        'Tweet',
                      ),
                      onPressed: () {
                        context.bloc<NotesCubit>().tweetNotes(tweets, user);
                      },
                    ),
                  ),
                ],
              ),
        body: BlocBuilder<NotesCubit, NotesState>(
          builder: (context, state) {
            if (state is NotesInitial || state is NotesLoading) {
              return Center(
                key: TestKeys.bookDetailsLoadingSpinner,
                child: const CircularProgressIndicator(),
              );
            } else if (state is TweetSucceeded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Success! 🎉',
                        style: Theme.of(context).textTheme.headline6),
                    const Text('You shared your notes on Twitter.'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                              onPressed: () {
                                Navigator.push<void>(
                                    context, MainScreen.route());
                              },
                              child: Text('Go to Reading List',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                urlLauncher.launchInWebViewOrVC(
                                    // Initiate tweet of "@lexityapp "
                                    state.tweetUrl ?? 'https://twitter.com/');
                              },
                              child: const Text(
                                'View on Twitter',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else if (state.notes != null) {
              return SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    children: [
                      for (var tweet in tweets)
                        TweetPreviewCard(tweet, user.profileImg),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Oops. Something went wrong.'),
              );
            }
          },
        ),
      );
    });
  }
}

class TweetPreviewCard extends StatelessWidget {
  TweetPreviewCard(this.tweet, this.profileImg);

  final String tweet;
  final String profileImg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profileImg ?? ''),
              backgroundColor: Colors.grey[600],
            ),
            title: Text(
              tweet,
            ),
            onTap: () {},
          ),
        ),
        const Divider(),
      ],
    );
  }
}
