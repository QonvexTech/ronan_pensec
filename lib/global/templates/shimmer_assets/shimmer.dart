import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/templates/shimmer_assets/shimmer_animation.dart';

class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({
    Key? key,
    required this.linearGradient,
    this.child,
  }) : super(key: key);

  final LinearGradient linearGradient;
  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

// class ShimmerState extends State<Shimmer> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.child ?? const SizedBox();
//   }
// }
class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController = AnimationController.unbounded(vsync: this)..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
  LinearGradient get gradient => LinearGradient(
    colors: widget.linearGradient.colors,
    stops: widget.linearGradient.stops,
    begin: widget.linearGradient.begin,
    end: widget.linearGradient.end,
    transform: ShimmerAnimation(slidePercent: _shimmerController.value)
  );
  Listenable get shimmerChanges => _shimmerController;
  bool get isSized => (context.findRenderObject() as RenderBox).hasSize;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }
  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}