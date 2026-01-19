import 'package:flutter/foundation.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/supplement_repository.dart';

class MockSupplementRepository implements SupplementRepository {
  @override
  Future<List<Supplement>> getAllSupplements() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate net lag
    return [
      Supplement(
        id: '1',
        name: 'Omega-3 (EPA/DHA)',
        description:
            'Essential fatty acids that may improve attention and reduce hyperactivity symptoms.',
        referralUrl: 'https://example.com/omega3',
        benefits: [
          'Improves focus',
          'Supports brain health',
          'Reduces inflammation'
        ],
        dosage: '1000mg daily with food',
        sideEffects: ['Fishy aftertaste', 'Mild stomach upset'],
        focusLevel: 4,
      ),
      Supplement(
        id: '2',
        name: 'Magnesium Glycinate',
        description:
            'Helps with relaxation, sleep quality, and calming restlessness.',
        referralUrl: 'https://example.com/magnesium',
        benefits: ['Reduces hyperactivity', 'Improves sleep', 'Calms anxiety'],
        dosage: '200mg before bed',
        sideEffects: ['Drowsiness'],
        focusLevel: 3,
      ),
      Supplement(
        id: '3',
        name: 'L-Theanine',
        description:
            'An amino acid found in tea that promotes calm focus without drowsiness.',
        referralUrl: 'https://example.com/ltheanine',
        benefits: [
          'Calm alertness',
          'Reduces stress',
          'Pairs well with caffeine'
        ],
        dosage: '100-200mg as needed',
        sideEffects: [],
        focusLevel: 5,
      ),
      Supplement(
        id: '4',
        name: 'Zinc',
        description: 'Essential mineral that supports dopamine regulation.',
        referralUrl: 'https://example.com/zinc',
        benefits: ['Supports attention', 'Dopamine regulation'],
        dosage: '15-30mg daily with food',
        sideEffects: ['Nausea if taken on empty stomach'],
        focusLevel: 3,
      ),
    ];
  }

  @override
  Future<Supplement?> getSupplementById(String id) async => null;

  @override
  Future<void> trackReferralClick(String supplementId) async {
    // In production, this would write to Firestore
    // In a real app, this would log to analytics
    debugPrint('Tracked referral click for: $supplementId');
  }
}
