import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingChatMessagesShimmer extends StatelessWidget {
  const LoadingChatMessagesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: 6,
        itemBuilder: (context, index) {
          final bool fromZakat = index % 2 != 0;

          return Align(
            alignment: fromZakat
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Shimmer.fromColors(
              baseColor: Colors.black.withOpacity(.2),
              highlightColor: Colors.white,
              child: Container(
                height: 50,
                width:
                    MediaQuery.sizeOf(context).width * (fromZakat ? 0.7 : 0.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(.5),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      ),
    );
  }
}
