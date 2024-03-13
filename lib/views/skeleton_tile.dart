import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonTile extends StatelessWidget {
  const SkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
      child: ListTile(
        leading: CircleAvatar(),
        title: Text('Lorem ipsum dolor sit amet'),
      ),
    );
  }
}
