import 'package:flutter/material.dart';
import 'package:lec/view/app_data/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class CardShimmer extends StatelessWidget {
  final double height;
  const CardShimmer({Key? key, required this.height}) : super(key: key);

  final bool _enabled = true;
  static double? _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Shimmer.fromColors(
        baseColor: AppColors.grey,
        highlightColor: AppColors.white,
        enabled: _enabled,
        direction: ShimmerDirection.ltr,
        period: const Duration(seconds: 3),
        child: ListView.builder(
            itemCount: 20,
            itemBuilder: ((context, index) {
              return Container(
                height: height,
                width: _width,
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 10),
                decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 0.5))
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.blue),
              );
            })),
      ),
    ));
  }
}
