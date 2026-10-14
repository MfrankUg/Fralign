import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../providers/fralign_provider.dart';

/// Floating microphone button with animated audio ripple effect.
class MicrophoneSection extends StatefulWidget {
  const MicrophoneSection({super.key});

  @override
  State<MicrophoneSection> createState() => _MicrophoneSectionState();
}

class _MicrophoneSectionState extends State<MicrophoneSection>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _ripple1Controller;
  late final AnimationController _ripple2Controller;
  late final AnimationController _ripple3Controller;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _ripple1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _ripple2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _ripple3Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
  }

  void _startRipples() {
    _pulseController.repeat(reverse: true);
    _ripple1Controller.repeat();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ripple2Controller.repeat();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _ripple3Controller.repeat();
    });
  }

  void _stopRipples() {
    _pulseController.stop();
    _pulseController.reset();
    _ripple1Controller.stop();
    _ripple1Controller.reset();
    _ripple2Controller.stop();
    _ripple2Controller.reset();
    _ripple3Controller.stop();
    _ripple3Controller.reset();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ripple1Controller.dispose();
    _ripple2Controller.dispose();
    _ripple3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FralignProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.isListening) {
      _startRipples();
    } else {
      _stopRipples();
    }

    return Column(
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Ripple rings ──
              _RippleRing(controller: _ripple3Controller, size: 150),
              _RippleRing(controller: _ripple2Controller, size: 130),
              _RippleRing(controller: _ripple1Controller, size: 110),

              // ── Mic button ──
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = provider.isListening
                      ? 1.0 + (_pulseController.value * 0.08)
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    if (provider.isListening) {
                      provider.stopListening();
                    } else {
                      provider.startListening();
                    }
                  },
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: provider.isListening
                            ? [FralignColors.coralRedLight, FralignColors.coralRedDark]
                            : [FralignColors.coralRed, FralignColors.coralRedDark],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: FralignColors.coralRed.withValues(
                            alpha: provider.isListening ? 0.5 : 0.25,
                          ),
                          blurRadius: provider.isListening ? 28 : 16,
                          spreadRadius: provider.isListening ? 4 : 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      provider.isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: FralignSpacing.md),

        // ── Recognized text or hint ──
        AnimatedSwitcher(
          duration: FralignDurations.normal,
          child: provider.isListening && provider.recognizedText.isNotEmpty
              ? Text(
                  provider.recognizedText,
                  key: ValueKey(provider.recognizedText),
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: FralignColors.emeraldGreen,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  provider.isListening
                      ? 'Listening...'
                      : 'Tap to speak and get spelling',
                  key: ValueKey(provider.isListening),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? FralignColors.textTertiaryDark
                        : FralignColors.textTertiaryLight,
                  ),
                ),
        ),

        // ── Letter spelling result ──
        if (!provider.isListening && provider.letterSpelling.isNotEmpty) ...[
          const SizedBox(height: FralignSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FralignSpacing.lg,
              vertical: FralignSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: FralignColors.emeraldGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(FralignRadius.sm),
            ),
            child: Text(
              provider.letterSpelling,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: FralignColors.emeraldGreen,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}

/// Animated ripple ring that expands and fades out.
class _RippleRing extends StatelessWidget {
  final AnimationController controller;
  final double size;

  const _RippleRing({required this.controller, required this.size});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          width: size * (0.6 + controller.value * 0.4),
          height: size * (0.6 + controller.value * 0.4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: FralignColors.coralRed
                  .withValues(alpha: max(0, 0.3 - controller.value * 0.3)),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}
