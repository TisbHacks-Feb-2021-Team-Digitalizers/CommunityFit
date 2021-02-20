import 'package:community_fit/constants/colors.dart';
import 'package:community_fit/models/dish.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DishInformationPage extends ConsumerWidget {
  final Dish dish;
  const DishInformationPage({
    @required this.dish,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Dish'),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
    );
  }
}
