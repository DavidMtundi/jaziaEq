import 'package:flutter/cupertino.dart';

class AnimatedButton extends AnimatedWidget {
  final AnimationController _controller;
  final Widget _child;
  const AnimatedButton( {Key? key,
    required AnimationController controller,
    required Widget child,
  })  : _controller = controller,_child=child,
        super(key: key, listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 - _controller.value,
      child: _child,
    );
  }
}