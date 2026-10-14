import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/theme/design_tokens.dart';
import '../widgets/header/fralign_header.dart';
import '../widgets/input/input_card.dart';
import '../widgets/speech/microphone_section.dart';
import '../widgets/dictionary/dictionary_card.dart';

/// Main home screen — the single-screen Fralign experience.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            const FralignHeader()
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.15, end: 0, duration: 400.ms),

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: FralignSpacing.xxxl),
                child: Column(
                  children: [
                    const SizedBox(height: FralignSpacing.lg),

                    // ── Input Card ──
                    const InputCard()
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 100.ms)
                        .slideY(begin: 0.1, end: 0, duration: 500.ms),

                    const SizedBox(height: FralignSpacing.xxxl),

                    // ── Microphone Section ──
                    const MicrophoneSection()
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms)
                        .scale(
                          begin: const Offset(0.85, 0.85),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),

                    const SizedBox(height: FralignSpacing.xxxl),

                    // ── Dictionary Card ──
                    const DictionaryCard()
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 300.ms)
                        .slideY(begin: 0.15, end: 0, duration: 500.ms),

                    const SizedBox(height: FralignSpacing.xxl),

                    // ── Footer ──
                    _Footer(isDark: isDark)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 500.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final bool isDark;
  const _Footer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FralignSpacing.lg),
      child: Text(
        'Fralign by Frank • v2.0',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isDark
              ? FralignColors.textTertiaryDark
              : FralignColors.textTertiaryLight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
