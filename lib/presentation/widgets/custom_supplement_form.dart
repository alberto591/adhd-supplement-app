import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

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
  String _category = 'Vitamin';
  String? _dosage;
  String? _timeOfDay = 'Morning';
  final List<String> _benefits = [];
  final String _evidence = 'Moderate';
  final String _form = 'Capsule';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                'Add Custom Supplement',
                style: GoogleFonts.lexend(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                label: 'Supplement Name',
                hint: 'e.g. Lion\'s Mane',
                onChanged: (v) => _name = v,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Category',
                value: _category,
                items: ['Vitamin', 'Mineral', 'Herbal', 'Amino Acid', 'Other'],
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Dosage (Optional)',
                hint: 'e.g. 500mg',
                onChanged: (v) => _dosage = v,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: 'Usual Timing',
                value: _timeOfDay,
                items: ['Morning', 'Afternoon', 'Evening', 'Night'],
                onChanged: (v) => setState(() => _timeOfDay = v),
              ),
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
                    'Save Supplement',
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
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
