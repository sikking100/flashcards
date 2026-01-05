import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WidgetCard extends HookWidget {
  const WidgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: Duration(milliseconds: 100));
    bool isFront = true;
    return GestureDetector(
      onTap: () {
        if (isFront) {
          controller.forward();
        } else {
          controller.reverse();
        }
        isFront = !isFront;
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final angle = controller.value * 3.1416;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: angle <= 1.57 ? frontCard() : Transform(alignment: Alignment.center, transform: Matrix4.rotationY(3.1416), child: backCard()),
          );
        },
      ),
    );
  }

  Widget frontCard() => Container(
    width: 200,
    height: 300,
    color: Colors.blue,
    child: Center(child: Text("FRONT")),
  );

  Widget backCard() => Container(
    width: 200,
    height: 300,
    color: Colors.red,
    child: Center(child: Text("BACK")),
  );
}
