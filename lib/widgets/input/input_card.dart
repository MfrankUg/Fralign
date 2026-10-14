import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../providers/fralign_provider.dart';

/// The main hero input card with text field, clear/fav actions, and Listen button.
class InputCard extends StatelessWidget {
  const InputCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FralignProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FralignSpacing.xl),
      padding: const EdgeInsets.all(FralignSpacing.xl),
      decoration: BoxDecoration(
        color: isDark ? FralignColors.surfaceDark : FralignColors.surfaceLight,
        borderRadius: BorderRadius.circular(FralignRadius.xl),
        border: isDark
            ? Border.all(color: FralignColors.borderDark.withValues(alpha: 0.5))
            : null,
        boxShadow: isDark ? FralignShadows.cardDark : FralignShadows.elevatedLight,
      ),
      child: Column(
        children: [
          // ── Text Input Row ──
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.textController,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? FralignColors.textPrimaryDark
                        : FralignColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a word...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FralignRadius.md),
                      borderSide: BorderSide(color: isDark ? FralignColors.borderDark : FralignColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FralignRadius.md),
                      borderSide: BorderSide(color: isDark ? FralignColors.borderDark : FralignColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FralignRadius.md),
                      borderSide: const BorderSide(
                        color: FralignColors.vibrantAmber,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? FralignColors.backgroundDark.withValues(alpha: 0.5)
                        : FralignColors.backgroundLight,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: FralignSpacing.lg,
                      vertical: FralignSpacing.lg,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.currentWord.isNotEmpty)
                          GestureDetector(
                            onTap: provider.clearInput,
                            child: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: isDark
                                  ? FralignColors.textTertiaryDark
                                  : FralignColors.textTertiaryLight,
                            ),
                          ),
                        const SizedBox(width: FralignSpacing.sm),
                        GestureDetector(
                          onTap: () {
                            if (provider.currentWord.isNotEmpty) {
                              provider.toggleFavorite(provider.currentWord);
                            }
                          },
                          child: Icon(
                            provider.isFavorite(provider.currentWord)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 22,
                            color: provider.isFavorite(provider.currentWord)
                                ? FralignColors.coralRed
                                : isDark
                                    ? FralignColors.textTertiaryDark
                                    : FralignColors.textTertiaryLight,
                          ),
                        ),
                        const SizedBox(width: FralignSpacing.md),
                      ],
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => provider.lookUpWord(),
                  onChanged: (_) {
                    // Trigger rebuild for clear/fav icons.
                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                    provider.notifyListeners();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: FralignSpacing.lg),

          // ── Listen Button ──
          SizedBox(
            width: double.infinity,
            child: AnimatedContainer(
              duration: FralignDurations.normal,
              child: ElevatedButton.icon(
                onPressed: provider.currentWord.isEmpty
                    ? null
                    : () {
                        if (provider.isSpeaking) {
                          provider.stopSpeaking();
                        } else {
                          provider.speak();
                          provider.lookUpWord();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FralignColors.coralRed,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      isDark ? FralignColors.surfaceDarkElevated : FralignColors.borderLight,
                  disabledForegroundColor:
                      isDark ? FralignColors.textTertiaryDark : FralignColors.textTertiaryLight,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: FralignSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(FralignRadius.md),
                  ),
                ),
                icon: Icon(
                  provider.isSpeaking
                      ? Icons.stop_rounded
                      : Icons.volume_up_rounded,
                  size: 22,
                ),
                label: Text(
                  provider.isSpeaking ? 'Stop' : 'Listen',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
