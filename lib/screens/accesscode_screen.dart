

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'dart:ui';

// class AccessCodeScreen extends StatefulWidget {
//   const AccessCodeScreen({super.key});
//   @override
//   State<AccessCodeScreen> createState() => _AccessCodeScreenState();
// }

// class _AccessCodeScreenState extends State<AccessCodeScreen>
//     with SingleTickerProviderStateMixin {
//   late String accessCode;
//   late AnimationController _anim;
//   @override
//   void initState() {
//     super.initState();
//     accessCode = (Random().nextInt(900000) + 100000).toString();
//     _anim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     )..forward();
//   }

//   @override
//   void dispose() {
//     _anim.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//               child: Lottie.asset('assets/code_bg.json', fit: BoxFit.cover)),
//           // Soft focus ring for code zone
//           Positioned.fill(
//             child: IgnorePointer(
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: RadialGradient(
//                       colors: [
//                         Colors.cyanAccent.withOpacity(0.13),
//                         Colors.transparent
//                       ],
//                       center: Alignment.center,
//                       radius: 0.54,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Center(
//             child: FadeTransition(
//               opacity: _anim,
//               child: SlideTransition(
//                 position:
//                     Tween<Offset>(begin: const Offset(0, .18), end: Offset.zero)
//                         .animate(CurvedAnimation(
//                             parent: _anim, curve: Curves.easeOutExpo)),
//                 child: Container(
//                   width: 340,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(28),
//                     color: Colors.white.withOpacity(0.13),
//                     border: Border.all(
//                         color: Colors.cyanAccent.withOpacity(0.40), width: 1.3),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.cyanAccent.withOpacity(0.09),
//                           blurRadius: 34)
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Hero(
//                         tag: 'pay-anim',
//                         child:
//                             Lottie.asset('assets/code_anim.json', height: 70),
//                       ),
//                       const SizedBox(height: 14),
//                       ShaderMask(
//                         shaderCallback: (bounds) => const LinearGradient(
//                           colors: [Colors.cyanAccent, Colors.deepPurpleAccent],
//                         ).createShader(bounds),
//                         child: const Text(
//                           "Your Access Code",
//                           style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.w900,
//                               color: Colors.white),
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       TweenAnimationBuilder<double>(
//                         duration: const Duration(milliseconds: 700),
//                         tween: Tween(begin: 0.0, end: 1.0),
//                         curve: Curves.easeOut,
//                         builder: (context, value, child) => Opacity(
//                           opacity: value,
//                           child: Transform.scale(
//                             scale: 0.7 + value * 0.3,
//                             child: child,
//                           ),
//                         ),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 28, vertical: 13),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Colors.cyanAccent,
//                                 Colors.deepPurpleAccent
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.cyanAccent.withOpacity(0.13),
//                                 blurRadius: 13,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                           child: Text(
//                             accessCode,
//                             style: const TextStyle(
//                               fontSize: 34,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 8,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       SizedBox(
//                         width: 180,
//                         height: 45,
//                         child: ElevatedButton.icon(
//                           icon: const Icon(Icons.delivery_dining_rounded,
//                               color: Colors.white),
//                           label: const Text("Book Delivery",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 17)),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.cyanAccent,
//                             foregroundColor: Colors.deepPurple,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14)),
//                             elevation: 7,
//                           ),
//                           onPressed: () {
//                             Navigator.pushReplacementNamed(
//                                 context, '/bookdelivery',
//                                 arguments: accessCode);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AccessCodeScreen extends StatefulWidget {
  const AccessCodeScreen({super.key});
  @override
  State<AccessCodeScreen> createState() => _AccessCodeScreenState();
}

class _AccessCodeScreenState extends State<AccessCodeScreen>
    with SingleTickerProviderStateMixin {
  String? accessCode;
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    fetchAccessCode();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  // Future<void> fetchAccessCode() async {
  //   try {
  //     final response = await http.get(
  //       // Uri.parse('http://192.168.56.1:5005/get_code'),
  //       Uri.parse('http://10.0.2.2:5005/get_code'), // <-- use your Pi IP
  //     );
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         accessCode = jsonDecode(response.body)['code'];
  //       });
  //     } else {
  //       setState(() {
  //         accessCode = "ERROR";
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       accessCode = "ERROR";
  //     });
  //   }
  // }
  Future<void> fetchAccessCode() async {
  try {
    print('Fetching code...');
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5005/get_code'), // Use this for Android Emulator!
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print('Decoded: $decoded');
      setState(() {
        accessCode = decoded['code'];
      });
    } else {
      setState(() {
        accessCode = "ERROR";
      });
    }
  } catch (e) {
    print('Fetch error: $e');
    setState(() {
      accessCode = "ERROR";
    });
  }
}

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Lottie.asset('assets/code_bg.json', fit: BoxFit.cover)),
          Positioned.fill(
            child: IgnorePointer(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.cyanAccent.withOpacity(0.13),
                        Colors.transparent
                      ],
                      center: Alignment.center,
                      radius: 0.54,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _anim,
              child: SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, .18), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: _anim, curve: Curves.easeOutExpo)),
                child: Container(
                  width: 340,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.white.withOpacity(0.13),
                    border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.40), width: 1.3),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.09),
                          blurRadius: 34)
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: 'pay-anim',
                        child:
                            Lottie.asset('assets/code_anim.json', height: 70),
                      ),
                      const SizedBox(height: 14),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.cyanAccent, Colors.deepPurpleAccent],
                        ).createShader(bounds),
                        child: const Text(
                          "Your Access Code",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 18),
                      accessCode == null
                        ? const CircularProgressIndicator()
                        : accessCode == "ERROR"
                            ? const Text("Error fetching code", style: TextStyle(color: Colors.red, fontSize: 18))
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 13),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.cyanAccent,
                                      Colors.deepPurpleAccent
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.13),
                                      blurRadius: 13,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  accessCode!,
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 8,
                                  ),
                                ),
                              ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 180,
                        height: 45,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delivery_dining_rounded,
                              color: Colors.white),
                          label: const Text("Book Delivery",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            foregroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 7,
                          ),
                          onPressed: accessCode == null || accessCode == "ERROR"
                              ? null
                              : () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/bookdelivery',
                                    arguments: accessCode,
                                  );
                                },
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