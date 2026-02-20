import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatsHistoryShimmer extends StatelessWidget {
  const ChatsHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.black.withOpacity(.2),
          highlightColor: Colors.white,
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(.5),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}
