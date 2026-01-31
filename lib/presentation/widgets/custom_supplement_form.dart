import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';

typedef SupplementSaveCallback = Future<void> Function(
  String name,
  String category,
  String? dosage,
  String? timeOfDay,
  List<String> benefits,
  String? evidence,
  String? form,
);

class CustomSupplementForm extends StatefulWidget {
  final SupplementSaveCallback onSave;

  const CustomSupplementForm({super.key, required this.onSave});

  @override
  State<CustomSupplementForm> createState() => _CustomSupplementFormState();
}

class _CustomSupplementFormState extends State<CustomSupplementForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  late String _category;
  String? _dosage;
  final String _timeOfDay = 'Morning';
  final List<String> _benefits = [];
  final String _evidence = 'Moderate';
  final String _form = 'Capsule';

  @override
  void initState() {
    super.initState();
    _category = 'Vitamin'; // Still use internal keys for consistency
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Use a map for internal category keys to localized display names
    final categoryMap = {
      'Vitamin': l10n.catVitamin,
      'Mineral': l10n.catMineral,
      'Herbal': l10n.catHerbal,
      'Amino Acid': l10n.catAminoAcid,
      'Other': l10n.catOther,
    };

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundPremiumDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                l10n.addCustomSupplement,
                style: GoogleFonts.lexend(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: l10n.supplementName,
                hint: l10n.nameHint,
                onChanged: (v) => _name = v,
                validator: (v) => v?.isEmpty == true ? l10n.required : null,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: l10n.category,
                value: _category,
                items: categoryMap.keys.toList(),
                displayNames: categoryMap,
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: l10n.dosageOptional,
                hint: l10n.dosageHint,
                onChanged: (v) => _dosage = v,
              ),
              // Usual Timing field removed per user request
              const SizedBox(height: 24),
              // Safety checkbox removed
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n.saveSupplement,
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required void Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          style: GoogleFonts.lexend(),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Map<String, String> displayNames,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: items
              .map((e) =>
                  DropdownMenuItem(value: e, child: Text(displayNames[e] ?? e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() == true) {
      widget.onSave(
        _name,
        _category,
        _dosage,
        _timeOfDay,
        _benefits,
        _evidence,
        _form,
      );
      Navigator.pop(context);
    }
  }
}
