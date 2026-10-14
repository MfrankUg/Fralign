import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../models/language_model.dart';
import '../../providers/fralign_provider.dart';

/// Top header bar with brand, language selector pill, and settings icon.
class FralignHeader extends StatelessWidget {
  const FralignHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FralignProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FralignSpacing.xl,
        vertical: FralignSpacing.md,
      ),
      child: Row(
        children: [
          // ── Brand Logo ──
          _BrandLogo(isDark: isDark),
          const Spacer(),
          // ── Language Pill ──
          _LanguagePill(
            language: provider.selectedLanguage,
            isDark: isDark,
            onTap: () => _showLanguageSheet(context),
          ),
          const SizedBox(width: FralignSpacing.md),
          // ── Settings ──
          _SettingsButton(
            isDark: isDark,
            onTap: () => _showSettingsSheet(context),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final provider = context.read<FralignProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? FralignColors.surfaceDark : FralignColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(FralignRadius.xxl)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: FralignSpacing.md),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? FralignColors.borderDark : FralignColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: FralignSpacing.xl),
              Text(
                'Select Language',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: FralignSpacing.lg),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: SupportedLanguages.all.length,
                  itemBuilder: (_, index) {
                    final lang = SupportedLanguages.all[index];
                    final isSelected = lang == provider.selectedLanguage;
                    return ListTile(
                      leading: Text(
                        lang.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(lang.name),
                      subtitle: Text(
                        lang.nativeName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: FralignColors.emeraldGreen,
                            )
                          : null,
                      onTap: () {
                        provider.setLanguage(lang);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: FralignSpacing.lg),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsSheet(BuildContext context) {
    final provider = context.read<FralignProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? FralignColors.surfaceDark : FralignColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(FralignRadius.xxl)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(FralignSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? FralignColors.borderDark : FralignColors.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: FralignSpacing.xl),
                    Text('Settings', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: FralignSpacing.xxl),

                    // Dark mode toggle
                    Row(
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: FralignColors.vibrantAmber,
                        ),
                        const SizedBox(width: FralignSpacing.md),
                        const Expanded(child: Text('Dark Mode')),
                        Switch.adaptive(
                          value: provider.themeMode == ThemeMode.dark,
                          activeColor: FralignColors.coralRed,
                          onChanged: (_) {
                            provider.toggleTheme();
                            setSheetState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: FralignSpacing.lg),

                    // Speech rate slider
                    Row(
                      children: [
                        const Icon(
                          Icons.speed_rounded,
                          color: FralignColors.emeraldGreen,
                        ),
                        const SizedBox(width: FralignSpacing.md),
                        const Expanded(child: Text('Speech Speed')),
                        Text(
                          provider.speechRate <= 0.3
                              ? '0.5×'
                              : provider.speechRate <= 0.6
                                  ? '1.0×'
                                  : '1.5×',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: FralignColors.coralRed,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: provider.speechRate,
                      min: 0.1,
                      max: 0.9,
                      divisions: 8,
                      activeColor: FralignColors.coralRed,
                      inactiveColor: isDark ? FralignColors.borderDark : FralignColors.borderLight,
                      onChanged: (val) {
                        provider.setSpeechRate(val);
                        setSheetState(() {});
                      },
                    ),
                    const SizedBox(height: FralignSpacing.lg),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Sub-widgets ──

class _BrandLogo extends StatelessWidget {
  final bool isDark;
  const _BrandLogo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Fralign',
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : FralignColors.textPrimaryLight,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 2),
        Icon(
          Icons.graphic_eq_rounded,
          size: 22,
          color: FralignColors.coralRed.withValues(alpha: 0.7),
        ),
      ],
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final AppLanguage language;
  final bool isDark;
  final VoidCallback onTap;

  const _LanguagePill({
    required this.language,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: FralignDurations.normal,
        padding: const EdgeInsets.symmetric(
          horizontal: FralignSpacing.md,
          vertical: FralignSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isDark ? FralignColors.surfaceDark : FralignColors.surfaceLight,
          borderRadius: BorderRadius.circular(FralignRadius.pill),
          border: Border.all(
            color: isDark ? FralignColors.borderDark : FralignColors.borderLight,
          ),
          boxShadow: isDark ? null : FralignShadows.cardLight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(language.flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: FralignSpacing.sm),
            Text(
              language.name,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? FralignColors.textPrimaryDark : FralignColors.textPrimaryLight,
              ),
            ),
            const SizedBox(width: FralignSpacing.xs),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: isDark ? FralignColors.textSecondaryDark : FralignColors.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _SettingsButton({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(FralignSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? FralignColors.surfaceDark : FralignColors.surfaceLight,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? FralignColors.borderDark : FralignColors.borderLight,
          ),
          boxShadow: isDark ? null : FralignShadows.cardLight,
        ),
        child: Icon(
          Icons.settings_rounded,
          size: 22,
          color: isDark ? FralignColors.textSecondaryDark : FralignColors.textSecondaryLight,
        ),
      ),
    );
  }
}
