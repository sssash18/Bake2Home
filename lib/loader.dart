// import 'package:bake2home/constants.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math show sin, pi;

// import 'package:flutter/animation.dart';

// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// class DelayTween extends Tween<double> {
//   DelayTween({double begin, double end, this.delay})
//       : super(begin: begin, end: end);

//   final double delay;

//   @override
//   double lerp(double t) =>
//       super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

//   @override
//   double evaluate(Animation<double> animation) => lerp(animation.value);
// }

// class SpinKitCircle extends StatefulWidget {
//   const SpinKitCircle({
//     Key key,
//     this.color,
//     this.size = 50.0,
//     this.itemBuilder,
//     this.duration = const Duration(milliseconds: 1200),
//     this.controller,
//   })  : assert(
//             !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
//                 !(itemBuilder == null && color == null),
//             'You should specify either a itemBuilder or a color'),
//         assert(size != null),
//         super(key: key);

//   final Color color;
//   final double size;
//   final IndexedWidgetBuilder itemBuilder;
//   final Duration duration;
//   final AnimationController controller;

//   @override
//   _SpinKitCircleState createState() => _SpinKitCircleState();
// }

// class _SpinKitCircleState extends State<SpinKitCircle>
//     with SingleTickerProviderStateMixin {
//   final List<double> delays = [-0.4, -0.3 - 0.2, -0.1];
//   AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = (widget.controller ??
//         AnimationController(vsync: this, duration: widget.duration))
//       ..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox.fromSize(
//         size: Size.square(widget.size),
//         child: Stack(
//           children: List.generate(delays.length, (index) {
//             final _position = widget.size * .5;
//             return Positioned.fill(
//               left: _position,
//               top: _position,
//               child: Transform(
//                 transform: Matrix4.rotationZ(120.0 * index * 0.0174533),
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: ScaleTransition(
//                     scale:
//                         DelayTween(begin: 0.0, end: 1.0, delay: delays[index])
//                             .animate(_controller),
//                     child: SizedBox.fromSize(
//                         size: Size.square(widget.size * 0.5),
//                         child: _itemBuilder(index)),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   Widget _itemBuilder(int index) => widget.itemBuilder != null
//       ? widget.itemBuilder(context, index)
//       : ClipOval(
//           child: Image.asset(
//             'assets/images/logo.png',
//           ),
//         );
// }

// class Loader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: SpinKitCircle(
//         size: 60,
//         color: base,
//       ),
//     );
//   }
// }
// // class SpinKitChasingDots extends StatefulWidget {
// //   const SpinKitChasingDots({
// //     Key key,
// //     this.color,
// //     this.size = 50.0,
// //     this.itemBuilder,
// //     this.duration = const Duration(milliseconds: 2000),
// //   })  : assert(
// //             !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
// //                 !(itemBuilder == null && color == null),
// //             'You should specify either a itemBuilder or a color'),
// //         assert(size != null),
// //         super(key: key);

// //   final Color color;
// //   final double size;
// //   final IndexedWidgetBuilder itemBuilder;
// //   final Duration duration;

// //   @override
// //   _SpinKitChasingDotsState createState() => _SpinKitChasingDotsState();
// // }

// // class _SpinKitChasingDotsState extends State<SpinKitChasingDots>
// //     with TickerProviderStateMixin {
// //   AnimationController _scaleCtrl, _rotateCtrl;
// //   Animation<double> _scale, _rotate;

// //   @override
// //   void initState() {
// //     super.initState();

// //     _scaleCtrl = AnimationController(vsync: this, duration: widget.duration)
// //       ..addListener(() => setState(() {}))
// //       ..repeat(reverse: true);
// //     _scale = Tween(begin: -1.0, end: 1.0)
// //         .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut));

// //     _rotateCtrl = AnimationController(vsync: this, duration: widget.duration)
// //       ..addListener(() => setState(() {}))
// //       ..repeat();
// //     _rotate = Tween(begin: 0.0, end: 360.0)
// //         .animate(CurvedAnimation(parent: _rotateCtrl, curve: Curves.linear));
// //   }

// //   @override
// //   void dispose() {
// //     _scaleCtrl.dispose();
// //     _rotateCtrl.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: SizedBox.fromSize(
// //         size: Size.square(widget.size),
// //         child: Transform.rotate(
// //           angle: _rotate.value * 0.0174533,
// //           child: Stack(
// //             children: <Widget>[
// //               Positioned(top: 0.0, child: _circle(1.0 - _scale.value.abs(), 0)),
// //               Positioned(bottom: 0.0, child: _circle(_scale.value.abs(), 1)),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _circle(double scale, int index) {
// //     return Transform.scale(
// //       scale: scale,
// //       child: SizedBox.fromSize(
// //         size: Size.square(widget.size * 0.6),
// //         child: widget.itemBuilder != null
// //             ? widget.itemBuilder(context, index)
// //             : ClipOval(
// //                 child: Image.asset(
// //                   'assets/images/logo.png',
// //                 ),
// //               ),
// //       ),
// //     );
// //   }
// // }

// // class Loader extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       child: SpinKitChasingDots(
// //         color: base,
// //         size: 50,
// //       ),
// //     );
// //   }
// // }
