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
      },
      {
        "id": "l-tyrosine",
        "name": "L-Tyrosine",
        "category": "Amino Acid",
        "dosage": "500mg",
        "timeOfDay": "morning",
        "benefits": ["Dopamine Precursor", "Stress Resilience", "Acute Focus"],
        "evidenceLevel": "moderate",
        "notes":
            "Building block for dopamine, norepinephrine, and epinephrine. Best for acute stress situations rather than chronic daily use due to tolerance.",
        "status": "beneficial",
        "mechanismOfAction":
            "Converts to L-DOPA via tyrosine hydroxylase enzyme, then to dopamine. Supports catecholamine synthesis under stress conditions when demand exceeds supply.",
        "detailedBenefits": [
          "Improves cognitive performance under acute stress",
          "Supports dopamine production when depleted",
          "May enhance working memory during demanding tasks",
          "Provides building blocks for stress hormone synthesis"
        ],
        "timingRationale":
            "Take on empty stomach before demanding tasks for maximum absorption. Competes with other amino acids for transport, so avoid taking with protein meals.",
        "scientificEvidenceRank": 65,
        "studyLinks": {
          "Tyrosine for cognitive performance":
              "https://pubmed.ncbi.nlm.nih.gov/25797188/",
          "Stress and working memory":
              "https://pubmed.ncbi.nlm.nih.gov/10688423/"
        },
        "dosageByWeight": {
          "40-60": "500-1000mg",
          "60-80": "1000-1500mg",
          "80-100": "1500-2000mg",
          "100-120": "2000mg"
        },
        "dosageFrequency":
            "Once or split doses before demanding tasks (not daily)",
        "dosageWarnings": [
          "Take on empty stomach for best absorption",
          "Tolerance develops within 6 weeks with daily use",
          "Not recommended for chronic daily supplementation",
          "Take separately from ADHD stimulants (competes for absorption)"
        ],
        "tldr":
            "Dopamine precursor amino acid; best for acute stress situations rather than daily use due to tolerance.",
        "adhdMedInteractions": {
          "Adderall":
              "Take 2+ hours apart from medication (competes for absorption). Works synergistically with iron and B6 (cofactors for conversion).",
          "Vyvanse":
              "Separate timing from medication. May provide additional dopamine support during high-stress periods.",
          "Ritalin":
              "Avoid taking simultaneously. Best used on days off medication or hours apart."
        },
        "contraindications": [
          "People with hyperthyroidism (tyrosine is a thyroid hormone precursor)",
          "Those taking MAO inhibitors",
          "Individuals with melanoma (theoretical risk)",
          "Pregnant or breastfeeding women"
        ],
        "sideEffects": [
          "Rare: headache or nausea at high doses",
          "Possible: irritability or anxiety if overstimulated",
          "Tolerance develops quickly with daily use",
          "Generally safe at recommended doses"
        ]
      },
      {
        "id": "rhodiola-rosea",
        "name": "Rhodiola Rosea",
        "category": "Adaptogen",
        "dosage": "200mg",
        "timeOfDay": "morning",
        "benefits": [
          "Mental Fatigue Reduction",
          "Stress Adaptation",
          "Sustained Attention"
        ],
        "evidenceLevel": "moderate",
        "notes":
            "Adaptogenic herb that balances neurotransmitters while regulating cortisol. Use standardized extract (3% rosavins, 1% salidroside).",
        "status": "beneficial",
        "mechanismOfAction":
            "Increases dopamine, serotonin, and norepinephrine availability while modulating stress response. Enhances mental energy without depleting reserves like stimulants.",
        "detailedBenefits": [
          "Reduces mental fatigue by 30-40% in clinical trials",
          "Improves sustained attention and task management",
          "Balances stress hormone (cortisol) levels",
          "Supports cognitive performance under chronic stress"
        ],
        "timingRationale":
            "Morning dosing aligns with natural cortisol rhythm. Effects build over 1-2 weeks. Avoid evening use as it may interfere with sleep.",
        "scientificEvidenceRank": 72,
        "studyLinks": {
          "Rhodiola for mental fatigue":
              "https://pubmed.ncbi.nlm.nih.gov/11081987/",
          "Cognitive performance under stress":
              "https://pubmed.ncbi.nlm.nih.gov/19016404/"
        },
        "dosageByWeight": {
          "40-60": "200-300mg",
          "60-80": "300-400mg",
          "80-100": "400-600mg",
          "100-120": "600mg"
        },
        "dosageFrequency": "Once daily in the morning",
        "dosageWarnings": [
          "Start with 200mg to assess tolerance",
          "May cause mild stimulation - avoid if overstimulated",
          "Do not take in evening (may interfere with sleep)",
          "Effects build over 1-2 weeks of consistent use"
        ],
        "tldr":
            "Adaptogenic herb that reduces mental fatigue and increases neurotransmitter levels; supports stress resilience.",
        "adhdMedInteractions": {
          "Adderall":
              "Generally safe but may enhance stimulating effects. Monitor for overstimulation. Start with lower dose.",
          "Vyvanse":
              "May provide complementary stress support. Watch for combined stimulant effects.",
          "Ritalin":
              "Safe combination for most. Rhodiola's adaptogenic properties may reduce stress from stimulants."
        },
        "contraindications": [
          "People with bipolar disorder (may trigger manic episodes)",
          "Those taking MAO inhibitors",
          "Pregnant or breastfeeding women (insufficient safety data)"
        ],
        "sideEffects": [
          "Rare: mild jitteriness or overstimulation",
          "Possible: dry mouth or dizziness",
          "Very rare: agitation in bipolar individuals",
          "Generally well-tolerated at recommended doses"
        ]
      },
      {
        "id": "alcar",
        "name": "Acetyl-L-Carnitine (ALCAR)",
        "category": "Amino Acid",
        "dosage": "500mg",
        "timeOfDay": "morning",
        "benefits": [
          "Brain Energy",
          "Acetylcholine Support",
          "Inattentive-Type ADHD"
        ],
        "evidenceLevel": "high",
        "notes":
            "Crosses blood-brain barrier to enhance mitochondrial energy and increase dopamine. Multi-site trials show significant benefit specifically for inattentive subtype, NOT combined type.",
        "status": "beneficial",
        "mechanismOfAction":
            "Enhances mitochondrial energy production and crosses blood-brain barrier to increase dopamine levels and amino acids needed for brain development. Supports acetylcholine synthesis.",
        "detailedBenefits": [
          "Reduces inattentive symptoms by 20-30% in clinical trials",
          "Enhances brain energy metabolism",
          "May reduce irritability and headaches from medications",
          "Supports cognitive processing speed"
        ],
        "timingRationale":
            "Morning and early afternoon dosing provides sustained cognitive support. Take with or without food. Split dosing improves consistency of effects.",
        "scientificEvidenceRank": 78,
        "studyLinks": {
          "ALCAR for ADHD inattentive type":
              "https://pubmed.ncbi.nlm.nih.gov/17444943/",
          "Brain energy metabolism": "https://pubmed.ncbi.nlm.nih.gov/18065594/"
        },
        "dosageByWeight": {
          "40-60": "500-1000mg",
          "60-80": "1000mg",
          "80-100": "1000-1500mg",
          "100-120": "1500mg"
        },
        "dosageFrequency": "Twice daily (morning and early afternoon)",
        "dosageWarnings": [
          "Higher doses (>2000mg) may cause fishy body odor",
          "May increase energy - avoid late afternoon doses if affects sleep",
          "Most effective for inattentive type, not combined type ADHD",
          "Start with 500mg to assess tolerance"
        ],
        "tldr":
            "Supports brain energy and acetylcholine; particularly beneficial for inattentive-type ADHD (not combined type).",
        "adhdMedInteractions": {
          "Adderall":
              "Safe combination. May reduce medication side effects like irritability and headache.",
          "Vyvanse":
              "Complementary for sustained energy and focus. No contraindications.",
          "Ritalin":
              "Safe to combine with methylphenidate. May enhance medication effectiveness for inattentive symptoms."
        },
        "contraindications": [
          "People with seizure disorders (theoretical risk)",
          "Those with thyroid hormone issues (may increase thyroid activity)",
          "Individuals with fishy body odor (TMAU condition)"
        ],
        "sideEffects": [
          "Occasional: fishy body odor at high doses (>2000mg)",
          "Rare: mild GI upset or nausea",
          "Possible: increased energy/restlessness",
          "Generally well-tolerated at recommended doses"
        ]
      },
      {
        "id": "nac",
        "name": "N-Acetyl Cysteine (NAC)",
        "category": "Amino Acid",
        "dosage": "600mg",
        "timeOfDay": "any",
        "benefits": [
          "Impulse Control",
          "Oxidative Stress",
          "Glutamate Regulation"
        ],
        "evidenceLevel": "moderate",
        "notes":
            "Powerful antioxidant and glutamate modulator. Precursor to glutathione (master antioxidant). Particularly beneficial for impulse control.",
        "status": "beneficial",
        "mechanismOfAction":
            "Precursor to glutathione (master cellular antioxidant). Modulates glutamate signaling in prefrontal cortex by restoring cystine-glutamate exchange. Reduces oxidative stress and neuroinflammation.",
        "detailedBenefits": [
          "Supports impulse control and reduces compulsive behaviors",
          "Protects brain cells from oxidative damage",
          "Regulates glutamate (main excitatory neurotransmitter)",
          "May reduce stimulant-induced oxidative stress"
        ],
        "timingRationale":
            "Can be taken any time of day wit or without food. Split dosing (morning and afternoon) may provide more consistent effects than single dose.",
        "scientificEvidenceRank": 70,
        "studyLinks": {
          "NAC for impulse control":
              "https://pubmed.ncbi.nlm.nih.gov/26424423/",
          "Glutamate modulation": "https://pubmed.ncbi.nlm.nih.gov/24200314/"
        },
        "dosageByWeight": {
          "40-60": "600mg",
          "60-80": "600-1200mg",
          "80-100": "1200-1800mg",
          "100-120": "1800mg"
        },
        "dosageFrequency": "1-3 times daily (split into 2-3 doses)",
        "dosageWarnings": [
          "Start with 600mg once daily to assess tolerance",
          "May cause mild GI upset - take with food if needed",
          "High doses (>1800mg) should be under medical supervision",
          "Has distinctive sulfur smell (normal)"
        ],
        "tldr":
            "Powerful antioxidant that modulates glutamate and supports impulse control; reduces oxidative stress.",
        "adhdMedInteractions": {
          "Adderall":
              "Safe combination. May enhance medication effectiveness by reducing oxidative stress from stimulant use.",
          "Vyvanse":
              "Complementary antioxidant protection. No contraindications.",
          "Ritalin":
              "Safe with all ADHD medications. Provides neuroprotective benefits."
        },
        "contraindications": [
          "People with asthma (may trigger bronchospasm in rare cases)",
          "Those with bleeding disorders (theoretical risk)",
          "Pregnant or breastfeeding women (consult physician)"
        ],
        "sideEffects": [
          "Common: sulfur smell/taste (normal, not harmful)",
          "Occasional: mild nausea or GI upset (take with food)",
          "Rare: skin rash or allergic reaction",
          "Generally safe and well-tolerated"
        ]
      },
      {
        "id": "b-complex",
        "name": "Vitamin B Complex (Methylated)",
        "category": "Vitamin",
        "dosage": "50mg",
        "timeOfDay": "morning",
        "benefits": [
          "Neurotransmitter Synthesis",
          "Energy Production",
          "Methylation Support"
        ],
        "evidenceLevel": "high",
        "notes":
            "Methylated form (methylfolate, methylcobalamin) preferred. Essential cofactors for dopamine production.",
        "status": "beneficial",
        "scientificEvidenceRank": 80,
        "tldr":
            "Essential cofactors for neurotransmitter synthesis; methylated forms support dopamine production."
      },
      {
        "id": "alpha-gpc",
        "name": "Alpha-GPC",
        "category": "Nootropic",
        "dosage": "300mg",
        "timeOfDay": "morning",
        "benefits": [
          "Working Memory",
          "Acetylcholine Production",
          "Mental Clarity"
        ],
        "evidenceLevel": "moderate",
        "notes":
            "Premium choline source, highly bioavailable. Supports working memory and attention.",
        "status": "beneficial",
        "scientificEvidenceRank": 72,
        "tldr":
            "Premium choline source for acetylcholine synthesis; supports working memory and attention."
      },
      {
        "id": "panax-ginseng",
        "name": "Panax Ginseng (Korean Ginseng)",
        "category": "Adaptogen",
        "dosage": "200mg",
        "timeOfDay": "morning",
        "benefits": [
          "Sustained Attention",
          "Mental Fatigue",
          "Dopaminergic Effects"
        ],
        "evidenceLevel": "moderate",
        "notes":
            "Use standardized extract. Contains ginsenosides that modulate dopamine and acetylcholine.",
        "status": "beneficial",
        "scientificEvidenceRank": 68,
        "tldr":
            "Adaptogen that improves sustained attention and reduces mental fatigue through dopaminergic effects."
      },
      {
        "id": "maritime-pine-bark",
        "name": "Maritime Pine Bark Extract",
        "category": "Antioxidant",
        "dosage": "1mg/kg",
        "timeOfDay": "morning",
        "benefits": ["Hyperactivity Reduction", "Attention", "Blood Flow"],
        "evidenceLevel": "moderate",
        "notes":
            "Similar to Pycnogenol. Contains proanthocyanidins for antioxidant and blood flow benefits.",
        "status": "beneficial",
        "scientificEvidenceRank": 73,
        "tldr":
            "Antioxidant-rich extract that reduces hyperactivity and improves attention through enhanced blood flow."
      },
      {
        "id": "phosphatidylcholine",
        "name": "Phosphatidylcholine",
        "category": "Lipid",
        "dosage": "420mg",
        "timeOfDay": "any",
        "benefits": [
          "Cell Membrane Support",
          "Acetylcholine Production",
          "Neuronal Structure"
        ],
        "evidenceLevel": "moderate",
        "notes": "Provides choline and supports cell membrane fluidity.",
        "status": "beneficial",
        "scientificEvidenceRank": 65,
        "tldr":
            "Cell membrane phospholipid supporting neuronal structure and acetylcholine production."
      },
      {
        "id": "vitamin-e",
        "name": "Vitamin E (Mixed Tocopherols)",
        "category": "Vitamin",
        "dosage": "200 IU",
        "timeOfDay": "any",
        "benefits": ["Antioxidant", "Membrane Protection", "Omega-3 Support"],
        "evidenceLevel": "moderate",
        "notes":
            "Mixed tocopherols preferred. Protects omega-3 fats from oxidation.",
        "status": "beneficial",
        "scientificEvidenceRank": 60,
        "tldr":
            "Fat-soluble antioxidant that protects brain membranes; works synergistically with omega-3s."
      },
      {
        "id": "coq10",
        "name": "Coenzyme Q10 (Ubiquinol)",
        "category": "Antioxidant",
        "dosage": "100mg",
        "timeOfDay": "morning",
        "benefits": [
          "Mitochondrial Energy",
          "Brain Cell Energy",
          "Antioxidant"
        ],
        "evidenceLevel": "low",
        "notes":
            "Ubiquinol form preferred for better absorption. Supports ATP production.",
        "status": "beneficial",
        "scientificEvidenceRank": 55,
        "tldr":
            "Supports mitochondrial energy production and provides antioxidant protection for brain cells."
      },
      {
        "id": "vitamin-a",
        "name": "Vitamin A (Retinol)",
        "category": "Vitamin",
        "dosage": "2500 IU",
        "timeOfDay": "any",
        "benefits": [
          "Neuroplasticity",
          "Dopamine Receptor Function",
          "Gene Expression"
        ],
        "evidenceLevel": "moderate",
        "notes":
            "Supports dopamine receptor sensitivity. Avoid megadoses (toxic above 10,000 IU daily long-term).",
        "status": "beneficial",
        "scientificEvidenceRank": 62,
        "tldr":
            "Fat-soluble vitamin supporting neuroplasticity and dopamine receptor function; avoid megadoses."
      },
      {
        "id": "caffeine",
        "name": "Caffeine (with L-Theanine)",
        "category": "Stimulant",
        "dosage": "50-100mg",
        "timeOfDay": "morning",
        "benefits": ["Alertness", "Focus"],
        "evidenceLevel": "moderate",
        "notes":
            "⚠️ CAUTION: Must be combined with L-Theanine (2:1 ratio). Alone may worsen impulsivity and anxiety.",
        "status": "caution",
        "scientificEvidenceRank": 70,
        "tldr":
            "Must be paired with L-Theanine to avoid jitters and anxiety; use caution with ADHD stimulants."
      },
      {
        "id": "melatonin",
        "name": "Melatonin",
        "category": "Hormone",
        "dosage": "0.5-3mg",
        "timeOfDay": "evening",
        "benefits": ["Sleep"],
        "evidenceLevel": "high",
        "notes":
            "⚠️ CAUTION: Use only for sleep issues. Does not treat core ADHD symptoms.",
        "status": "caution",
        "scientificEvidenceRank": 75,
        "tldr":
            "Helpful for ADHD-related sleep problems but does not treat attention symptoms; long-term use requires monitoring."
      },
      {
        "id": "5-htp",
        "name": "5-HTP (5-Hydroxytryptophan)",
        "category": "Amino Acid",
        "dosage": "50-100mg",
        "timeOfDay": "evening",
        "benefits": ["Mood", "Sleep"],
        "evidenceLevel": "low",
        "notes":
            "⚠️ CAUTION: Serotonin precursor, not dopamine. AVOID with SSRIs (serotonin syndrome risk).",
        "status": "caution",
        "scientificEvidenceRank": 50,
        "tldr":
            "May help mood and sleep but not core ADHD symptoms; risk of serotonin syndrome with SSRIs."
      },
      {
        "id": "copper",
        "name": "Copper",
        "category": "Mineral",
        "dosage": "1-2mg",
        "timeOfDay": "any",
        "benefits": ["Dopamine Metabolism"],
        "evidenceLevel": "low",
        "notes":
            "⚠️ CAUTION: Test before supplementing. Excess causes toxicity and worsens ADHD. Balance with zinc.",
        "status": "caution",
        "scientificEvidenceRank": 45,
        "tldr":
            "Required for dopamine beta-hydroxylase but toxic in excess; only supplement if deficient."
      },
      {
        "id": "b6-high-dose",
        "name": "Vitamin B6 (High-Dose Standalone)",
        "category": "Vitamin",
        "dosage": "25-50mg",
        "timeOfDay": "any",
        "benefits": ["Neurotransmitter Synthesis"],
        "evidenceLevel": "moderate",
        "notes":
            "⚠️ CAUTION: High doses (>100mg) long-term can cause peripheral neuropathy. Best combined with magnesium.",
        "status": "caution",
        "scientificEvidenceRank": 65,
        "tldr":
            "Essential cofactor but high doses can cause nerve damage; safer in magnesium+B6 formulas."
      },
      {
        "id": "yellow-5",
        "name": "Yellow 5 (Tartrazine / E102)",
        "category": "Artificial Color",
        "description":
            "Synthetic food dye linked to increased hyperactivity. Part of 'Southampton Six' dyes triggering EU warnings.",
        "status": "avoid",
        "scientificEvidenceRank": 73,
        "tldr":
            "Artificial yellow dye linked to hyperactivity in children; avoid in candy, cereals, sodas.",
        "notes":
            "⚠️ AVOID: Found in candy, cereals, soft drinks, chips, pickles, mustard, some medications."
      },
      {
        "id": "yellow-6",
        "name": "Yellow 6 (Sunset Yellow / E110)",
        "category": "Artificial Color",
        "description":
            "Synthetic dye shown to increase hyperactive behavior in controlled trials.",
        "status": "avoid",
        "scientificEvidenceRank": 72,
        "tldr":
            "Orange food dye that worsens hyperactivity; avoid in sodas and baked goods.",
        "notes":
            "⚠️ AVOID: Found in orange-colored foods, sodas, baked goods, candy, gelatin desserts."
      },
      {
        "id": "red-3",
        "name": "Red 3 (Erythrosine / E127)",
        "category": "Artificial Color",
        "description":
            "Associated with thyroid disruption and behavioral effects.",
        "status": "avoid",
        "scientificEvidenceRank": 70,
        "tldr":
            "Red dye with thyroid and behavioral concerns; avoid in cherries and candy.",
        "notes":
            "⚠️ AVOID: Found in maraschino cherries, candy, some medications."
      },
      {
        "id": "blue-1",
        "name": "Blue 1 (Brilliant Blue / E133)",
        "category": "Artificial Color",
        "description":
            "Synthetic dye identified as not adequately protected by FDA guidelines for children's behavioral health.",
        "status": "avoid",
        "scientificEvidenceRank": 68,
        "tldr":
            "Blue dye linked to behavioral issues; avoid in beverages and candy.",
        "notes": "⚠️ AVOID: Found in beverages, candy, baked goods, ice cream."
      },
      {
        "id": "blue-2",
        "name": "Blue 2 (Indigo Carmine / E132)",
        "category": "Artificial Color",
        "description":
            "Synthetic color linked to behavioral issues in children with ADHD or sensitivities.",
        "status": "avoid",
        "scientificEvidenceRank": 67,
        "tldr":
            "Blue dye associated with hyperactivity; avoid in candy and beverages.",
        "notes": "⚠️ AVOID: Found in candy, beverages, pet foods."
      },
      {
        "id": "carmoisine",
        "name": "Carmoisine (E122)",
        "category": "Artificial Color",
        "description":
            "Southampton Study dye contributing to increased hyperactivity when combined with sodium benzoate.",
        "status": "avoid",
        "scientificEvidenceRank": 71,
        "tldr": "Red dye from Southampton study; avoid in jams and drinks.",
        "notes":
            "⚠️ AVOID: Found in jams, desserts, drinks (more common in UK/EU)."
      },
      {
        "id": "quinoline-yellow",
        "name": "Quinoline Yellow (E104)",
        "category": "Artificial Color",
        "description":
            "One of six Southampton study dyes showing significant hyperactivity effects.",
        "status": "avoid",
        "scientificEvidenceRank": 69,
        "tldr":
            "Yellow dye from Southampton study; avoid in smoked fish and medications.",
        "notes":
            "⚠️ AVOID: Found in smoked fish, Scotch eggs, some medications."
      },
      {
        "id": "allura-red",
        "name": "Allura Red (E129)",
        "category": "Artificial Color",
        "description":
            "Increased Global Hyperactivity scores in Southampton study (effect size d=0.12-0.2).",
        "status": "avoid",
        "scientificEvidenceRank": 74,
        "tldr":
            "Red dye with proven hyperactivity effects; avoid in sodas and cereals.",
        "notes":
            "⚠️ AVOID: Found in soft drinks, children's medications, candy, cereals."
      },
      {
        "id": "aspartame",
        "name": "Aspartame (E951)",
        "category": "Artificial Sweetener",
        "description":
            "Chronic consumption may affect dopamine system. Individual sensitivities vary - some report brain fog.",
        "status": "avoid",
        "scientificEvidenceRank": 58,
        "tldr":
            "Artificial sweetener with potential dopamine effects; individual sensitivity varies.",
        "notes":
            "⚠️ LIMIT/AVOID: Found in diet sodas, sugar-free gum, yogurts, tabletop sweeteners."
      },
      {
        "id": "sucralose",
        "name": "Sucralose",
        "category": "Artificial Sweetener",
        "description":
            "May disrupt gut microbiome (affecting gut-brain axis). Anecdotal reports of worsened ADHD symptoms.",
        "status": "avoid",
        "scientificEvidenceRank": 55,
        "tldr":
            "Artificial sweetener that may disrupt gut-brain axis; anecdotal ADHD symptom worsening.",
        "notes":
            "⚠️ LIMIT/AVOID: Found in diet products, protein shakes, sugar-free desserts."
      },
      {
        "id": "msg",
        "name": "Monosodium Glutamate (MSG / E621)",
        "category": "Flavor Enhancer",
        "description":
            "Some individuals report increased hyperactivity after consumption. May affect neurotransmitter activity in sensitive individuals.",
        "status": "avoid",
        "scientificEvidenceRank": 52,
        "tldr":
            "Flavor enhancer with mixed evidence; some report behavioral changes.",
        "notes":
            "⚠️ LIMIT: Found in fast food, chips, instant noodles, frozen meals, restaurant food."
      },
      {
        "id": "bht",
        "name": "Butylated Hydroxytoluene (BHT / E321)",
        "category": "Preservative",
        "description":
            "Synthetic preservative with potential neurotoxic effects at high exposure. May contribute to oxidative stress.",
        "status": "avoid",
        "scientificEvidenceRank": 60,
        "tldr":
            "Synthetic preservative with potential neurotoxic effects; avoid in cereals and snacks.",
        "notes":
            "⚠️ AVOID: Found in cereals, snack foods, chewing gum, some cosmetics."
      },
      {
        "id": "potassium-benzoate",
        "name": "Potassium Benzoate (E212)",
        "category": "Preservative",
        "description":
            "Similar mechanism to sodium benzoate. May amplify hyperactivity with synthetic food dyes.",
        "status": "avoid",
        "scientificEvidenceRank": 66,
        "tldr":
            "Preservative similar to sodium benzoate; amplifies hyperactivity with dyes.",
        "notes":
            "⚠️ AVOID: Found in soft drinks, fruit juices, pickles, condiments."
      },
      {
        "id": "refined-sugar",
        "name": "Excessive Refined Sugar",
        "category": "Dietary Factor",
        "description":
            "Chronic excessive intake may downregulate D2 dopamine receptors. Blood sugar crashes cause brain fog and worsen attention.",
        "status": "avoid",
        "scientificEvidenceRank": 63,
        "tldr":
            "Chronic excess may reduce dopamine signaling; blood sugar crashes worsen focus.",
        "notes":
            "⚠️ LIMIT: Focus on low-glycemic alternatives to avoid crashes."
      },
      {
        "id": "trans-fats",
        "name": "Trans Fats (Partially Hydrogenated Oils)",
        "category": "Dietary Fat",
        "description":
            "Interferes with omega-3 incorporation into brain membranes. Pro-inflammatory and counteracts omega-3 benefits.",
        "status": "avoid",
        "scientificEvidenceRank": 76,
        "tldr":
            "Harmful fats that interfere with omega-3 brain benefits; avoid fried foods and margarine.",
        "notes":
            "⚠️ AVOID: Found in fried foods, baked goods, margarine, some processed snacks."
      },
      {
        "id": "alcohol",
        "name": "Alcohol",
        "category": "Substance",
        "description":
            "Depletes B vitamins, disrupts sleep, impairs dopamine regulation, and worsens executive function.",
        "status": "avoid",
        "scientificEvidenceRank": 80,
        "tldr":
            "Depletes vitamins, disrupts sleep and dopamine; check liquid supplements for alcohol content.",
        "notes":
            "⚠️ LIMIT/AVOID: Check liquid medications and supplements for alcohol bases."
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
