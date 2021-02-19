import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community_fit/constants/colors.dart';
import 'package:community_fit/screens/LandingPage/landingPage.dart';
import 'package:community_fit/screens/LeaderBoardPage/leaderBoardPage.dart';

final bottomNavigationIndexStateProvider =
    StateProvider.autoDispose<int>((ref) {
  return 0;
});

class HomePage extends ConsumerWidget {
  List<Widget> get bodyWidgets {
    return [
      LandingPage(),
      LeaderBoardPage(),
    ];
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bottomNavigationIndex =
        watch(bottomNavigationIndexStateProvider).state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'CommunityFit',
        ),
        centerTitle: true,
      ),
      body: bodyWidgets[bottomNavigationIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appBarColor,
        selectedItemColor: Colors.white,
        currentIndex: bottomNavigationIndex,
        onTap: (int index) {
          context.read(bottomNavigationIndexStateProvider).state = index;
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.leaderboard,
            ),
            label: 'LeaderBoard',
          ),
        ],
      ),
    );
  }
}
