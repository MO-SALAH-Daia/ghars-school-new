import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class GlobalConnectivityWidget extends StatefulWidget {
  final Widget child;
  const GlobalConnectivityWidget({super.key, required this.child});

  @override
  State<GlobalConnectivityWidget> createState() => _GlobalConnectivityWidgetState();
}

class _GlobalConnectivityWidgetState extends State<GlobalConnectivityWidget> {
  bool _isConnected = true;
  bool _showPill = false;
  bool _isFirstCheck = true;
  Timer? _hideTimer;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen(_handleConnectivityChange);
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    _handleConnectivityChange(results);
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (!mounted) return;
    
    final bool isCurrentlyOffline = results.every((r) => r == ConnectivityResult.none);
    
    if (_isFirstCheck) {
      _isFirstCheck = false;
      _isConnected = !isCurrentlyOffline;
      if (isCurrentlyOffline) {
        _showConnectivityPill(false);
      }
      return;
    }

    // Only show pill if state actually changed
    if (isCurrentlyOffline && _isConnected) {
      // Just went offline
      _isConnected = false;
      _showConnectivityPill(false);
    } else if (!isCurrentlyOffline && !_isConnected) {
      // Just came back online
      _isConnected = true;
      _showConnectivityPill(true);
    }
  }

  void _showConnectivityPill(bool isConnected) {
    setState(() {
      _showPill = true;
    });
    
    _hideTimer?.cancel();
    
    // If online, hide it after a few seconds. If offline, keep it visible!
    if (isConnected) {
      _hideTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _showPill = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.maybeOf(context) ?? TextDirection.rtl,
      child: Stack(
        children: [
          widget.child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                  transform: Matrix4.translationValues(0, _showPill ? -80.0 : 50.0, 0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: _showPill ? 1.0 : 0.0,
                    child: Center(
                      child: Material(
                        elevation: 8,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: _isConnected 
                                ? const Color(0xFF4CAF50).withValues(alpha: 0.75) 
                                : const Color(0xFF212121).withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isConnected ? Icons.wifi : Icons.wifi_off,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _isConnected ? 'عاد الاتصال' : 'أنت في وضع عدم الاتصال',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
