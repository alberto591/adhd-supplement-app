import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../utils/logger.dart';

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
        "notes": "Take with food for better absorption",
        "status": "beneficial"
      },
      {
        "id": "l-theanine",
        "name": "L-Theanine",
        "category": "Nootropic",
        "dosage": "200mg",
        "timeOfDay": "morning",
        "benefits": ["Calm Focus", "Anxiety Reduction"],
        "evidenceLevel": "moderate",
        "notes": "Synergizes well with caffeine",
        "status": "beneficial"
      },
      {
        "id": "magnesium",
        "name": "Magnesium Glycinate",
        "category": "Mineral",
        "dosage": "400mg",
        "timeOfDay": "evening",
        "benefits": ["Sleep", "Relaxation", "Muscle Recovery"],
        "evidenceLevel": "high",
        "notes": "Take before bed",
        "status": "beneficial"
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
            "Works best when combined with magnesium. Get blood levels tested.",
        "status": "beneficial"
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
            "Use standardized extract (24% bacosides). Takes 8-12 weeks for full effect.",
        "status": "beneficial"
      },
      {
        "id": "zinc",
        "name": "Zinc",
        "category": "Mineral",
        "dosage": "30-150mg",
        "timeOfDay": "any",
        "benefits": ["Impulse Control", "Attention", "Dopamine Metabolism"],
        "evidenceLevel": "moderate",
        "notes": "Most effective if deficient. Works better with Omega-3s.",
        "status": "beneficial"
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
            "Standardized extract (24% ginkgo flavone). Less effective for hyperactivity.",
        "status": "beneficial"
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
            "Only supplement if deficiency confirmed. Excess can be harmful.",
        "status": "beneficial"
      },
      {
        "id": "citicoline",
        "name": "Citicoline (CDP-Choline)",
        "category": "Nootropic",
        "dosage": "250-500mg",
        "timeOfDay": "morning",
        "benefits": ["Mental Clarity", "Sustained Attention", "Memory"],
        "evidenceLevel": "moderate",
        "notes": "Boosts brain energy. Minimal side effects.",
        "status": "beneficial"
      },
      {
        "id": "lions-mane",
        "name": "Lion's Mane Mushroom",
        "category": "Mushroom",
        "dosage": "500-1000mg",
        "timeOfDay": "morning",
        "benefits": ["Neuroplasticity", "Cognition", "Focus"],
        "evidenceLevel": "moderate",
        "notes": "Stimulates nerve growth factor (NGF).",
        "status": "beneficial"
      },
      {
        "id": "phosphatidylserine",
        "name": "Phosphatidylserine",
        "category": "Lipid",
        "dosage": "100-200mg",
        "timeOfDay": "any",
        "benefits": ["Memory Organization", "Attention", "Reasoning"],
        "evidenceLevel": "moderate",
        "notes": "Cell membrane support. Best from sunflower lecithin.",
        "status": "beneficial"
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
            "Standardized extract. Emerging evidence suggests high efficacy.",
        "status": "beneficial"
      },
      {
        "id": "pycnogenol",
        "name": "Pycnogenol (Pine Bark)",
        "category": "Antioxidant",
        "dosage": "1mg/kg",
        "timeOfDay": "morning",
        "benefits": ["Attention", "Antioxidant", "Blood Flow"],
        "evidenceLevel": "moderate",
        "notes": "Natural bioflavonoid. 12 weeks for full effect.",
        "status": "beneficial"
      },
      {
        "id": "probiotics",
        "name": "Probiotics (L. rhamnosus)",
        "category": "Probiotic",
        "dosage": "Strain Specific",
        "timeOfDay": "morning",
        "benefits": ["Gut-Brain Axis", "Emotional Functioning"],
        "evidenceLevel": "moderate",
        "notes": "Supports microbiome health and neurotransmitter synthesis.",
        "status": "beneficial"
      },
      {
        "id": "red-dye-40",
        "name": "Red Dye 40 (Allura Red)",
        "category": "Artificial Color",
        "description":
            "Synthetic food dye linked to hyperactivity in children with ADHD.",
        "sideEffects": ["Increased Hyperactivity", "Hypersensitivity"],
        "status": "avoid"
      },
      {
        "id": "high-fructose-corn-syrup",
        "name": "High Fructose Corn Syrup",
        "category": "Sweetener",
        "description":
            "High intake of refined sugars can lead to energy crashes and worsened ADHD symptoms.",
        "sideEffects": ["Brain Fog", "Energy Crashes", "Irritability"],
        "status": "avoid"
      },
      {
        "id": "sodium-benzoate",
        "name": "Sodium Benzoate",
        "category": "Preservative",
        "description":
            "Common preservative in soft drinks that may increase hyperactivity in some children.",
        "sideEffects": ["Hyperactivity", "Reduced Focus"],
        "status": "avoid"
      }
    ];

    try {
      AppLogger.i(
          'Starting seeding process for ${supplements.length} items...');
      final batch = _firestore.batch();

      for (var supplement in supplements) {
        final docRef = _firestore
            .collection('supplements')
            .doc(supplement['id'] as String);
        batch.set(docRef, supplement);
      }

      if (kDebugMode) {
        AppLogger.d('Committing seeding batch...');
      }
      await batch.commit();
      if (kDebugMode) {
        AppLogger.i('Successfully seeded ${supplements.length} supplements');
      }
    } catch (e) {
      AppLogger.e('CRITICAL FAILURE in SeedingService', e);
      if (kDebugMode) {
        AppLogger.e('Error seeding supplements', e);
      }
      rethrow;
    }
  }

  Future<void> createTestUser(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;

      // Check if user exists by trying to sign in
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        AppLogger.d('Test user already exists. Skipping creation.');
        return;
      } catch (e) {
        // User likely doesn't exist or wrong password
        AppLogger.d(
            'Test user not found or sign in failed. Attempting to create...');
      }

      // Create user
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'id': credential.user!.uid,
          'email': email,
          'displayName': 'Test User',
          'createdAt': FieldValue.serverTimestamp(),
          'hasCompletedOnboarding': true,
          'unlockedAchievements': <String>[],
        });
        AppLogger.i('Test user created successfully: $email');
      }
    } catch (e) {
      AppLogger.e('Failed to create test user', e);
      // Don't rethrow to avoid blocking app startup
    }
  }
}
