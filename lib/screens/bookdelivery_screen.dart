// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lottie/lottie.dart';

// class BookDeliveryScreen extends StatefulWidget {
//   const BookDeliveryScreen({super.key});

//   @override
//   State<BookDeliveryScreen> createState() => _BookDeliveryScreenState();
// }

// class _BookDeliveryScreenState extends State<BookDeliveryScreen> {
//   final _codeC = TextEditingController();
//   bool _loading = false;
//   String? _status;
//   bool? _success;

//   Future<void> _submitCode(String code) async {
//     setState(() {
//       _loading = true;
//       _status = null;
//       _success = null;
//     });

//     try {
//       // Replace with your Pi's local IP and port
//       final response = await http.post(
//         Uri.parse('http://<YOUR_PI_IP>:5005/verify'), // Or whatever endpoint you expose
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'code': code}),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == 'ok') {
//           setState(() {
//             _success = true;
//             _status = 'Access Granted! Robot will deliver your order.';
//           });
//         } else {
//           setState(() {
//             _success = false;
//             _status = 'Access Denied! Invalid access code.';
//           });
//         }
//       } else {
//         setState(() {
//           _success = false;
//           _status = 'Connection error. Try again!';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _success = false;
//         _status = 'Network error. Try again!';
//       });
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _codeC.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String? generatedCode = ModalRoute.of(context)?.settings.arguments as String?;
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(child: Lottie.asset('assets/delivery_bg.json', fit: BoxFit.cover)),
//           Center(
//             child: Card(
//               color: Colors.white.withOpacity(0.12),
//               elevation: 12,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//               child: Padding(
//                 padding: const EdgeInsets.all(36),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Lottie.asset('assets/delivery_anim.json', height: 120),
//                     const SizedBox(height: 12),
//                     const Text(
//                       "Enter Access Code",
//                       style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     TextField(
//                       controller: _codeC,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         hintText: "Access Code",
//                         prefixIcon: Icon(Icons.lock_open_rounded, color: Colors.white70),
//                         hintStyle: TextStyle(color: Colors.white54),
//                       ),
//                       style: const TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                     const SizedBox(height: 10),
//                     if (_status != null)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         child: AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 500),
//                           child: _success == true
//                               ? Lottie.asset('assets/success.json', height: 60, key: const ValueKey('success'))
//                               : Lottie.asset('assets/denied.json', height: 60, key: const ValueKey('denied')),
//                         ),
//                       ),
//                     if (_status != null)
//                       Text(
//                         _status!,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: _success == true ? Colors.greenAccent : Colors.redAccent,
//                           fontWeight: FontWeight.w700,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     const SizedBox(height: 22),
//                     SizedBox(
//                       width: 160,
//                       child: ElevatedButton(
//                         onPressed: _loading
//                             ? null
//                             : () => _submitCode(_codeC.text.trim()),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.purpleAccent,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                           elevation: 8,
//                           padding: const EdgeInsets.symmetric(vertical: 13),
//                         ),
//                         child: _loading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : const Text("Submit", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                     if (generatedCode != null)
//                       TextButton(
//                         onPressed: () => _codeC.text = generatedCode,
//                         child: const Text(
//                           "Paste Received Code",
//                           style: TextStyle(color: Colors.white60, fontSize: 15, decoration: TextDecoration.underline),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }import 'dart:convert';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class BookDeliveryScreen extends StatefulWidget {
  const BookDeliveryScreen({super.key});
  @override
  State<BookDeliveryScreen> createState() => _BookDeliveryScreenState();
}

class _BookDeliveryScreenState extends State<BookDeliveryScreen> with SingleTickerProviderStateMixin {
  final _codeC = TextEditingController();
  bool _loading = false;
  String? _status;
  bool? _success;
  late AnimationController _slideController;
  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
  }
  Future<void> _submitCode(String code) async {
    setState(() {
      _loading = true;
      _status = null;
      _success = null;
    });
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5005/verify'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            _success = true;
            _status = 'Access Granted! Robot will deliver your order.';
          });
          _slideController.forward(from: 0.0);
        } else {
          setState(() {
            _success = false;
            _status = 'Access Denied! Invalid access code.';
          });
          _slideController.forward(from: 0.0);
        }
      } else {
        setState(() {
          _success = false;
          _status = 'Connection error. Try again!';
        });
        _slideController.forward(from: 0.0);
      }
    } catch (e) {
      setState(() {
        _success = false;
        _status = 'Network error. Try again!';
      });
      _slideController.forward(from: 0.0);
    } finally {
      setState(() => _loading = false);
    }
  }
  @override
  void dispose() {
    _codeC.dispose();
    _slideController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final String? generatedCode = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Lottie.asset('assets/delivery_bg.json', fit: BoxFit.cover)),
          // Subtle blurred radial behind card for pop
          Positioned.fill(
            child: IgnorePointer(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.deepPurple.withOpacity(0.2),
                        Colors.transparent
                      ],
                      radius: 0.65,
                      center: Alignment(0, -.08),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Sliding status panel
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic)),
              child: _status != null
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Material(
                        color: _success == true
                            ? Colors.greenAccent.shade400.withOpacity(0.94)
                            : Colors.redAccent.shade400.withOpacity(0.97),
                        elevation: 18,
                        borderRadius: BorderRadius.circular(22),
                        child: SizedBox(
                          width: 360,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 14),
                              _success == true
                                  ? Lottie.asset('assets/success.json', height: 50)
                                  : Lottie.asset('assets/denied.json', height: 50),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                child: Text(
                                  _status!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _status = null;
                                    _success = null;
                                  });
                                },
                                child: const Text("Dismiss", style: TextStyle(color: Colors.deepPurple)),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                // Layered glass effect: dark base, gradient, border, shadow
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.deepPurple.shade900.withOpacity(0.32),
                    Colors.deepPurpleAccent.withOpacity(0.22)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.deepPurpleAccent.withOpacity(0.55),
                  width: 1.7,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.16),
                    blurRadius: 38,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/delivery_anim.json', height: 78, repeat: true),
                  const SizedBox(height: 10),
                  Text(
                    "Enter Access Code",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                      shadows: [
                        Shadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.22),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _codeC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Access Code",
                      prefixIcon: const Icon(Icons.lock_open_rounded, color: Colors.cyanAccent),
                      hintStyle: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w500),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: 180,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent.shade400,
                        foregroundColor: Colors.deepPurple,
                        shadowColor: Colors.cyanAccent.withOpacity(0.41),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 10,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      icon: const Icon(Icons.send_rounded, color: Colors.deepPurpleAccent, size: 26),
                      label: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.deepPurpleAccent,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              "Submit",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                            ),
                      onPressed: _loading ? null : () => _submitCode(_codeC.text.trim()),
                    ),
                  ),
                  if (generatedCode != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton(
                        onPressed: () => _codeC.text = generatedCode,
                        child: const Text(
                          "Paste Received Code",
                          style: TextStyle(color: Colors.cyanAccent, fontSize: 15, decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}