import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../models/dictionary_model.dart';
import '../../providers/fralign_provider.dart';

/// Expandable dictionary card with tabs: Definition, Phonetics, Synonyms.
class DictionaryCard extends StatelessWidget {
  const DictionaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FralignProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Loading state
    if (provider.isLoadingDefinition) {
      return _CardShell(
        isDark: isDark,
        child: const Padding(
          padding: EdgeInsets.all(FralignSpacing.xxl),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: FralignColors.coralRed,
              ),
            ),
          ),
        ),
      );
    }

    // No entry
    final entry = provider.dictionaryEntry;
    if (entry == null) {
      return const SizedBox.shrink();
    }

    return _CardShell(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drag handle ──
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: FralignSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? FralignColors.borderDark : FralignColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: FralignSpacing.lg),

          // ── Tab bar ──
          _DictionaryTabs(isDark: isDark),
          const SizedBox(height: FralignSpacing.lg),

          // ── Tab content ──
          AnimatedSwitcher(
            duration: FralignDurations.normal,
            child: _buildTabContent(context, provider, entry, isDark),
          ),

          const SizedBox(height: FralignSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    FralignProvider provider,
    DictionaryEntry entry,
    bool isDark,
  ) {
    switch (provider.dictionaryTabIndex) {
      case 0:
        return _DefinitionTab(key: const ValueKey('def'), entry: entry, isDark: isDark);
      case 1:
        return _PhoneticsTab(key: const ValueKey('phon'), entry: entry, isDark: isDark);
      case 2:
        return _SynonymsTab(key: const ValueKey('syn'), entry: entry, isDark: isDark);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Card Shell ──
class _CardShell extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const _CardShell({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FralignSpacing.xl),
      decoration: BoxDecoration(
        color: isDark ? FralignColors.surfaceDark : FralignColors.surfaceLight,
        borderRadius: BorderRadius.circular(FralignRadius.xl),
        border: isDark
            ? Border.all(color: FralignColors.borderDark.withValues(alpha: 0.5))
            : null,
        boxShadow: isDark ? FralignShadows.cardDark : FralignShadows.elevatedLight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FralignSpacing.xl),
        child: child,
      ),
    );
  }
}

// ── Tab Selector ──
class _DictionaryTabs extends StatelessWidget {
  final bool isDark;
  const _DictionaryTabs({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FralignProvider>();
    const tabs = ['📖  Definition', '🗣️  Phonetics', '💡  Synonyms'];

    return Row(
      children: List.generate(tabs.length, (i) {
        final isActive = provider.dictionaryTabIndex == i;
        return Expanded(
          child: GestureDetector(
            onTap: () => provider.setDictionaryTab(i),
            child: AnimatedContainer(
              duration: FralignDurations.fast,
              padding: const EdgeInsets.symmetric(vertical: FralignSpacing.sm),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive
                        ? FralignColors.emeraldGreen
                        : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Text(
                tabs[i],
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? (isDark ? FralignColors.textPrimaryDark : FralignColors.textPrimaryLight)
                      : (isDark ? FralignColors.textTertiaryDark : FralignColors.textTertiaryLight),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Definition Tab ──
class _DefinitionTab extends StatelessWidget {
  final DictionaryEntry entry;
  final bool isDark;

  const _DefinitionTab({super.key, required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<FralignProvider>();
    final meaning = entry.meanings.isNotEmpty ? entry.meanings.first : null;
    final def = meaning?.definitions.isNotEmpty == true
        ? meaning!.definitions.first
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phonetic + POS + play
        Row(
          children: [
            if (entry.bestPhonetic.isNotEmpty)
              Text(
                entry.bestPhonetic,
                style: GoogleFonts.notoSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: FralignColors.emeraldGreen,
                ),
              ),
            const SizedBox(width: FralignSpacing.sm),
            if (meaning != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FralignSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: FralignColors.vibrantAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(FralignRadius.sm),
                ),
                child: Text(
                  meaning.partOfSpeech,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: FralignColors.vibrantAmber,
                  ),
                ),
              ),
            const Spacer(),
            GestureDetector(
              onTap: () => provider.speak(),
              child: Container(
                padding: const EdgeInsets.all(FralignSpacing.sm),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? FralignColors.surfaceDarkElevated
                      : FralignColors.backgroundLight,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: FralignColors.coralRed,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: FralignSpacing.md),

        // Definition text
        if (def != null) ...[
          Text(
            def.definition,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (def.example != null) ...[
            const SizedBox(height: FralignSpacing.sm),
            Text(
              '"${def.example!}"',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: isDark
                    ? FralignColors.textSecondaryDark
                    : FralignColors.textSecondaryLight,
              ),
            ),
          ],
        ] else
          Text(
            'No definition available.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark
                  ? FralignColors.textTertiaryDark
                  : FralignColors.textTertiaryLight,
            ),
          ),
      ],
    );
  }
}

// ── Phonetics Tab ──
class _PhoneticsTab extends StatelessWidget {
  final DictionaryEntry entry;
  final bool isDark;

  const _PhoneticsTab({super.key, required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (entry.phonetics.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: FralignSpacing.lg),
        child: Text(
          'No phonetic data available.',
          style: GoogleFonts.inter(
            color: isDark
                ? FralignColors.textTertiaryDark
                : FralignColors.textTertiaryLight,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IPA display
        if (entry.bestPhonetic.isNotEmpty) ...[
          Text(
            'IPA Notation',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? FralignColors.textSecondaryDark : FralignColors.textSecondaryLight,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FralignSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FralignSpacing.lg,
              vertical: FralignSpacing.md,
            ),
            decoration: BoxDecoration(
              color: FralignColors.emeraldGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(FralignRadius.md),
              border: Border.all(
                color: FralignColors.emeraldGreen.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              entry.bestPhonetic,
              style: GoogleFonts.notoSans(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: FralignColors.emeraldGreen,
              ),
            ),
          ),
        ],
        const SizedBox(height: FralignSpacing.lg),

        // Syllable breakdown
        Text(
          'Syllable Breakdown',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? FralignColors.textSecondaryDark : FralignColors.textSecondaryLight,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: FralignSpacing.sm),
        Wrap(
          spacing: FralignSpacing.sm,
          children: _syllables(entry.word).map((syl) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FralignSpacing.md,
                vertical: FralignSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isDark ? FralignColors.surfaceDarkElevated : FralignColors.backgroundLight,
                borderRadius: BorderRadius.circular(FralignRadius.sm),
                border: Border.all(
                  color: isDark ? FralignColors.borderDark : FralignColors.borderLight,
                ),
              ),
              child: Text(
                syl,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),

        // All phonetic variants
        if (entry.phonetics.length > 1) ...[
          const SizedBox(height: FralignSpacing.lg),
          Text(
            'Variants',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? FralignColors.textSecondaryDark : FralignColors.textSecondaryLight,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FralignSpacing.sm),
          ...entry.phonetics.where((p) => p.text != null && p.text!.isNotEmpty).map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: FralignSpacing.xs),
              child: Text(
                p.text!,
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  color: isDark
                      ? FralignColors.textSecondaryDark
                      : FralignColors.textSecondaryLight,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Simple heuristic syllable split for display.
  List<String> _syllables(String word) {
    if (word.length <= 3) return [word];
    final List<String> result = [];
    final vowels = {'a', 'e', 'i', 'o', 'u'};
    String current = '';
    bool prevVowel = false;

    for (int i = 0; i < word.length; i++) {
      current += word[i];
      final isVowel = vowels.contains(word[i].toLowerCase());

      if (prevVowel && !isVowel && current.length > 1 && i < word.length - 1) {
        result.add(current);
        current = '';
      }
      prevVowel = isVowel;
    }
    if (current.isNotEmpty) {
      if (result.isNotEmpty && current.length == 1) {
        result[result.length - 1] += current;
      } else {
        result.add(current);
      }
    }
    return result.isEmpty ? [word] : result;
  }
}

// ── Synonyms Tab ──
class _SynonymsTab extends StatelessWidget {
  final DictionaryEntry entry;
  final bool isDark;

  const _SynonymsTab({super.key, required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final synonyms = entry.allSynonyms;
    if (synonyms.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: FralignSpacing.lg),
        child: Text(
          'No synonyms found.',
          style: GoogleFonts.inter(
            color: isDark
                ? FralignColors.textTertiaryDark
                : FralignColors.textTertiaryLight,
          ),
        ),
      );
    }

    return Wrap(
      spacing: FralignSpacing.sm,
      runSpacing: FralignSpacing.sm,
      children: synonyms.take(15).map((syn) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FralignSpacing.md,
            vertical: FralignSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: FralignColors.coralRed.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(FralignRadius.pill),
            border: Border.all(
              color: FralignColors.coralRed.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            syn,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? FralignColors.coralRedLight
                  : FralignColors.coralRedDark,
            ),
          ),
        );
      }).toList(),
    );
  }
}
