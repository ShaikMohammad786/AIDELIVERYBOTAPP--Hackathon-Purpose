// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class PaymentScreen extends StatelessWidget {
//   const PaymentScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Lottie.asset('assets/payment_bg.json', fit: BoxFit.cover, repeat: true),
//           ),
//           Center(
//             child: Card(
//               color: Colors.white.withOpacity(0.12),
//               elevation: 12,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//               child: Padding(
//                 padding: const EdgeInsets.all(30),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Lottie.asset('assets/payment_anim.json', height: 120, repeat: true),
//                     const SizedBox(height: 18),
//                     const Text(
//                       "Payment",
//                       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Dummy payment for delivery robot booking.\nNo actual money will be charged.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     const SizedBox(height: 30),
//                     SizedBox(
//                       width: 180,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepPurpleAccent,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                           elevation: 8,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                         ),
//                         onPressed: () {
//                           Navigator.pushReplacementNamed(context, '/accesscode');
//                         },
//                         child: const Text(
//                           "Pay Now",
//                           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  late AnimationController _heroController;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..forward();
    _opacityAnim = CurvedAnimation(parent: _heroController, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: Lottie.asset('assets/payment_bg.json', fit: BoxFit.cover)),
          // Soft spotlight layer for premium look
          Positioned.fill(
            child: IgnorePointer(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.white12, Colors.transparent],
                      radius: 0.7,
                      center: Alignment(0, -.1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _opacityAnim,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.94, end: 1.0).animate(_opacityAnim),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    color: Colors.white.withOpacity(0.10),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(0.45),
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.14),
                        blurRadius: 46,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: 'pay-anim',
                        child: Lottie.asset('assets/payment_anim.json', height: 110, repeat: true),
                      ),
                      const SizedBox(height: 16),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.deepPurpleAccent, Colors.cyanAccent],
                        ).createShader(bounds),
                        child: const Text(
                          "Payment",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Reserve and unlock premium delivery with a tap.\nNo real money—just experience the magic.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 28),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.85, end: 1.0),
                        curve: Curves.elasticOut,
                        builder: (ctx, scale, child) => Transform.scale(
                          scale: scale,
                          child: child,
                        ),
                        child: SizedBox(
                          width: 190,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              elevation: 12,
                              shadowColor: Colors.deepPurpleAccent.withOpacity(0.23),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/accesscode');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.credit_card, color: Colors.white, size: 26),
                                SizedBox(width: 12),
                                Text(
                                  "Pay Now",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}