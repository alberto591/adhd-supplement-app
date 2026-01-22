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
        "status": "beneficial",
        "mechanismOfAction":
            "Increases cell membrane permeability, enhances dopamine receptor density, and reduces neuroinflammation.",
        "detailedBenefits": [
          "Improves working memory by 15% in clinical trials",
          "Reduces impulsivity and emotional dysregulation",
          "Supports long-term neuroprotection"
        ],
        "timingRationale":
            "Fat-soluble nutrients require dietary fat for absorption. Taking with the largest meal (often breakfast or dinner) ensures maximum uptake.",
        "scientificEvidenceRank": 92,
        "studyLinks": {
          "Omega-3 fatty acids for ADHD":
              "https://pubmed.ncbi.nlm.nih.gov/21961774/",
          "EPA vs DHA efficacy comparision":
              "https://pubmed.ncbi.nlm.nih.gov/31336652/"
        },
        "dosageByWeight": {
          "40-60": "500-1000mg",
          "60-80": "1000-2000mg",
          "80-100": "2000-3000mg",
          "100-120": "3000-4000mg"
        },
        "dosageFrequency": "Take once daily with a fatty meal",
        "dosageWarnings": [
          "Consult physician if taking anti-coagulants (blood thinners)",
          "Stop taking 2 weeks before scheduled surgeries",
          "High doses (>3g) may increase bleeding risk in some individuals"
        ],
        "tldr":
            "Essential fatty acids that improve dopamine receptor density and reduce brain inflammation.",
        "adhdMedInteractions": {
          "Adderall":
              "Omega-3 supports the dopamine system and may enhance the long-term effectiveness of stimulant medications.",
          "Vyvanse":
              "Supports brain health and helps smooth out potential side effects of stimulants.",
          "Ritalin":
              "Helps maintain cell membrane health vital for proper neurotransmitter transport."
        }
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
        "status": "beneficial",
        "mechanismOfAction":
            "Increases alpha brain wave activity (associated with relaxed alertness) and boosts GABA levels without sedation.",
        "detailedBenefits": [
          "Reduces jitteriness from stimulant medications",
          "Improves selective attention during stressful tasks",
          "Promotes relaxation without drowsiness"
        ],
        "timingRationale":
            "Best taken 30-60 minutes before focus work. Its half-life is ~3 hours, so re-dosing might be needed for long days.",
        "scientificEvidenceRank": 78,
        "studyLinks": {
          "L-theanine and caffeine synergy":
              "https://pubmed.ncbi.nlm.nih.gov/18681988/",
          "Effects on stress and cognition":
              "https://pubmed.ncbi.nlm.nih.gov/31623400/"
        },
        "adhdMedInteractions": {
          "Adderall":
              "L-Theanine can help mitigate stimulant-induced jitteriness and anxiety without reducing focus.",
          "Vyvanse":
              "Synergistic effect: promotes calm focus and may smooth out the offset 'crash' of long-acting stimulants.",
          "Ritalin":
              "Reduces irritability and helps with wind-down at the end of the day."
        },
        "tldr":
            "Promotes 'calm focus' by increasing alpha brain waves and smoothing out stimulant side effects."
      },
      {
        "id": "magnesium",
        "name": "Magnesium Glycinate",
        "category": "Mineral",
        "dosage": "200mg",
        "timeOfDay": "evening",
        "benefits": ["Sleep Quality", "Muscle Relaxation", "Stress Reduction"],
        "evidenceLevel": "high",
        "notes":
            "Glycinate form preferred for better absorption and minimal GI side effects",
        "status": "beneficial",
        "mechanismOfAction":
            "Acts as a natural NMDA receptor antagonist, promoting GABA activity and regulating the HPA axis. Glycinate form has superior bioavailability (80-90%) and minimal GI side effects compared to oxide or citrate forms.",
        "detailedBenefits": [
          "Improves sleep latency by 17 minutes in clinical trials",
          "Reduces cortisol levels and anxiety symptoms by 30%",
          "Supports healthy dopamine regulation and prevents stimulant tolerance",
          "Reduces muscle tension and physical restlessness"
        ],
        "timingRationale":
            "Evening dosing supports natural melatonin production and muscle relaxation before sleep. Glycinate's calming effect makes it ideal for bedtime, 1-2 hours before sleep for optimal absorption.",
        "scientificEvidenceRank": 88,
        "studyLinks": {
          "Magnesium supplementation for ADHD":
              "https://pubmed.ncbi.nlm.nih.gov/24065783/",
          "Sleep quality improvement":
              "https://pubmed.ncbi.nlm.nih.gov/23853635/",
          "Magnesium and stress reduction":
              "https://pubmed.ncbi.nlm.nih.gov/28654669/"
        },
        "dosageByWeight": {
          "40-60": "150mg",
          "60-80": "200mg",
          "80-100": "300mg",
          "100-120": "400mg"
        },
        "dosageFrequency": "Once daily, preferably 1-2 hours before bed",
        "dosageWarnings": [
          "Start with 100mg to assess tolerance",
          "High doses (>400mg) may cause digestive discomfort",
          "Consult physician if you have kidney disease or impaired renal function",
          "Take 4+ hours after stimulant medication for optimal absorption"
        ],
        "tldr":
            "Highly bioavailable magnesium that improves sleep quality and reduces anxiety without morning grogginess.",
        "adhdMedInteractions": {
          "Adderall":
              "May help reduce muscle tension and improve sleep quality disrupted by stimulants. Take 4+ hours after medication to avoid absorption interference.",
          "Vyvanse":
              "Supports relaxation during evening comedown from long-acting stimulants. Helps prevent magnesium depletion from chronic stimulant use.",
          "Ritalin":
              "No significant interaction; beneficial for sleep support and reducing evening irritability."
        },
        "contraindications": [
          "People with kidney disease or impaired renal function",
          "Those taking magnesium-containing antacids concurrently",
          "Individuals with myasthenia gravis"
        ],
        "sideEffects": [
          "Loose stools if dose exceeds tolerance (typically >500mg)",
          "Rare: mild drowsiness if taken during the day",
          "Very rare: nausea if taken on empty stomach"
        ]
      },
      {
        "id": "vitamin-d",
        "name": "Vitamin D3",
        "category": "Vitamin",
        "dosage": "2000 IU",
        "timeOfDay": "morning",
        "benefits": ["Executive Function", "Impulse Control", "Mood Stability"],
        "evidenceLevel": "high",
        "notes":
            "Works synergistically with magnesium. Get blood levels tested (optimal: 40-60 ng/mL).",
        "status": "beneficial",
        "mechanismOfAction":
            "Acts as a neurosteroid hormone regulating synthesis of serotonin and dopamine via tyrosine hydroxylase activation. Crucial for nerve growth factor (NGF) and brain-derived neurotrophic factor (BDNF) production.",
        "detailedBenefits": [
          "Correcting deficiency can improve attention scores by 25-30%",
          "Supports overall mood stability and seasonal resilience (especially winter)",
          "Enhances structural neuroplasticity and synaptic function",
          "Reduces inflammation linked to ADHD symptoms"
        ],
        "timingRationale":
            "Vitamin D can suppress melatonin production, so it should be taken in the morning with a fatty meal to align with circadian rhythm and maximize absorption (fat-soluble vitamin).",
        "scientificEvidenceRank": 90,
        "studyLinks": {
          "Vitamin D and ADHD symptoms":
              "https://pubmed.ncbi.nlm.nih.gov/29457224/",
          "Neurosteroid effects of Vitamin D":
              "https://pubmed.ncbi.nlm.nih.gov/28582844/",
          "Vitamin D deficiency in ADHD children":
              "https://pubmed.ncbi.nlm.nih.gov/30415156/"
        },
        "dosageByWeight": {
          "40-60": "1000-2000 IU",
          "60-80": "2000-3000 IU",
          "80-100": "3000-4000 IU",
          "100-120": "4000-5000 IU"
        },
        "dosageFrequency":
            "Once daily with a fatty meal (breakfast recommended)",
        "dosageWarnings": [
          "Get blood levels tested before supplementing (test 25-OH Vitamin D)",
          "Do not exceed 10,000 IU daily without medical supervision",
          "High doses (>5000 IU) require monitoring for hypercalcemia",
          "Always take with vitamin K2 if dosing above 4000 IU to prevent calcium dysregulation"
        ],
        "tldr":
            "Essential neurosteroid that regulates dopamine and serotonin; deficiency strongly linked to ADHD symptoms.",
        "adhdMedInteractions": {
          "Adderall":
              "Vitamin D supports dopamine synthesis pathways, potentially enhancing long-term medication effectiveness. No direct interaction.",
          "Vyvanse":
              "May improve mood stability and reduce seasonal effectiveness variations. Take in morning with medication.",
          "Ritalin":
              "Supports overall neurotransmitter health. No contraindications; synergistic for cognitive function."
        },
        "contraindications": [
          "People with hypercalcemia or hyperparathyroidism",
          "Those with sarcoidosis or other granulomatous diseases",
          "Individuals taking high-dose calcium supplements without medical guidance"
        ],
        "sideEffects": [
          "Rare: nausea or constipation at very high doses (>10,000 IU)",
          "Hypercalcemia symptoms if overdosed (fatigue, confusion, excessive thirst)",
          "Generally well-tolerated at recommended doses"
        ]
      },
      {
        "id": "bacopa-monnieri",
        "name": "Bacopa Monnieri",
        "category": "Herb",
        "dosage": "300mg",
        "timeOfDay": "morning",
        "benefits": [
          "Memory Enhancement",
          "Anxiety Reduction",
          "Learning Speed"
        ],
        "evidenceLevel": "high",
        "notes":
            "Use standardized extract (50% bacosides). Takes 8-12 weeks for full cognitive benefits.",
        "status": "beneficial",
        "mechanismOfAction":
            "Enhances dendritic branching and synaptic communication through bacosides A and B. Modulates serotonin and dopamine while reducing cortisol. Acts as an adaptogen to buffer stress-induced cognitive decline.",
        "detailedBenefits": [
          "Improves memory consolidation and recall by 20-30% after 12 weeks",
          "Reduces anxiety without sedation (comparable to lorazepam in studies)",
          "Enhances learning speed and information processing",
          "Neuroprotective effects against oxidative stress"
        ],
        "timingRationale":
            "Morning dosing allows cumulative effects to build throughout the day. Effects are delayed (8-12 weeks) but long-lasting. Take with food to enhance absorption of fat-soluble bacosides.",
        "scientificEvidenceRank": 85,
        "studyLinks": {
          "Bacopa for cognitive enhancement":
              "https://pubmed.ncbi.nlm.nih.gov/23772955/",
          "Memory improvement in healthy adults":
              "https://pubmed.ncbi.nlm.nih.gov/18611150/",
          "Bacopa and ADHD symptoms":
              "https://pubmed.ncbi.nlm.nih.gov/24252493/"
        },
        "dosageByWeight": {
          "40-60": "200-300mg",
          "60-80": "300mg",
          "80-100": "300-450mg",
          "100-120": "450mg"
        },
        "dosageFrequency":
            "Once or twice daily with food (morning, or split AM/PM)",
        "dosageWarnings": [
          "Takes 8-12 weeks for full effects - be patient",
          "May cause mild GI upset initially (take with food)",
          "Avoid if you have bradycardia (slow heart rate)",
          "May interact with thyroid medications - consult physician"
        ],
        "tldr":
            "Ayurvedic herb that enhances memory and learning while reducing anxiety; requires 8-12 weeks for full benefits.",
        "adhdMedInteractions": {
          "Adderall":
              "Complementary for memory and learning. Bacopa's anxiolytic effects may help with stimulant-induced anxiety. No contraindications.",
          "Vyvanse":
              "May enhance cognitive benefits of medication while reducing stress. Safe combination for most users.",
          "Ritalin":
              "Synergistic for learning and memory tasks. Bacopa's calming effects balance stimulant activation."
        },
        "contraindications": [
          "People with bradycardia or heart rhythm disorders",
          "Those taking thyroid hormone medications (may alter levels)",
          "Individuals with urinary tract obstructions",
          "Pregnant or breastfeeding women (insufficient safety data)"
        ],
        "sideEffects": [
          "Mild GI upset or nausea (5-10% of users, usually resolves)",
          "Rare: fatigue or increased bowel movements",
          "Very rare: dry mouth or muscle fatigue",
          "Generally well-tolerated with food"
        ]
      },
      {
        "id": "zinc",
        "name": "Zinc (Picolinate or Glycinate)",
        "category": "Mineral",
        "dosage": "15mg",
        "timeOfDay": "any",
        "benefits": ["Impulse Control", "Attention", "Dopamine Metabolism"],
        "evidenceLevel": "moderate",
        "notes":
            "Most effective if deficient. Picolinate or glycinate forms preferred for absorption. Works synergistically with Omega-3s.",
        "status": "beneficial",
        "mechanismOfAction":
            "Essential cofactor for dopamine transporter (DAT) regulation and tyrosine hydroxylase activity. Modulates NMDA receptors and supports melatonin synthesis. Critical for over 300 enzymatic reactions.",
        "detailedBenefits": [
          "Reduces hyperactivity and impulsivity in zinc-deficient individuals by 30%",
          "Enhances the effectiveness of stimulant medications (lower doses may be needed)",
          "Supports immune function and gut health (important for ADHD comorbidities)",
          "Improves sleep quality through melatonin regulation"
        ],
        "timingRationale":
            "Can cause nausea on an empty stomach. Take with a solid meal, preferably lunch or dinner. Avoid taking with calcium or iron supplements (competes for absorption).",
        "scientificEvidenceRank": 78,
        "studyLinks": {
          "Zinc sulfate in ADHD treatment":
              "https://pubmed.ncbi.nlm.nih.gov/14687872/",
          "Zinc co-treatment with stimulants":
              "https://pubmed.ncbi.nlm.nih.gov/21309642/",
          "Zinc deficiency and ADHD":
              "https://pubmed.ncbi.nlm.nih.gov/21545780/"
        },
        "dosageByWeight": {
          "40-60": "10-15mg",
          "60-80": "15-20mg",
          "80-100": "20-30mg",
          "100-120": "30-40mg"
        },
        "dosageFrequency": "Once daily with food (lunch or dinner)",
        "dosageWarnings": [
          "Do not exceed 40mg daily without medical supervision",
          "Long-term use (>50mg) can cause copper deficiency - supplement copper if needed",
          "Get serum zinc levels tested before supplementing (optimal: 80-120 μg/dL)",
          "Take 2+ hours apart from calcium, iron, or antibiotics"
        ],
        "tldr":
            "Essential mineral for dopamine regulation; deficiency common in ADHD and reduces medication effectiveness.",
        "adhdMedInteractions": {
          "Adderall":
              "Zinc enhances dopamine transporter function, potentially allowing for lower stimulant doses. May improve medication response in zinc-deficient individuals.",
          "Vyvanse":
              "Supports dopamine metabolism and may reduce tolerance development. Synergistic effect for impulse control.",
          "Ritalin":
              "Improves methylphenidate response in children with low zinc levels. Consider testing before supplementing."
        },
        "contraindications": [
          "People with Wilson's disease (copper metabolism disorder)",
          "Those taking penicillamine or other copper-chelating drugs",
          "Individuals with chronic kidney disease (without medical supervision)"
        ],
        "sideEffects": [
          "Nausea if taken on empty stomach (common)",
          "Metallic taste in mouth (occasional)",
          "Copper deficiency if high doses used long-term (>50mg for months)",
          "Rare: stomach cramps or diarrhea"
        ]
      },
      {
        "id": "ginkgo-biloba",
        "name": "Ginkgo Biloba",
        "category": "Herb",
        "dosage": "120mg",
        "timeOfDay": "morning",
        "benefits": ["Cerebral Blood Flow", "Concentration", "Mental Clarity"],
        "evidenceLevel": "moderate",
        "notes":
            "Use standardized extract (24% ginkgo flavonoids, 6% terpene lactones). More effective for inattentive type ADHD.",
        "status": "beneficial",
        "mechanismOfAction":
            "Increases cerebral blood flow and oxygen delivery to the brain. Acts as a potent antioxidant (flavonoids) and platelet-activating factor (PAF) antagonist. Modulates neurotransmitter systems including dopamine and norepinephrine.",
        "detailedBenefits": [
          "Improves attention and concentration in inattentive-type ADHD",
          "Enhances cerebral blood flow by 15-20%",
          "Reduces mental fatigue and brain fog",
          "Antioxidant neuroprotection against age-related cognitive decline"
        ],
        "timingRationale":
            "Morning dosing aligns with peak cognitive demands. Takes 4-6 weeks for noticeable cognitive benefits. Split dosing (AM/PM) may improve consistency of effects.",
        "scientificEvidenceRank": 72,
        "studyLinks": {
          "Ginkgo for ADHD symptoms":
              "https://pubmed.ncbi.nlm.nih.gov/11386498/",
          "Cognitive enhancement in healthy adults":
              "https://pubmed.ncbi.nlm.nih.gov/20590480/",
          "Cerebral blood flow effects":
              "https://pubmed.ncbi.nlm.nih.gov/12605619/"
        },
        "dosageByWeight": {
          "40-60": "120mg",
          "60-80": "120-240mg",
          "80-100": "240mg",
          "100-120": "240mg"
        },
        "dosageFrequency":
            "Once or twice daily with food (morning, or split AM/PM)",
        "dosageWarnings": [
          "AVOID if taking blood thinners (warfarin, aspirin, etc.) - increases bleeding risk",
          "Stop 2 weeks before surgery due to anticoagulant effects",
          "May cause headaches at higher doses (>240mg)",
          "Avoid if you have bleeding disorders or seizure history"
        ],
        "tldr":
            "Ancient herb that boosts cerebral blood flow and concentration; particularly effective for inattentive-type ADHD.",
        "adhdMedInteractions": {
          "Adderall":
              "May enhance focus benefits through improved cerebral circulation. Monitor for headaches. No direct contraindications.",
          "Vyvanse":
              "Complementary for sustained attention. Ginkgo's blood flow benefits may support medication effectiveness.",
          "Ritalin":
              "Safe combination. May help with concentration and reduce mental fatigue during medication offset."
        },
        "contraindications": [
          "People taking anticoagulants (warfarin, heparin, aspirin)",
          "Those with bleeding disorders or scheduled for surgery",
          "Individuals with seizure disorders (may lower seizure threshold)",
          "Pregnant or breastfeeding women"
        ],
        "sideEffects": [
          "Mild headache (5-10% of users, usually dose-dependent)",
          "GI upset or nausea if taken on empty stomach",
          "Rare: dizziness or allergic skin reactions",
          "Very rare: increased bleeding or bruising (stop immediately)"
        ]
      },
      {
        "id": "iron",
        "name": "Iron (Ferrous Bisglycinate)",
        "category": "Mineral",
        "dosage": "18mg",
        "timeOfDay": "any",
        "benefits": [
          "Dopamine Synthesis",
          "Oxygen Transport",
          "Energy Production"
        ],
        "evidenceLevel": "high",
        "notes":
            "⚠️ ONLY supplement if blood test confirms deficiency (ferritin <30 ng/mL). Excess iron is toxic. Bisglycinate form preferred for absorption and minimal GI upset.",
        "status": "beneficial",
        "mechanismOfAction":
            "Essential cofactor for tyrosine hydroxylase (rate-limiting enzyme in dopamine synthesis). Critical for oxygen transport via hemoglobin and myoglobin. Supports mitochondrial energy production and neurotransmitter metabolism.",
        "detailedBenefits": [
          "Correcting deficiency improves ADHD symptoms by 30-40%",
          "Supports dopamine and norepinephrine production",
          "Enhances cognitive function and reduces fatigue",
          "Improves response to stimulant medications in deficient individuals"
        ],
        "timingRationale":
            "Take on empty stomach for best absorption, or with vitamin C to enhance uptake. Avoid taking with calcium, coffee, or tea (reduces absorption). Evening dosing may reduce GI upset.",
        "scientificEvidenceRank": 82,
        "studyLinks": {
          "Iron deficiency and ADHD":
              "https://pubmed.ncbi.nlm.nih.gov/22664333/",
          "Iron supplementation effects":
              "https://pubmed.ncbi.nlm.nih.gov/18275431/",
          "Ferritin levels in ADHD children":
              "https://pubmed.ncbi.nlm.nih.gov/15687461/"
        },
        "dosageByWeight": {
          "40-60": "10-18mg",
          "60-80": "18-27mg",
          "80-100": "27-45mg",
          "100-120": "45-65mg"
        },
        "dosageFrequency": "Once daily on empty stomach or with vitamin C",
        "dosageWarnings": [
          "⚠️ CRITICAL: Get blood test (serum ferritin) before supplementing",
          "Do NOT supplement if ferritin >30 ng/mL (excess iron is toxic)",
          "Keep out of reach of children (iron poisoning risk)",
          "Retest ferritin every 3 months while supplementing",
          "Stop if experiencing constipation, nausea, or dark stools"
        ],
        "tldr":
            "Essential for dopamine synthesis; ONLY supplement if blood test confirms deficiency (excess iron is harmful).",
        "adhdMedInteractions": {
          "Adderall":
              "Iron deficiency reduces medication effectiveness. Correcting deficiency may allow for lower stimulant doses. Take iron 2+ hours apart from medication.",
          "Vyvanse":
              "Low iron impairs dopamine synthesis needed for medication to work. Supplementation improves response in deficient individuals.",
          "Ritalin":
              "Iron is critical for dopamine pathways. Deficiency linked to poor medication response. Always test before supplementing."
        },
        "contraindications": [
          "People with hemochromatosis or iron overload disorders",
          "Those with normal or high ferritin levels (>30 ng/mL)",
          "Individuals with inflammatory bowel disease (without medical supervision)",
          "Anyone not tested for iron deficiency"
        ],
        "sideEffects": [
          "Common: constipation, dark stools, mild nausea",
          "Reduce dose or switch to bisglycinate form if GI upset occurs",
          "Rare: severe nausea or vomiting (stop immediately)",
          "Overdose risk: keep away from children"
        ]
      },
      {
        "id": "citicoline",
        "name": "Citicoline (CDP-Choline)",
        "category": "Nootropic",
        "dosage": "250mg",
        "timeOfDay": "morning",
        "benefits": ["Mental Clarity", "Sustained Attention", "Memory"],
        "evidenceLevel": "high",
        "notes":
            "Cognizin® brand is most researched. Boosts brain energy with minimal side effects.",
        "status": "beneficial",
        "mechanismOfAction":
            "Precursor to both acetylcholine (learning/memory) and phosphatidylcholine (cell membrane repair). Increases dopamine receptor density and enhances mitochondrial ATP production in the brain.",
        "detailedBenefits": [
          "Improves sustained attention and focus by 15-20% in clinical trials",
          "Enhances working memory and processing speed",
          "Supports brain energy metabolism and reduces mental fatigue",
          "Neuroprotective effects against oxidative stress"
        ],
        "timingRationale":
            "Morning dosing aligns with peak cognitive demands. Can be taken with or without food. Effects are cumulative over 4-6 weeks, with acute benefits within 1-2 hours.",
        "scientificEvidenceRank": 82,
        "studyLinks": {
          "Citicoline for attention and focus":
              "https://pubmed.ncbi.nlm.nih.gov/26179181/",
          "CDP-Choline and dopamine release":
              "https://pubmed.ncbi.nlm.nih.gov/18816480/",
          "Cognitive enhancement in adolescents":
              "https://pubmed.ncbi.nlm.nih.gov/25933483/"
        },
        "dosageByWeight": {
          "40-60": "200-250mg",
          "60-80": "250-300mg",
          "80-100": "300-500mg",
          "100-120": "500mg"
        },
        "dosageFrequency":
            "Once or twice daily (morning, or morning + early afternoon)",
        "dosageWarnings": [
          "Start with 250mg to assess tolerance",
          "Doses above 500mg may cause headaches in some individuals",
          "Take earlier in the day if it affects sleep (rare)",
          "Generally well-tolerated with minimal side effects"
        ],
        "tldr":
            "Premium nootropic that boosts brain energy, dopamine, and acetylcholine for sustained focus and mental clarity.",
        "adhdMedInteractions": {
          "Adderall":
              "Synergistic for cognitive enhancement. Citicoline supports dopamine pathways and may reduce tolerance development. No contraindications.",
          "Vyvanse":
              "Complements stimulant effects by supporting acetylcholine (learning) and brain energy. May enhance working memory benefits.",
          "Ritalin":
              "Safe combination. Citicoline provides neuroprotection and supports long-term cognitive health alongside stimulant use."
        },
        "contraindications": [
          "People with bipolar disorder (may trigger manic episodes in rare cases)",
          "Those taking anticholinergic medications",
          "Pregnant or breastfeeding women (insufficient safety data)"
        ],
        "sideEffects": [
          "Rare: mild headache (usually resolves with lower dose)",
          "Occasional: digestive upset if taken on empty stomach",
          "Very rare: insomnia if taken late in the day",
          "Generally one of the safest nootropics available"
        ]
      },
      {
        "id": "lions-mane",
        "name": "Lion's Mane Mushroom",
        "category": "Mushroom",
        "dosage": "1000mg",
        "timeOfDay": "morning",
        "benefits": ["Neurogenesis", "Cognitive Function", "Neuroprotection"],
        "evidenceLevel": "moderate",
        "notes":
            "Stimulates nerve growth factor (NGF) and brain-derived neurotrophic factor (BDNF). Effects build over 4-8 weeks.",
        "status": "beneficial",
        "mechanismOfAction":
            "Stimulates synthesis of nerve growth factor (NGF) and BDNF through hericenones and erinacines. Promotes neurogenesis, myelination, and synaptic plasticity. Supports hippocampal function critical for memory.",
        "detailedBenefits": [
          "Enhances neuroplasticity and cognitive flexibility",
          "Supports focus and mental clarity without stimulation",
          "Neuroprotective against cognitive decline",
          "May improve mood and reduce anxiety through NGF pathways"
        ],
        "timingRationale":
            "Morning dosing supports daytime cognitive function. Effects are cumulative over 4-8 weeks. Can be taken with or without food, though absorption may be enhanced with fats.",
        "scientificEvidenceRank": 70,
        "studyLinks": {
          "Lion's Mane and cognitive function":
              "https://pubmed.ncbi.nlm.nih.gov/31881712/",
          "NGF stimulation effects":
              "https://pubmed.ncbi.nlm.nih.gov/23510212/",
          "Neuroprotective properties":
              "https://pubmed.ncbi.nlm.nih.gov/24266378/"
        },
        "dosageByWeight": {
          "40-60": "500-1000mg",
          "60-80": "1000mg",
          "80-100": "1000-1500mg",
          "100-120": "1500-2000mg"
        },
        "dosageFrequency":
            "Once or twice daily with food (morning, or split AM/PM)",
        "dosageWarnings": [
          "Start with 500mg to assess tolerance",
          "Effects are cumulative - allow 4-8 weeks for full benefits",
          "May cause mild GI upset initially (take with food)",
          "Consult physician if you have mushroom allergies"
        ],
        "tldr":
            "Medicinal mushroom that stimulates nerve growth factor for enhanced neuroplasticity and cognitive function.",
        "adhdMedInteractions": {
          "Adderall":
              "Complementary for cognitive enhancement and neuroprotection. Lion's Mane supports brain health alongside stimulant use. No contraindications.",
          "Vyvanse":
              "May enhance long-term cognitive benefits and support neuroplasticity. Safe combination.",
          "Ritalin":
              "Synergistic for focus and mental clarity. Lion's Mane provides neuroprotective benefits during chronic stimulant use."
        },
        "contraindications": [
          "People with mushroom allergies (rare but possible)",
          "Those with bleeding disorders (theoretical risk, monitor)",
          "Pregnant or breastfeeding women (insufficient safety data)"
        ],
        "sideEffects": [
          "Rare: mild GI upset or skin rash (allergic reaction)",
          "Very rare: respiratory difficulty (stop immediately if occurs)",
          "Generally well-tolerated with minimal side effects"
        ]
      },
      {
        "id": "phosphatidylserine",
        "name": "Phosphatidylserine (PS)",
        "category": "Lipid",
        "dosage": "100mg",
        "timeOfDay": "any",
        "benefits": ["Working Memory", "Attention", "Cognitive Processing"],
        "evidenceLevel": "high",
        "notes":
            "Phospholipid essential for cell membrane function. Soy-free (sunflower-derived) preferred for allergen concerns.",
        "status": "beneficial",
        "mechanismOfAction":
            "Critical phospholipid component of neuronal cell membranes. Supports neurotransmitter receptor function, particularly acetylcholine. Modulates cortisol response and supports healthy HPA axis function. Enhances glucose metabolism in the brain.",
        "detailedBenefits": [
          "Improves working memory and information processing by 15-20%",
          "Enhances attention and reduces distractibility in ADHD",
          "Reduces cortisol levels and stress-induced cognitive impairment",
          "Supports age-related cognitive maintenance"
        ],
        "timingRationale":
            "Can be taken any time of day with food for optimal absorption (fat-soluble). Some prefer evening dosing for cortisol-lowering effects, but morning works well for cognitive support.",
        "scientificEvidenceRank": 80,
        "studyLinks": {
          "Phosphatidylserine for ADHD":
              "https://pubmed.ncbi.nlm.nih.gov/24424348/",
          "Cognitive function improvement":
              "https://pubmed.ncbi.nlm.nih.gov/25933483/",
          "Cortisol modulation effects":
              "https://pubmed.ncbi.nlm.nih.gov/18296328/"
        },
        "dosageByWeight": {
          "40-60": "100mg",
          "60-80": "100-200mg",
          "80-100": "200-300mg",
          "100-120": "300mg"
        },
        "dosageFrequency":
            "Once or twice daily with fatty meals (morning and/or evening)",
        "dosageWarnings": [
          "Start with 100mg to assess tolerance",
          "Take with food containing fat for optimal absorption",
          "May cause mild insomnia if taken late (rare)",
          "Choose sunflower-derived PS if you have soy allergies"
        ],
        "tldr":
            "Essential brain phospholipid that enhances working memory, attention, and stress resilience in ADHD.",
        "adhdMedInteractions": {
          "Adderall":
              "Synergistic for cognitive function. PS supports cell membrane health critical for neurotransmitter signaling. May reduce cortisol elevation from stimulants.",
          "Vyvanse":
              "Complementary for working memory and attention. PS may help buffer stress response during medication use.",
          "Ritalin":
              "Safe combination. PS supports the cellular mechanisms that stimulants rely on for effectiveness."
        },
        "contraindications": [
          "People with soy allergies (use sunflower-derived PS)",
          "Those taking anticholinergic medications (theoretical interaction)",
          "Pregnant or breastfeeding women (insufficient safety data)"
        ],
        "sideEffects": [
          "Rare: mild GI upset or insomnia (if taken late)",
          "Very rare: headache at high doses (>300mg)",
          "Generally well-tolerated with minimal side effects"
        ]
      },
      {
        "id": "saffron",
        "name": "Saffron (Crocus Sativus)",
        "category": "Herb",
        "dosage": "30mg",
        "timeOfDay": "morning",
        "benefits": ["Impulsivity Reduction", "Mood Stability", "Attention"],
        "evidenceLevel": "moderate",
        "notes":
            "Use standardized extract (safranal 2%, crocin 30%). Emerging evidence shows comparable efficacy to methylphenidate in some studies.",
        "status": "beneficial",
        "mechanismOfAction":
            "Modulates serotonin, dopamine, and norepinephrine through crocin and safranal compounds. Acts as a mild NMDA receptor antagonist and enhances BDNF expression. Anti-inflammatory effects support neuronal health.",
        "detailedBenefits": [
          "Reduces impulsivity and hyperactivity comparable to low-dose methylphenidate",
          "Improves mood and reduces anxiety without sedation",
          "Enhances attention span and reduces distractibility",
          "Neuroprotective and anti-inflammatory properties"
        ],
        "timingRationale":
            "Morning dosing aligns with peak symptom periods. Effects build over 6-8 weeks. Can be taken with or without food, though absorption may be enhanced with fats.",
        "scientificEvidenceRank": 68,
        "studyLinks": {
          "Saffron vs methylphenidate for ADHD":
              "https://pubmed.ncbi.nlm.nih.gov/30895760/",
          "Saffron for ADHD symptoms":
              "https://pubmed.ncbi.nlm.nih.gov/31453656/",
          "Mood and cognitive effects":
              "https://pubmed.ncbi.nlm.nih.gov/28527220/"
        },
        "dosageByWeight": {
          "40-60": "15-30mg",
          "60-80": "30mg",
          "80-100": "30mg",
          "100-120": "30mg"
        },
        "dosageFrequency": "Once or twice daily (morning, or split AM/PM)",
        "dosageWarnings": [
          "Do not exceed 30mg daily (higher doses may cause side effects)",
          "Takes 6-8 weeks for full therapeutic effects",
          "Avoid during pregnancy (may stimulate uterine contractions)",
          "May interact with blood pressure medications"
        ],
        "tldr":
            "Emerging ADHD treatment with mood-stabilizing effects; some studies show efficacy comparable to low-dose stimulants.",
        "adhdMedInteractions": {
          "Adderall":
              "May provide complementary mood support. No known contraindications, but monitor for additive effects on mood.",
          "Vyvanse":
              "Saffron's mood-stabilizing effects may complement stimulant therapy. Safe combination for most users.",
          "Ritalin":
              "Some studies suggest saffron alone has comparable efficacy to low-dose methylphenidate. Can be used together under medical supervision."
        },
        "contraindications": [
          "Pregnant or breastfeeding women (may cause uterine contractions)",
          "People with bipolar disorder (may trigger manic episodes)",
          "Those taking blood pressure medications (may enhance effects)",
          "Individuals with bleeding disorders (theoretical risk)"
        ],
        "sideEffects": [
          "Rare: mild nausea or headache at higher doses (>30mg)",
          "Very rare: dizziness or dry mouth",
          "Generally well-tolerated at recommended doses",
          "No significant side effects in most clinical trials"
        ]
      },
      {
        "id": "pycnogenol",
        "name": "Pycnogenol (Pine Bark Extract)",
        "category": "Antioxidant",
        "dosage": "1mg/kg",
        "timeOfDay": "morning",
        "benefits": [
          "Attention",
          "Hyperactivity Reduction",
          "Oxidative Stress"
        ],
        "evidenceLevel": "moderate",
        "notes":
            "Standardized French maritime pine bark extract. Requires 8-12 weeks for full cognitive benefits.",
        "status": "beneficial",
        "mechanismOfAction":
            "Potent antioxidant containing proanthocyanidins that cross the blood-brain barrier. Enhances nitric oxide production for improved cerebral blood flow. Modulates dopamine and norepinephrine metabolism while reducing oxidative stress.",
        "detailedBenefits": [
          "Reduces hyperactivity and improves attention by 20-30% in clinical trials",
          "Enhances antioxidant capacity and reduces neuroinflammation",
          "Improves concentration and visual-motor coordination",
          "May reduce need for stimulant medication in some cases"
        ],
        "timingRationale":
            "Morning dosing supports daytime cognitive function. Effects are cumulative over 8-12 weeks. Take with food to enhance absorption and reduce GI upset.",
        "scientificEvidenceRank": 75,
        "studyLinks": {
          "Pycnogenol for ADHD in children":
              "https://pubmed.ncbi.nlm.nih.gov/16499493/",
          "Attention and hyperactivity improvement":
              "https://pubmed.ncbi.nlm.nih.gov/17063641/",
          "Antioxidant effects on cognition":
              "https://pubmed.ncbi.nlm.nih.gov/22214254/"
        },
        "dosageByWeight": {
          "40-60": "40-60mg",
          "60-80": "60-80mg",
          "80-100": "80-100mg",
          "100-120": "100-120mg"
        },
        "dosageFrequency":
            "Once or twice daily with food (morning, or split AM/PM)",
        "dosageWarnings": [
          "Calculate dose as 1mg per kg of body weight",
          "Takes 8-12 weeks for full therapeutic effects",
          "May enhance effects of blood thinners (monitor if on anticoagulants)",
          "Start with half dose to assess tolerance"
        ],
        "tldr":
            "Powerful antioxidant from pine bark that reduces hyperactivity and improves attention through enhanced blood flow.",
        "adhdMedInteractions": {
          "Adderall":
              "Complementary antioxidant support. May help reduce oxidative stress from chronic stimulant use. No contraindications.",
          "Vyvanse":
              "Synergistic for attention and focus. Pycnogenol's blood flow benefits may enhance medication effectiveness.",
          "Ritalin":
              "Some studies suggest Pycnogenol may reduce need for medication in mild cases. Can be used together safely."
        },
        "contraindications": [
          "People taking blood thinners (may enhance anticoagulant effects)",
          "Those with autoimmune conditions (may stimulate immune system)",
          "Individuals scheduled for surgery (stop 2 weeks prior)",
          "Pregnant or breastfeeding women (insufficient safety data)"
        ],
        "sideEffects": [
          "Rare: mild GI upset, nausea, or headache",
          "Very rare: dizziness or mouth ulcers",
          "Generally well-tolerated with minimal side effects",
          "No serious adverse events in clinical trials"
        ]
      },
      {
        "id": "probiotics",
        "name": "Probiotics (Multi-Strain)",
        "category": "Probiotic",
        "dosage": "10-20 billion CFU",
        "timeOfDay": "morning",
        "benefits": ["Gut-Brain Axis", "Mood Regulation", "Immune Support"],
        "evidenceLevel": "moderate",
        "notes":
            "Focus on Lactobacillus and Bifidobacterium strains. Supports microbiome diversity and neurotransmitter production (serotonin, GABA, dopamine).",
        "status": "beneficial",
        "mechanismOfAction":
            "Modulates gut-brain axis through vagus nerve signaling and neurotransmitter production. Beneficial bacteria produce GABA, serotonin precursors, and short-chain fatty acids that influence brain function. Reduces inflammation and supports immune regulation.",
        "detailedBenefits": [
          "Improves mood and reduces anxiety through gut-brain communication",
          "Supports production of neurotransmitters (90% of serotonin made in gut)",
          "Reduces inflammation linked to ADHD symptoms",
          "Enhances nutrient absorption critical for brain health"
        ],
        "timingRationale":
            "Morning dosing on empty stomach (30 min before food) maximizes survival through stomach acid. Consistent daily use builds healthy microbiome over 4-8 weeks.",
        "scientificEvidenceRank": 65,
        "studyLinks": {
          "Probiotics and ADHD symptoms":
              "https://pubmed.ncbi.nlm.nih.gov/31665527/",
          "Gut-brain axis in neurodevelopment":
              "https://pubmed.ncbi.nlm.nih.gov/30356668/",
          "Microbiome and mental health":
              "https://pubmed.ncbi.nlm.nih.gov/31758907/"
        },
        "dosageByWeight": {
          "40-60": "10 billion CFU",
          "60-80": "15 billion CFU",
          "80-100": "20 billion CFU",
          "100-120": "25 billion CFU"
        },
        "dosageFrequency":
            "Once daily on empty stomach (30 min before breakfast)",
        "dosageWarnings": [
          "Start with lower dose (5 billion CFU) to assess tolerance",
          "May cause temporary bloating or gas (usually resolves in 1-2 weeks)",
          "Refrigerate to maintain potency (check product requirements)",
          "Choose multi-strain formulas with Lactobacillus and Bifidobacterium"
        ],
        "tldr":
            "Beneficial bacteria that support gut-brain communication, mood regulation, and neurotransmitter production.",
        "adhdMedInteractions": {
          "Adderall":
              "Supports gut health which may be affected by stimulants. Probiotics help maintain healthy digestion and nutrient absorption. No contraindications.",
          "Vyvanse":
              "May help with GI side effects common with stimulants. Supports overall health and neurotransmitter balance.",
          "Ritalin":
              "Complementary for gut health and mood support. Safe combination with no known interactions."
        },
        "contraindications": [
          "People with severely compromised immune systems (consult physician)",
          "Those with central venous catheters or serious illness",
          "Individuals with short bowel syndrome (rare risk of infection)",
          "Generally safe for most people"
        ],
        "sideEffects": [
          "Common initially: mild bloating, gas, or digestive changes (1-2 weeks)",
          "Rare: allergic reaction to specific strains",
          "Very rare: infection in immunocompromised individuals",
          "Generally well-tolerated with minimal side effects"
        ]
      },
      {
        "id": "red-dye-40",
        "name": "Red Dye 40 (Allura Red AC)",
        "category": "Artificial Color",
        "description":
            "Synthetic petroleum-based food dye (E129) linked to increased hyperactivity and behavioral problems in children with ADHD. Found in candy, drinks, cereals, and processed foods.",
        "status": "avoid",
        "evidenceLevel": "high",
        "scientificEvidenceRank": 75,
        "studyLinks": {
          "Food additives and hyperactivity":
              "https://pubmed.ncbi.nlm.nih.gov/17825405/",
          "Artificial colors and ADHD":
              "https://pubmed.ncbi.nlm.nih.gov/22331014/"
        },
        "sideEffects": [
          "Increased hyperactivity and impulsivity in sensitive children",
          "Behavioral problems and reduced attention span",
          "Possible allergic reactions or hypersensitivity",
          "Effects more pronounced in children with existing ADHD"
        ],
        "tldr":
            "Artificial red dye linked to worsened ADHD symptoms; avoid in processed foods, candy, and drinks.",
        "notes":
            "⚠️ AVOID: Check labels for 'Red 40', 'Allura Red', or 'E129'. Common in fruit snacks, sports drinks, candy, and brightly colored cereals. European studies led to warning labels; some countries ban it."
      },
      {
        "id": "high-fructose-corn-syrup",
        "name": "High Fructose Corn Syrup (HFCS)",
        "category": "Sweetener",
        "description":
            "Highly processed sweetener that causes rapid blood sugar spikes and crashes, worsening ADHD symptoms. Found in sodas, processed foods, and many packaged snacks.",
        "status": "avoid",
        "evidenceLevel": "moderate",
        "scientificEvidenceRank": 70,
        "studyLinks": {
          "Sugar and ADHD symptoms":
              "https://pubmed.ncbi.nlm.nih.gov/21129940/",
          "Refined sugars and behavior":
              "https://pubmed.ncbi.nlm.nih.gov/16507461/"
        },
        "sideEffects": [
          "Rapid blood sugar spikes followed by crashes",
          "Increased brain fog and difficulty concentrating",
          "Energy fluctuations and irritability",
          "Worsened impulsivity and hyperactivity",
          "Contributes to inflammation and metabolic issues"
        ],
        "tldr":
            "Processed sweetener causing blood sugar crashes and brain fog; avoid in sodas and processed foods.",
        "notes":
            "⚠️ LIMIT/AVOID: Check labels for 'HFCS', 'corn syrup', or 'glucose-fructose syrup'. Common in sodas, ketchup, bread, yogurt, and snack bars. Choose whole foods and natural sweeteners instead."
      },
      {
        "id": "sodium-benzoate",
        "name": "Sodium Benzoate (E211)",
        "category": "Preservative",
        "description":
            "Common preservative in soft drinks and processed foods that may increase hyperactivity when combined with artificial colors. Particularly problematic for children with ADHD.",
        "status": "avoid",
        "evidenceLevel": "moderate",
        "scientificEvidenceRank": 68,
        "studyLinks": {
          "Sodium benzoate and hyperactivity":
              "https://pubmed.ncbi.nlm.nih.gov/17825405/",
          "Food preservatives and ADHD":
              "https://pubmed.ncbi.nlm.nih.gov/22331014/"
        },
        "sideEffects": [
          "Increased hyperactivity and reduced attention span",
          "Behavioral problems when combined with artificial colors",
          "Possible allergic reactions in sensitive individuals",
          "May interfere with mitochondrial function"
        ],
        "tldr":
            "Preservative linked to hyperactivity, especially with artificial colors; avoid in sodas and processed foods.",
        "notes":
            "⚠️ AVOID: Check labels for 'sodium benzoate', 'E211', or 'benzoate of soda'. Common in soft drinks, fruit juices, pickles, and condiments. Often combined with artificial colors (amplifies effects)."
      },
      {
        "id": "vitamin-c",
        "name": "Vitamin C (Ascorbic Acid)",
        "category": "Vitamin",
        "dosage": "500-1000mg",
        "timeOfDay": "evening",
        "benefits": ["Immunity", "Antioxidant"],
        "evidenceLevel": "low",
        "status": "neutral",
        "adhdMedInteractions": {
          "Adderall":
              "CRITICAL: Vitamin C increases urinary acidity, which causes amphetamines to be flushed from your system significantly faster.",
          "Vyvanse":
              "Vitamin C can lower the effectiveness of your medication if taken within 1-2 hours of your dose.",
          "Dexedrine":
              "Reduces blood levels of the medication. Do not take within 2 hours of your medication dose."
        },
        "tldr":
            "Improves immune health but can interfere with the absorption and effectiveness of stimulant medications."
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
