import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { opacity, transform }

class AnimatedWidgetX extends StatelessWidget {
  final Widget child;
  final double delay;
  final Duration duration;

  AnimatedWidgetX(
      {required this.child, required this.delay, required this.duration});

  @override
  Widget build(BuildContext context) {
    final _tween = TimelineTween<AniProps>()
      ..addScene(
        duration: duration,
        begin: 0.milliseconds,
      ).animate(AniProps.opacity, tween: Tween(begin: 0.0, end: 1.0))
      ..addScene(
        duration: duration,
        curve: Curves.easeOut,
        begin: 0.milliseconds,
      ).animate(AniProps.transform, tween: Tween(begin: -30.0, end: 0.0));
    return PlayAnimation<TimelineValue<AniProps>>(
      delay: Duration(milliseconds: (duration.inMilliseconds * delay).round()),
      duration: _tween.duration,
      tween: _tween,
      child: child,
      builder: (_, child, animation) => Opacity(
        opacity: animation.get(AniProps.opacity),
        child: Transform.translate(
          offset: Offset(0, animation.get(AniProps.transform)),
          child: child,
        ),
      ),
    );
  }
}
