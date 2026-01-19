import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:adhd_supplement_app/domain/models/supplement.dart';
import 'package:adhd_supplement_app/application/view_models/supplement_view_model.dart';

class SupplementDetailView extends StatelessWidget {
  final Supplement supplement;

  const SupplementDetailView({super.key, required this.supplement});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SupplementViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(supplement.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supplement.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            _buildSection(context, 'Benefits', supplement.benefits),
            _buildSection(context, 'Side Effects', supplement.sideEffects),
            
            if (supplement.dosageInstruction.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Dosage',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(supplement.dosageInstruction),
            ],
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => viewModel.onReferralClicked(supplement),
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Buy on Amazon'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(child: Text(item)),
            ],
          ),
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}
