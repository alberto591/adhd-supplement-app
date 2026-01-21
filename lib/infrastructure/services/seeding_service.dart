import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SeedingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedSupplements() async {
    final List<Map<String, dynamic>> supplements = [
      {
        "id": "omega-3",
        "name": "Omega-3 Fish Oil",
        "category": "Essential Fatty Acids",
        "dosage": "1000mg",
        "timeOfDay": "morning",
        "benefits": ["Focus", "Brain Health", "Mood"],
        "evidenceLevel": "high",
        "notes": "Take with food for better absorption"
      },
      {
        "id": "l-theanine",
        "name": "L-Theanine",
        "category": "Nootropic",
        "dosage": "200mg",
        "timeOfDay": "morning",
        "benefits": ["Calm Focus", "Anxiety Reduction"],
        "evidenceLevel": "moderate",
        "notes": "Synergizes well with caffeine"
      },
      {
        "id": "magnesium",
        "name": "Magnesium Glycinate",
        "category": "Mineral",
        "dosage": "400mg",
        "timeOfDay": "evening",
        "benefits": ["Sleep", "Relaxation", "Muscle Recovery"],
        "evidenceLevel": "high",
        "notes": "Take before bed"
      },
      {
        "id": "vitamin-d",
        "name": "Vitamin D3",
        "category": "Vitamin",
        "dosage": "2000-4000 IU",
        "timeOfDay": "morning",
        "benefits": [
          "Executive Function",
          "Impulse Control",
          "Neurotransmitter Synthesis"
        ],
        "evidenceLevel": "high",
        "notes":
            "Works best when combined with magnesium. Get blood levels tested."
      },
      {
        "id": "bacopa-monnieri",
        "name": "Bacopa Monnieri",
        "category": "Herb",
        "dosage": "150-225mg",
        "timeOfDay": "morning",
        "benefits": ["Memory", "Anxiety Reduction", "Self-Control"],
        "evidenceLevel": "high",
        "notes":
            "Use standardized extract (24% bacosides). Takes 8-12 weeks for full effect."
      },
      {
        "id": "zinc",
        "name": "Zinc",
        "category": "Mineral",
        "dosage": "30-150mg",
        "timeOfDay": "any",
        "benefits": ["Impulse Control", "Attention", "Dopamine Metabolism"],
        "evidenceLevel": "moderate",
        "notes": "Most effective if deficient. Works better with Omega-3s."
      },
      {
        "id": "ginkgo-biloba",
        "name": "Ginkgo Biloba",
        "category": "Herb",
        "dosage": "240mg",
        "timeOfDay": "morning",
        "benefits": ["Inattention Reduction", "Blood Flow", "Concentration"],
        "evidenceLevel": "moderate",
        "notes":
            "Standardized extract (24% ginkgo flavone). Less effective for hyperactivity."
      },
      {
        "id": "iron",
        "name": "Iron",
        "category": "Mineral",
        "dosage": "10-80mg",
        "timeOfDay": "any",
        "benefits": ["Dopamine Synthesis", "Brain Energy"],
        "evidenceLevel": "moderate",
        "notes":
            "Only supplement if deficiency confirmed. Excess can be harmful."
      },
      {
        "id": "citicoline",
        "name": "Citicoline (CDP-Choline)",
        "category": "Nootropic",
        "dosage": "250-500mg",
        "timeOfDay": "morning",
        "benefits": ["Mental Clarity", "Sustained Attention", "Memory"],
        "evidenceLevel": "moderate",
        "notes": "Boosts brain energy. Minimal side effects."
      },
      {
        "id": "lions-mane",
        "name": "Lion's Mane Mushroom",
        "category": "Mushroom",
        "dosage": "500-1000mg",
        "timeOfDay": "morning",
        "benefits": ["Neuroplasticity", "Cognition", "Focus"],
        "evidenceLevel": "moderate",
        "notes": "Stimulates nerve growth factor (NGF)."
      },
      {
        "id": "phosphatidylserine",
        "name": "Phosphatidylserine",
        "category": "Lipid",
        "dosage": "100-200mg",
        "timeOfDay": "any",
        "benefits": ["Memory Organization", "Attention", "Reasoning"],
        "evidenceLevel": "moderate",
        "notes": "Cell membrane support. Best from sunflower lecithin."
      },
      {
        "id": "saffron",
        "name": "Saffron (Crocus Sativus)",
        "category": "Herb",
        "dosage": "30mg",
        "timeOfDay": "morning",
        "benefits": ["Hyperactivity Reduction", "Mood", "Dopamine Support"],
        "evidenceLevel": "promising",
        "notes":
            "Standardized extract. Emerging evidence suggests high efficacy."
      },
      {
        "id": "pycnogenol",
        "name": "Pycnogenol (Pine Bark)",
        "category": "Antioxidant",
        "dosage": "1mg/kg",
        "timeOfDay": "morning",
        "benefits": ["Attention", "Antioxidant", "Blood Flow"],
        "evidenceLevel": "moderate",
        "notes": "Natural bioflavonoid. 12 weeks for full effect."
      },
      {
        "id": "probiotics",
        "name": "Probiotics (L. rhamnosus)",
        "category": "Probiotic",
        "dosage": "Strain Specific",
        "timeOfDay": "morning",
        "benefits": ["Gut-Brain Axis", "Emotional Functioning"],
        "evidenceLevel": "moderate",
        "notes": "Supports microbiome health and neurotransmitter synthesis."
      }
    ];

    try {
      debugPrint('Starting seeding process for ${supplements.length} items...');
      final batch = _firestore.batch();

      for (var supplement in supplements) {
        debugPrint('Adding to batch: ${supplement['name']}');
        final docRef = _firestore
            .collection('supplements')
            .doc(supplement['id'] as String);
        batch.set(docRef, supplement);
      }

      debugPrint('Committing batch...');
      await batch.commit();
      debugPrint('Batch committed successfully!');

      if (kDebugMode) {
        debugPrint('Successfully seeded ${supplements.length} supplements');
      }
    } catch (e) {
      debugPrint('CRITICAL FAILURE in SeedingService: $e');
      if (kDebugMode) {
        debugPrint('Error seeding supplements: $e');
      }
      rethrow;
    }
  }
}
