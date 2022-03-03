import 'package:flutter/material.dart';
import 'package:jazia/services/constants.dart';

class ButtonAnimation extends StatefulWidget {
  final Color primaryColor;
  final Color darkPrimaryColor;

  const ButtonAnimation(this.primaryColor, this.darkPrimaryColor, {Key? key})
      : super(key: key);

  @override
  _ButtonAnimationState createState() => _ButtonAnimationState();
}

class _ButtonAnimationState extends State<ButtonAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scaleAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  double buttonWidth = 200.0;
  double scale = 1.0;
  bool animationComplete = false;
  double barColorOpacity = .6;
  bool animationStart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _scaleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _fadeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _fadeAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(_fadeAnimationController);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(_scaleAnimationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _scaleAnimationController.reverse();
          _fadeAnimationController.forward();
          _animationController.forward();
        }
      });

    _animation = Tween<double>(begin: 0.0, end: buttonWidth)
        .animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            animationComplete = true;
            barColorOpacity = .0;
          });
        }
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _animationController.dispose();
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
            animation: _scaleAnimationController,
            builder: (context, child) => Transform.scale(
                  scale: _scaleAnimation.value,
                  child: InkWell(
                    onTap: () {
                      _scaleAnimationController.forward();
                      setState(() {
                        hasDownloadOccured = true;
                      });
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: animationComplete == false
                          ? BoxDecoration(
                              color: widget.primaryColor,
                              borderRadius: BorderRadius.circular(20))
                          : BoxDecoration(
                              color: widget.darkPrimaryColor,
                              borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                                child: animationComplete == false
                                    ? const Padding(
                                        padding: EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          "Download",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "Downloaded",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )),
                          ),
                          AnimatedBuilder(
                            animation: _fadeAnimationController,
                            builder: (context, child) => Container(
                              width: _fadeAnimation.value,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: widget.darkPrimaryColor,
                                  borderRadius: BorderRadius.circular(3)),
                              child: const Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Positioned(
            left: 0,
            top: 0,
            width: _animation.value,
            height: 50,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: barColorOpacity,
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
