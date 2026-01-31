import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../utils/logger.dart';

class SeedingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const List<Map<String, dynamic>> defaultSupplements = [
    {
      "id": "omega-3",
      "name": "Omega-3 Fish Oil",
      "category": "Essential Fatty Acids",
      "dosage": "1000mg",
      "timeOfDay": "morning",
      "benefits": ["Focus", "Brain Performance", "Mood"],
      "evidenceLevel": "high",
      "notes": "Take with food for better absorption",
      "status": "beneficial",
      "focusLevel": 4,
      "mechanismOfAction":
          "Increases cell membrane permeability, enhances dopamine receptor density, and reduces neuroinflammation.",
      "detailedBenefits": [
        "Improves working memory by 15% in standard trials",
        "Reduces impulsivity and emotional dysregulation",
        "Supports long-term neuroprotection"
      ],
      "timingRationale":
          "Fat-soluble nutrients require dietary fat for absorption. Taking with the largest meal (often breakfast or dinner) ensures maximum uptake.",
      "scientificEvidenceRank": 92,
      "studyLinks": {
        "Omega-3 fatty acids for Focus":
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
        "Consult advisor if taking anti-coagulants (blood thinners)",
        "Stop taking 2 weeks before scheduled surgeries",
        "High doses (>3g) may increase bleeding risk in some individuals"
      ],
      "tldr":
          "Essential fatty acids that improve dopamine receptor density and reduce brain inflammation.",
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "Olio di Pesce Omega-3",
          "description":
              "Acidi grassi essenziali fondamentali per la salute del cervello, la funzione cognitiva e la regolazione dell'umore.",
          "mechanismOfAction":
              "Aumenta la permeabilità della membrana cellulare, migliora la densità dei recettori della dopamina e riduce la neuroinfiammazione.",
          "detailedBenefits": [
            "Migliora la memoria di lavoro del 15% nei test standard",
            "Riduce l'impulsività e la disregolazione emotiva",
            "Supporta la neuroprotezione a lungo termine"
          ],
          "timingRationale":
              "I nutrienti liposolubili richiedono grassi alimentari per l'assorbimento. L'assunzione con il pasto più abbondante garantisce il massimo assorbimento.",
          "dosageFrequency": "Assumere una volta al giorno con un pasto grasso",
          "dosageWarnings": [
            "Consultare un medico se si assumono anticoagulanti",
            "Sospendere l'assunzione 2 settimane prima di interventi chirurgici",
            "Dosi elevate (>3g) possono aumentare il rischio di sanguinamento"
          ],
          "tldr":
              "Acidi grassi essenziali che migliorano la densità dei recettori della dopamina e riducono l'infiammazione cerebrale."
        },
        "es": {
          "name": "Aceite de Pescado Omega-3",
          "description":
              "Ácidos grasos esenciales fundamentales para la salud cerebral, la función cognitiva y la regulación del estado de ánimo.",
          "mechanismOfAction":
              "Aumenta la permeabilidad de la membrana celular, mejora la densidad de los receptores de dopamina y reduce la neuroinflamación.",
          "detailedBenefits": [
            "Mejora la memoria de trabajo en un 15% en pruebas estándar",
            "Reduce la impulsividad y la desregulación emocional",
            "Apoya la neuroprotección a largo plazo"
          ],
          "timingRationale":
              "Los nutrientes liposolubles requieren grasa dietética para su absorción. Tomar con la comida más abundante garantiza la máxima absorción.",
          "dosageFrequency": "Tomar una vez al día con una comida grasa",
          "dosageWarnings": [
            "Consulte a un médico si toma anticoagulantes",
            "Deje de tomar 2 semanas antes de cirugías programadas",
            "Dosis altas (>3g) pueden aumentar el riesgo de sangrado"
          ],
          "tldr":
              "Ácidos grasos esenciales que mejoran la densidad de los receptores de dopamina y reducen la inflamación cerebral."
        }
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
      "focusLevel": 5,
      "mechanismOfAction":
          "Increases alpha brain wave activity (associated with relaxed alertness) and boosts GABA levels without sedation.",
      "detailedBenefits": [
        "Reduces jitteriness from Type A elements",
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
      "dosageByWeight": {
        "40-60": "100-200mg",
        "60-80": "200mg",
        "80-100": "200-400mg",
        "100-120": "400mg"
      },
      "tldr":
          "Promotes 'calm focus' by increasing alpha brain waves and smoothing out Type A side effects.",
      "dosageFrequency": "Take 1-2 times daily as needed for focus",
      "dosageWarnings": [
        "Do not exceed 1200mg daily",
        "Consult advisor if pregnant or nursing",
        "May lower blood pressure in some individuals"
      ],
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "L-Teanina",
          "description":
              "Un aminoacido trovato principalmente nel tè verde, noto per promuovere il rilassamento senza causare sonnolenza.",
          "mechanismOfAction":
              "Aumenta l'attività delle onde cerebrali alfa (associate alla vigilanza rilassata) e aumenta i livelli di GABA senza sedazione.",
          "detailedBenefits": [
            "Riduce il nervosismo causato dagli elementi di Tipo A",
            "Migliora l'attenzione selettiva durante compiti stressanti",
            "Promuovere il rilassamento senza sonnolenza"
          ],
          "timingRationale":
              "Meglio assumerlo 30-60 minuti prima del lavoro di concentrazione. La sua emivita è di circa 3 ore.",
          "dosageFrequency":
              "Assumere 1-2 volte al giorno al bisogno per la concentrazione",
          "dosageWarnings": [
            "Non superare i 1200mg al giorno",
            "Consultare un medico in gravidanza o allattamento",
            "Può abbassare la pressione sanguigna in alcuni individui"
          ],
          "tldr":
              "Promuove la 'concentrazione calma' aumentando le onde alfa e mitigando gli effetti collaterali degli stimolanti."
        },
        "es": {
          "name": "L-Teanina",
          "description":
              "Un aminoácido encontrado principalmente en el té verde, conocido por promover la relajación sin causar somnolencia.",
          "mechanismOfAction":
              "Aumenta la actividad de las ondas cerebrales alfa (asociadas con la alerta relajada) y aumenta los niveles de GABA sin sedación.",
          "detailedBenefits": [
            "Reduce el nerviosismo causado por los elementos de Tipo A",
            "Mejora la atención selectiva durante tareas estresantes",
            "Promueve la relajación sin somnolencia"
          ],
          "timingRationale":
              "Mejor tomarlo 30-60 minutos antes del trabajo de concentración. Su vida media es de aproximadamente 3 horas.",
          "dosageFrequency":
              "Tomar 1-2 veces al día según sea necesario para el enfoque",
          "dosageWarnings": [
            "No exceder los 1200mg diarios",
            "Consulte a un médico si está embarazada o amamantando",
            "Puede bajar la presión arterial en algunos individuos"
          ],
          "tldr":
              "Promueve el 'enfoque tranquilo' aumentando las ondas alfa y mitigando los efectos secundarios de los estimulantes."
        }
      }
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
      "focusLevel": 4,
      "mechanismOfAction":
          "Acts as a natural NMDA receptor antagonist, promoting GABA activity and regulating the HPA axis. Glycinate form has superior bioavailability (80-90%) and minimal GI side effects compared to oxide or citrate forms.",
      "detailedBenefits": [
        "Improves sleep latency by 17 minutes in standard trials",
        "Reduces cortisol levels and anxiety feelings by 30%",
        "Supports healthy dopamine regulation and prevents Type A tolerance",
        "Reduces muscle tension and physical restlessness"
      ],
      "timingRationale":
          "Evening dosing supports natural melatonin production and muscle relaxation before sleep. Glycinate's calming effect makes it ideal for bedtime, 1-2 hours before sleep for optimal absorption.",
      "scientificEvidenceRank": 88,
      "studyLinks": {
        "Magnesium supplemenfocus support":
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
        "Consult advisor if you have kidney considerations or impaired renal function",
        "Take 4+ hours after Type A element for optimal absorption"
      ],
      "tldr":
          "Highly bioavailable magnesium that improves sleep quality and reduces anxiety without morning grogginess.",
      "sideEffects": [
        "Loose stools if dose exceeds tolerance (typically >500mg)",
        "Rare: mild drowsiness if taken during the day",
        "Very rare: nausea if taken on empty stomach"
      ],
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "Magnesio Glicinato",
          "description":
              "Un minerale essenziale coinvolto in oltre 300 reazioni biochimiche. La forma glicinata è altamente biodisponibile e delicata sullo stomaco.",
          "mechanismOfAction":
              "Agisce come un antagonista naturale del recettore NMDA, promuovendo l'attività del GABA e regolando l'asse HPA. La forma glicinata ha una biodisponibilità superiore (80-90%) e minimi effetti collaterali gastrointestinali.",
          "detailedBenefits": [
            "Migliora la latenza del sonno di 17 minuti nei test standard",
            "Riduce i livelli di cortisolo e le sensazioni di ansia del 30%",
            "Supporta una sana regolazione della dopamina",
            "Riduce la tensione muscolare e l'irrequietezza fisica"
          ],
          "timingRationale":
              "Il dosaggio serale supporta la produzione naturale di melatonina e il rilassamento muscolare prima del sonno. Ideale 1-2 ore prima di andare a dormire.",
          "dosageFrequency":
              "Una volta al giorno, preferibilmente 1-2 ore prima di coricarsi",
          "dosageWarnings": [
            "Iniziare con 100mg per valutare la tolleranza",
            "Dosi elevate (>400mg) possono causare disturbi digestivi",
            "Consultare un medico in caso di problemi renali",
            "Assumere 4+ ore dopo elementi di Tipo A per un assorbimento ottimale"
          ],
          "tldr":
              "Magnesio altamente biodisponibile che migliora la qualità del sonno e riduce l'ansia senza stordimento mattutino.",
          "sideEffects": [
            "Feci molli se la dose supera la tolleranza",
            "Raro: lieve sonnolenza se assunto durante il giorno",
            "Molto raro: nausea se assunto a stomaco vuoto"
          ]
        },
        "es": {
          "name": "Magnesio Glicinato",
          "description":
              "Un mineral esencial involucrado en más de 300 reacciones bioquímicas. La forma de glicinato es altamente biodisponible y suave para el estómago.",
          "mechanismOfAction":
              "Actúa como un antagonista natural del receptor NMDA, promoviendo la actividad de GABA y regulando el eje HPA. La forma de glicinato tiene una biodisponibilidad superior (80-90%) y mínimos efectos secundarios gastrointestinales.",
          "detailedBenefits": [
            "Mejora la latencia del sueño en 17 minutos en pruebas estándar",
            "Reduce los niveles de cortisol y las sensaciones de ansiedad en un 30%",
            "Apoya una regulación saludable de la dopamina",
            "Reduce la tensión muscular y la inquietud física"
          ],
          "timingRationale":
              "La dosis vespertina apoya la producción natural de melatonina y la relajación muscular antes de dormir. Ideal 1-2 horas antes de acostarse.",
          "dosageFrequency":
              "Una vez al día, preferiblemente 1-2 horas antes de acostarse",
          "dosageWarnings": [
            "Comience con 100mg para evaluar la tolerancia",
            "Dosis altas (>400mg) pueden causar molestias digestivas",
            "Consulte a un médico si tiene problemas renales",
            "Tomar 4+ horas después del elemento Tipo A para una absorción óptima"
          ],
          "tldr":
              "Magnesio altamente biodisponible que mejora la calidad del sueño y reduce la ansiedad sin aturdimiento matutino.",
          "sideEffects": [
            "Heces blandas si la dosis excede la tolerancia",
            "Raro: somnolencia leve si se toma durante el día",
            "Muy raro: náuseas si se toma con el estómago vacío"
          ]
        }
      }
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
      "focusLevel": 3,
      "mechanismOfAction":
          "Acts as a neurosteroid hormone regulating synthesis of serotonin and dopamine via tyrosine hydroxylase activation. Crucial for nerve growth factor (NGF) and brain-derived neurotrophic factor (BDNF) production.",
      "detailedBenefits": [
        "Correcting deficiency can improve attention scores by 25-30%",
        "Supports overall mood stability and seasonal resilience (especially winter)",
        "Enhances structural neuroplasticity and synaptic function",
        "Reduces inflammation linked to focus challenges"
      ],
      "timingRationale":
          "Vitamin D can suppress melatonin production, so it should be taken in the morning with a fatty meal to align with circadian rhythm and maximize absorption (fat-soluble vitamin).",
      "scientificEvidenceRank": 90,
      "studyLinks": {
        "Vitamin D and focus challenges":
            "https://pubmed.ncbi.nlm.nih.gov/29457224/",
        "Neurosteroid effects of Vitamin D":
            "https://pubmed.ncbi.nlm.nih.gov/28582844/",
        "Vitamin D deficiency in Focus children":
            "https://pubmed.ncbi.nlm.nih.gov/30415156/"
      },
      "dosageByWeight": {
        "40-60": "1000-2000 IU",
        "60-80": "2000-3000 IU",
        "80-100": "3000-4000 IU",
        "100-120": "4000-5000 IU"
      },
      "dosageFrequency": "Once daily with a fatty meal (breakfast recommended)",
      "dosageWarnings": [
        "Get blood levels tested before supplementing (test 25-OH Vitamin D)",
        "Do not exceed 10,000 IU daily without general supervision",
        "High doses (>5000 IU) require monitoring for hypercalcemia",
        "Always take with vitamin K2 if dosing above 4000 IU to prevent calcium dysregulation"
      ],
      "tldr":
          "Essential neurosteroid that regulates dopamine and serotonin; deficiency strongly linked to focus challenges.",
      "sideEffects": [
        "Rare: nausea or constipation at very high doses (>10,000 IU)",
        "Hypercalcemia challenges if overdosed (fatigue, confusion, excessive thirst)",
        "Generally well-tolerated at recommended doses"
      ],
      "translations": {
        "it": {
          "name": "Vitamina D3",
          "description":
              "Un ormone neurosteroideo essenziale che regola la sintesi di serotonina e dopamina. La carenza è stata collegata a punteggi di attenzione inferiori.",
          "mechanismOfAction":
              "Agisce come un ormone neurosteroideo che regola la sintesi di serotonina e dopamina tramite l'attivazione della tirosina idrossilasi. Fondamentale per la produzione di BDNF.",
          "detailedBenefits": [
            "La correzione della carenza può migliorare i punteggi di attenzione del 25-30%",
            "Supporta la stabilità dell'umore e la resilienza stagionale",
            "Migliora la neuroplasticità strutturale",
            "Riduce l'infiammazione legata alle sfide di concentrazione"
          ],
          "timingRationale":
              "La vitamina D può sopprimere la melatonina, quindi va assunta al mattino con un pasto grasso per allinearsi al ritmo circadiano.",
          "dosageFrequency":
              "Una volta al giorno con un pasto grasso (colazione consigliata)",
          "dosageWarnings": [
            "Controllare i livelli ematici (25-OH Vitamina D) prima di integrare",
            "Non superare le 10.000 UI al giorno senza supervisione medica",
            "Assumere con vitamina K2 se il dosaggio è superiore a 4000 UI"
          ],
          "tldr":
              "Essenziale per regolare dopamina e serotonina; la carenza è fortemente legata alle sfide di concentrazione."
        },
        "es": {
          "name": "Vitamina D3",
          "description":
              "Una hormona neuroesteroide esencial que regula la síntesis de serotonina y dopamina. La deficiencia se ha relacionado con menores puntuaciones de atención.",
          "mechanismOfAction":
              "Actúa como una hormona neuroesteroide que regula la síntesis de serotonina y dopamina a través de la activación de la tirosina hidroxilasa. Crucial para la producción de BDNF.",
          "detailedBenefits": [
            "Corregir la deficiencia puede mejorar las puntuaciones de atención en un 25-30%",
            "Apoya la estabilidad general del estado de ánimo y la resistencia estacional",
            "Mejora la neuroplasticidad estructural y la función sináptica",
            "Reduce la inflamación ligada a los desafíos de concentración"
          ],
          "timingRationale":
              "La vitamina D puede suprimir la producción de melatonina, por lo que debe tomarse por la mañana con una comida grasa para alinearse con el ritmo circadiano.",
          "dosageFrequency":
              "Una vez al día con una comida grasa (se recomienda el desayuno)",
          "dosageWarnings": [
            "Analice sus niveles en sangre antes de suplementar",
            "No exceda las 10,000 UI diarias sin supervisión médica",
            "Tome siempre con vitamina K2 si la dosis es superior a 4000 UI"
          ],
          "tldr":
              "Neuroesteroide esencial que regula la dopamina y la serotonina; la deficiencia está fuertemente ligada a desafíos de concentración."
        }
      }
    },
    {
      "id": "bacopa-monnieri",
      "name": "Bacopa Monnieri",
      "category": "Herb",
      "dosage": "300mg",
      "timeOfDay": "morning",
      "benefits": ["Memory Enhancement", "Anxiety Reduction", "Learning Speed"],
      "evidenceLevel": "high",
      "notes":
          "Use standardized extract (50% bacosides). Takes 8-12 weeks for full cognitive benefits.",
      "status": "beneficial",
      "focusLevel": 4,
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
        "Bacopa and focus challenges":
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
        "May interact with thyroid elements - consult advisor"
      ],
      "tldr":
          "Ayurvedic herb that enhances memory and learning while reducing anxiety; requires 8-12 weeks for full benefits.",
      "sideEffects": [
        "Mild GI upset or nausea (5-10% of users, usually resolves)",
        "Rare: fatigue or increased bowel movements",
        "Very rare: dry mouth or muscle fatigue",
        "Generally well-tolerated with food"
      ],
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "Bacopa Monnieri",
          "description":
              "Erba ayurvedica che migliora la memoria e l'apprendimento riducendo lo stress e l'ansia.",
          "mechanismOfAction":
              "Migliora la comunicazione sinaptica tramite i bacosidi. Modula serotonina e dopamina riducendo il cortisolo.",
          "detailedBenefits": [
            "Migliora il consolidamento della memoria del 20-30% dopo 12 settimane",
            "Riduce l'ansia senza causare sedazione",
            "Aumenta la velocità di apprendimento e l'elaborazione delle informazioni",
            "Effetti neuroprotettivi contro lo stress ossidativo"
          ],
          "timingRationale":
              "L'assunzione mattutina permette agli effetti cumulativi di svilupparsi. Richiede 8-12 settimane per i benefici completi.",
          "dosageFrequency": "Una o due volte al giorno con il cibo",
          "dosageWarnings": [
            "Richiede 8-12 settimane per i massimi effetti - sii paziente",
            "Può causare lievi disturbi gastrointestinali inizialmente",
            "Evitare in caso di bradicardia (frequenza cardiaca lenta)",
            "Può interagire con farmaci per la tiroide"
          ],
          "tldr":
              "Migliora la memoria e l'apprendimento; richiede 8-12 settimane per i benefici completi."
        },
        "es": {
          "name": "Bacopa Monnieri",
          "description":
              "Hierba ayurvédica que mejora la memoria y el aprendizaje mientras reduce la ansiedad.",
          "mechanismOfAction":
              "Mejora la ramificación dendrítica y la comunicación sináptica a través de los bacósidos A y B. Modula la serotonina y la dopamina mientras reduce el cortisol.",
          "detailedBenefits": [
            "Mejora la consolidación y el recuerdo de la memoria en un 20-30%",
            "Reduce la ansiedad sin sedación",
            "Mejora la velocidad de aprendizaje y el procesamiento de la información",
            "Efectos neuroprotectores contra el estrés oxidativo"
          ],
          "timingRationale":
              "La dosis matutina permite que los efectos acumulativos se desarrollen a lo largo del día. Los efectos se retrasan (8-12 semanas) pero son duraderos.",
          "dosageFrequency": "Una o dos veces al día con comida",
          "dosageWarnings": [
            "Toma 8-12 semanas para efectos completos - sea paciente",
            "Puede causar molestias gastrointestinales leves al principio",
            "Evitar si tiene bradicardia (ritmo cardíaco lento)",
            "Puede interactuar con medicamentos para la tiroides"
          ],
          "tldr":
              "Mejora la memoria y el aprendizaje; requiere 8-12 semanas para beneficios completos."
        }
      }
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
      "focusLevel": 4,
      "mechanismOfAction":
          "Essential cofactor for dopamine transporter (DAT) regulation and tyrosine hydroxylase activity. Modulates NMDA receptors and supports melatonin synthesis. Critical for over 300 enzymatic reactions.",
      "detailedBenefits": [
        "Reduces restless energy and impulsivity in zinc-deficient individuals by 30%",
        "Enhances the effectiveness of Type A elements (lower doses may be needed)",
        "Supports immune function and gut health (important for Focus performance)",
        "Improves sleep quality through melatonin regulation"
      ],
      "timingRationale":
          "Can cause nausea on an empty stomach. Take with a solid meal, preferably lunch or dinner. Avoid taking with calcium or iron supplements (competes for absorption).",
      "scientificEvidenceRank": 78,
      "studyLinks": {
        "Zinc sulfate in Focus support":
            "https://pubmed.ncbi.nlm.nih.gov/14687872/",
        "Zinc co-support with Type As":
            "https://pubmed.ncbi.nlm.nih.gov/21309642/",
        "Zinc deficiency and Focus": "https://pubmed.ncbi.nlm.nih.gov/21545780/"
      },
      "dosageByWeight": {
        "40-60": "10-15mg",
        "60-80": "15-20mg",
        "80-100": "20-30mg",
        "100-120": "30-40mg"
      },
      "dosageFrequency": "Once daily with food (lunch or dinner)",
      "dosageWarnings": [
        "Do not exceed 40mg daily without general supervision",
        "Long-term use (>50mg) can cause copper deficiency - supplement copper if needed",
        "Get serum zinc levels tested before supplementing (optimal: 80-120 μg/dL)",
        "Take 2+ hours apart from calcium, iron, or antibiotics"
      ],
      "tldr":
          "Essential cofactor for dopamine regulation and melatonin synthesis; deficiency is linked to focus challenges.",
      "sideEffects": [
        "Nausea if taken on empty stomach (common)",
        "Metallic taste in mouth (occasional)",
        "Copper deficiency if high doses used long-term (>50mg for months)",
        "Rare: stomach cramps or diarrhea"
      ],
      "form": "Tablet",
      "translations": {
        "it": {
          "name": "Zinco (Picolinato o Glicinato)",
          "description":
              "Minerale essenziale che agisce come cofattore per oltre 300 reazioni enzimatiche, inclusa la sintesi di dopamina.",
          "mechanismOfAction":
              "Cofattore essenziale per la regolazione del trasportatore della dopamina (DAT) e l'attività della tirosina idrossilasi. Modula i recettori NMDA e supporta la sintesi della melatonina.",
          "detailedBenefits": [
            "Riduce l'irrequietezza e l'impulsività negli individui carenti di zinco del 30%",
            "Migliora l'efficacia degli elementi di Tipo A",
            "Supporta la funzione immunitaria e la salute intestinale",
            "Migliora la qualità del sonno attraverso la regolazione della melatonina"
          ],
          "timingRationale":
              "Può causare nausea a stomaco vuoto. Assumere con un pasto solido, preferibilmente a pranzo o a cena. Evitare l'assunzione con integratori di calcio o ferro.",
          "dosageFrequency": "Una volta al giorno con il cibo (pranzo o cena)",
          "dosageWarnings": [
            "Non superare i 40mg al giorno senza supervisione medica",
            "L'uso prolungato può causare carenza di rame",
            "Controllare i livelli di zinco sierico prima di integrare",
            "Assumere a distanza di 2+ ore da calcio, ferro o antibiotici"
          ],
          "tldr":
              "Cofattore essenziale per la regolazione della dopamina e la sintesi di melatonina; la carenza è legata a sfide di concentrazione."
        },
        "es": {
          "name": "Zinc (Picolinato o Glicinato)",
          "description":
              "Mineral esencial que actúa como cofactor para más de 300 reacciones enzimáticas, incluida la síntesis de dopamina.",
          "mechanismOfAction":
              "Cofactor esencial para la regulación del transportador de dopamina (DAT) y la actividad de la tirosina hidroxilasa. Modula los receptores NMDA y apoya la síntesis de melatonina.",
          "detailedBenefits": [
            "Reduce la inquietud y la impulsividad en individuos con deficiencia de zinc en un 30%",
            "Mejora la eficacia de los elementos de Tipo A",
            "Apoya la función inmunológica y la salud intestinal",
            "Mejora la calidad del sueño a través de la regulación de la melatonina"
          ],
          "timingRationale":
              "Puede causar náuseas con el estómago vacío. Tomar con una comida sólida, preferiblemente almuerzo o cena. Evitar tomar con suplementos de calcio o hierro.",
          "dosageFrequency": "Una vez al día con comida (almuerzo o cena)",
          "dosageWarnings": [
            "No exceda los 40mg diarios sin supervisión médica",
            "El uso a largo plazo puede causar deficiencia de cobre",
            "Analice sus niveles de zinc antes de suplementar",
            "Tomar con 2+ horas de diferencia de calcio, hierro o antibióticos"
          ],
          "tldr":
              "Cofactor esencial para la regulación de la dopamina y la síntesis de melatonina; la deficiencia está vinculada a desafíos de concentración."
        }
      }
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
          "Use standardized extract (24% ginkgo flavonoids, 6% terpene lactones). More effective for inattentive type Focus.",
      "status": "beneficial",
      "focusLevel": 4,
      "mechanismOfAction":
          "Increases cerebral blood flow and oxygen delivery to the brain. Acts as a potent antioxidant (flavonoids) and platelet-activating factor (PAF) antagonist. Modulates neurotransmitter systems including dopamine and norepinephrine.",
      "detailedBenefits": [
        "Improves attention and concentration in inattentive-type Focus",
        "Enhances cerebral blood flow by 15-20%",
        "Reduces mental fatigue and brain fog",
        "Antioxidant neuroprotection against age-related cognitive decline"
      ],
      "timingRationale":
          "Morning dosing aligns with peak cognitive demands. Takes 4-6 weeks for noticeable cognitive benefits. Split dosing (AM/PM) may improve consistency of effects.",
      "scientificEvidenceRank": 72,
      "studyLinks": {
        "Ginkgo for focus challenges":
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
          "Ancient herb that boosts cerebral blood flow and concentration; particularly effective for inattentive-type Focus.",
      "sideEffects": [
        "Mild headache (5-10% of users, usually dose-dependent)",
        "GI upset or nausea if taken on empty stomach",
        "Rare: dizziness or allergic skin reactions",
        "Very rare: increased bleeding or bruising (stop immediately)"
      ],
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "Ginkgo Biloba",
          "description":
              "Erba antica nota per migliorare il flusso sanguigno cerebrale e la funzione cognitiva.",
          "mechanismOfAction":
              "Aumenta il flusso sanguigno cerebrale e l'apporto di ossigeno al cervello. Agisce come potente antiossidante e antagonista del fattore di attivazione piastrinica (PAF).",
          "detailedBenefits": [
            "Migliora l'attenzione e la concentrazione nel Focus di tipo disattento",
            "Aumenta il flusso sanguigno cerebrale del 15-20%",
            "Riduce l'affaticamento mentale e la nebbia cerebrale",
            "Neuroprotezione antiossidante contro il declino cognitivo"
          ],
          "timingRationale":
              "Il dosaggio mattutino si allinea con i picchi di richiesta cognitiva. Richiede 4-6 settimane per benefici evidenti.",
          "dosageFrequency": "Una o due volte al giorno con il cibo",
          "dosageWarnings": [
            "EVITARE se si assumono anticoagulanti (aspirina, ecc.)",
            "Sospendere 2 settimane prima di un intervento chirurgico",
            "Può causare mal di testa a dosi elevate (>240mg)",
            "Evitare in caso di disturbi emorragici o storia di convulsioni"
          ],
          "tldr":
              "Erba antica che aumenta il flusso sanguigno cerebrale e la concentrazione; efficace per il Focus di tipo disattento."
        },
        "es": {
          "name": "Ginkgo Biloba",
          "description":
              "Hierba antigua conocida por mejorar el flujo sanguíneo cerebral y la función cognitiva.",
          "mechanismOfAction":
              "Aumenta el flujo sanguíneo cerebral y el suministro de oxígeno al cerebro. Actúa como un potente antioxidante y antagonista del factor activador de plaquetas (PAF).",
          "detailedBenefits": [
            "Mejora la atención y la concentración en el Enfoque de tipo inatento",
            "Aumenta el flujo sanguíneo cerebral en un 15-20%",
            "Reduce la fatiga mental y la niebla cerebral",
            "Neuroprotección antioxidante contra el deterioro cognitivo"
          ],
          "timingRationale":
              "La dosis matutina se alinea con los picos de demanda cognitiva. Requiere 4-6 semanas para beneficios evidentes.",
          "dosageFrequency": "Una o dos veces al día con comida",
          "dosageWarnings": [
            "EVITAR si toma anticoagulantes (aspirina, etc.)",
            "Suspender 2 semanas antes de una cirugía",
            "Puede causar dolores de cabeza a dosis altas (>240mg)",
            "Evite si tiene trastornos hemorrágicos o antecedentes de convulsiones"
          ],
          "tldr":
              "Hierba antigua que aumenta el flujo sanguíneo cerebral y la concentración; eficaz para el Enfoque de tipo inatento."
        }
      }
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
      "focusLevel": 3,
      "mechanismOfAction":
          "Essential cofactor for tyrosine hydroxylase (rate-limiting enzyme in dopamine synthesis). Critical for oxygen transport via hemoglobin and myoglobin. Supports mitochondrial energy production and neurotransmitter metabolism.",
      "detailedBenefits": [
        "Correcting deficiency can improve focus challenges by 30-40%",
        "Supports dopamine and norepinephrine production",
        "Enhances cognitive function and reduces fatigue",
        "Improves response to Type A elements in deficient individuals"
      ],
      "timingRationale":
          "Take on empty stomach for best absorption, or with vitamin C to enhance uptake. Avoid taking with calcium, coffee, or tea (reduces absorption). Evening dosing may reduce GI upset.",
      "scientificEvidenceRank": 82,
      "studyLinks": {
        "Iron deficiency and Focus":
            "https://pubmed.ncbi.nlm.nih.gov/22664333/",
        "Iron supplementation effects":
            "https://pubmed.ncbi.nlm.nih.gov/18275431/",
        "Ferritin levels in Focus children":
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
      "sideEffects": [
        "Common: constipation, dark stools, mild nausea",
        "Reduce dose or switch to bisglycinate form if GI upset occurs",
        "Rare: severe nausea or vomiting (stop immediately)",
        "Overdose risk: keep away from children"
      ],
      "form": "Tablet",
      "translations": {
        "it": {
          "name": "Ferro (Bisglicinato Ferroso)",
          "description":
              "Minerale essenziale per il trasporto dell'ossigeno e la sintesi dei neurotrasmettitori.",
          "mechanismOfAction":
              "Cofattore essenziale per la tirosina idrossilasi (enzima limitante nella sintesi di dopamina). Fondamentale per il trasporto dell'ossigeno via emoglobina.",
          "detailedBenefits": [
            "La correzione della carenza può migliorare le sfide di concentrazione del 30-40%",
            "Supporta la produzione di dopamina e norepinefrina",
            "Migliora la funzione cognitiva e riduce la stanchezza",
            "Migliora la risposta agli elementi di Tipo A in individui carenti"
          ],
          "timingRationale":
              "Assumere a stomaco vuoto per il miglior assorbimento, o con vitamina C. Evitare l'assunzione con calcio, caffè o tè.",
          "dosageFrequency":
              "Una volta al giorno a stomaco vuoto o con vitamina C",
          "dosageWarnings": [
            "CRITICO: Fare un esame del sangue (ferritina) prima di integrare",
            "NON integrare se la ferritina è >30 ng/mL (il ferro in eccesso è tossico)",
            "Tenere fuori dalla portata dei bambini",
            "Ripetere l'esame della ferritina ogni 3 mesi durante l'integrazione",
            "Interrompere in caso di stitichezza, nausea o feci scure"
          ],
          "tldr":
              "Essenziale per la sintesi della dopamina; integrare SOLO se gli esami del sangue confermano una carenza.",
          "sideEffects": [
            "Comune: stitichezza, feci scure, lieve nausea",
            "Ridurre la dose se si verificano disturbi gastrointestinali",
            "Raro: nausea grave o vomito",
            "Rischio di sovradosaggio: tenere lontano dai bambini"
          ]
        },
        "es": {
          "name": "Hierro (Bisglicinato Ferroso)",
          "description":
              "Mineral esencial para el transporte de oxígeno y la síntesis de neurotransmisores.",
          "mechanismOfAction":
              "Cofactor esencial para la tirosina hidroxilasa (enzima limitante en la síntesis de dopamina). Fundamental para el transporte de oxígeno vía hemoglobina.",
          "detailedBenefits": [
            "La corrección de la deficiencia puede mejorar los desafíos de concentración en un 30-40%",
            "Apoya la producción de dopamina y norepinefrina",
            "Mejora la función cognitiva y reduce la fatiga",
            "Mejora la respuesta a los elementos de Tipo A en individuos deficientes"
          ],
          "timingRationale":
              "Tomar con el estómago vacío para una mejor absorción, o con vitamina C. Evitar tomar con calcio, café o té.",
          "dosageFrequency":
              "Una vez al día con el estómago vacío o con vitamina C",
          "dosageWarnings": [
            "CRÍTICO: Hágase un análisis de sangre (ferritina) antes de suplementar",
            "NO suplementar si la ferritina es >30 ng/mL (el exceso de hierro es tóxico)",
            "Mantener fuera del alcance de los niños",
            "Repetir análisis de ferritina cada 3 meses durante la suplementación",
            "Suspender si experimenta estreñimiento, náuseas o heces oscuras"
          ],
          "tldr":
              "Esencial para la síntesis de dopamina; complementar SOLO si los análisis de sangre confirman una deficiencia.",
          "sideEffects": [
            "Común: estreñimiento, heces oscuras, náuseas leves",
            "Reducir dosis si ocurren molestias gastrointestinales",
            "Raro: náuseas graves o vómitos",
            "Riesgo de sobredosis: mantener fuera del alcance de los niños"
          ]
        }
      }
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
      "focusLevel": 5,
      "mechanismOfAction":
          "Precursor to both acetylcholine (learning/memory) and phosphatidylcholine (cell membrane repair). Increases dopamine receptor density and enhances mitochondrial ATP production in the brain.",
      "detailedBenefits": [
        "Improves sustained attention and focus by 15-20% in standard trials",
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
      "sideEffects": [
        "Rare: mild headache (usually resolves with lower dose)",
        "Occasional: digestive upset if taken on empty stomach",
        "Very rare: insomnia if taken late in the day",
        "Generally one of the safest nootropics available"
      ],
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "Citicolina (CDP-Colina)",
          "description":
              "Precursore della colina ad alta biodisponibilità che supporta l'energia cerebrale e la funzione dei neurotrasmettitori.",
          "mechanismOfAction":
              "Precursore sia dell'acetilcolina (apprendimento/memoria) che della fosfatidilcolina. Aumenta la densità dei recettori della dopamina e migliora la produzione di ATP mitocondriale.",
          "detailedBenefits": [
            "Migliora l'attenzione sostenuta e la concentrazione del 15-20%",
            "Potenzia la memoria di lavoro e la velocità di elaborazione",
            "Supporta il metabolismo energetico cerebrale e riduce l'affaticamento mentale",
            "Effetti neuroprotettivi contro lo stress ossidativo"
          ],
          "timingRationale":
              "Il dosaggio mattutino si allinea con le massime richieste cognitive. Gli effetti sono cumulativi in 4-6 settimane.",
          "dosageFrequency":
              "Una o due volte al giorno (mattina o primo pomeriggio)",
          "dosageWarnings": [
            "Iniziare con 250mg per valutare la tolleranza",
            "Dosi superiori a 500mg possono causare mal di testa in alcuni",
            "Assumere presto se influisce sul sonno (raro)",
            "Generalmente ben tollerato con minimi effetti collaterali"
          ],
          "tldr":
              "Nootropo premium che aumenta l'energia cerebrale, la dopamina e l'acetilcolina per una concentrazione sostenuta.",
          "sideEffects": [
            "Raro: lieve mal di testa",
            "Occasionale: disturbi digestivi a stomaco vuoto",
            "Molto raro: insonnia se assunto tardi",
            "Uno dei nootropi più sicuri disponibili"
          ]
        },
        "es": {
          "name": "Citicolina (CDP-Colina)",
          "description":
              "Precursor de colina de alta biodisponibilidad que apoya la energía cerebral y la función de los neurotransmisores.",
          "mechanismOfAction":
              "Precursor tanto de la acetilcolina (aprendizaje/memoria) como de la fosfatidilcolina. Aumenta la densidad de los receptores de dopamina y mejora la producción de ATP mitocondrial.",
          "detailedBenefits": [
            "Mejora la atención sostenida y la concentración en un 15-20%",
            "Potencia la memoria de trabajo y la velocidad de procesamiento",
            "Apoya el metabolismo energético cerebral y reduce la fatiga mental",
            "Efectos neuroprotectores contra el estrés oxidativo"
          ],
          "timingRationale":
              "La dosis matutina se alinea con las máximas demandas cognitivas. Los efectos son cumulativos en 4-6 semanas.",
          "dosageFrequency": "Una o dos veces al día (mañana o tarde temprano)",
          "dosageWarnings": [
            "Comience con 250mg para evaluar la tolerancia",
            "Dosis superiores a 500mg pueden causar dolores de cabeza",
            "Tomar temprano si afecta el sueño (raro)",
            "Generalmente bien tolerado con mínimos efectos secundarios"
          ],
          "tldr":
              "Nootrópico premium que aumenta la energía cerebral, la dopamina y la acetilcolina para una concentración sostenida.",
          "sideEffects": [
            "Raro: dolor de cabeza leve",
            "Ocasional: malestar digestivo con el estómago vacío",
            "Muy raro: insomnio si se toma tarde",
            "Uno de los nootrópicos más seguros disponibles"
          ]
        }
      }
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
      "focusLevel": 4,
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
        "NGF stimulation effects": "https://pubmed.ncbi.nlm.nih.gov/23510212/",
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
        "Consult advisor if you have mushroom allergies"
      ],
      "tldr":
          "Medicinal mushroom that stimulates nerve growth factor for enhanced neuroplasticity and cognitive function.",
      "sideEffects": [
        "Rare: mild GI upset or skin rash (allergic reaction)",
        "Very rare: respiratory difficulty (stop immediately if occurs)",
        "Generally well-tolerated with minimal side effects"
      ],
      "translations": {
        "it": {
          "name": "Lion's Mane (Fungo Criniera di Leone)",
          "description":
              "Fungo medicinale che stimola la crescita dei nervi e supporta la plasticità cerebrale.",
          "mechanismOfAction":
              "Stimola la sintesi del fattore di crescita nervoso (NGF) e del BDNF. Promuove la neurogenesi, la mielinizzazione e la plasticità sinaptica.",
          "detailedBenefits": [
            "Migliora la neuroplasticità e la flessibilità cognitiva",
            "Supporta la concentrazione e la chiarezza mentale senza stimolazione",
            "Neuroprotezione contro il declino cognitivo",
            "Può migliorare l'umore e ridurre l'ansia attraverso le vie dell'NGF"
          ],
          "timingRationale":
              "Il dosaggio mattutino supporta la funzione cognitiva diurna. Gli effetti sono cumulativi in 4-8 settimane.",
          "dosageFrequency":
              "Una o due volte al giorno con il cibo (mattino o diviso AM/PM)",
          "dosageWarnings": [
            "Iniziare con 500mg per valutare la tolleranza",
            "Gli effetti sono cumulativi - attendere 4-8 settimane per i benefici completi",
            "Può causare lievi disturbi gastrici inizialmente",
            "Consultare un medico in caso di allergie ai funghi"
          ],
          "tldr":
              "Fungo medicinale che stimola il fattore di crescita nervoso per una migliore neuroplasticità e funzione cognitiva.",
          "sideEffects": [
            "Raro: lievi disturbi gastrici o eruzioni cutanee (reazione allergica)",
            "Molto raro: difficoltà respiratoria (sospendere immediatamente)",
            "Generalmente ben tollerato con minimi effetti collaterali"
          ]
        },
        "es": {
          "name": "Melena de León (Hericium Erinaceus)",
          "description":
              "Hongo medicinal que estimula el crecimiento de los nervios y apoya la plasticidad cerebral.",
          "mechanismOfAction":
              "Estimula la síntesis del factor de crecimiento nervioso (NGF) y BDNF. Promueve la neurogénesis, la mielinización y la plasticidad sináptica.",
          "detailedBenefits": [
            "Mejora la neuroplasticidad y la flexibilidad cognitiva",
            "Apoya la concentración y la claridad mental sin estimulación",
            "Neuroprotección contra el deterioro cognitivo",
            "Puede mejorar el estado de ánimo y reducir la ansiedad a través de las vías del NGF"
          ],
          "timingRationale":
              "La dosis matutina apoya la función cognitiva diurna. Los efectos son acumulativos en 4-8 semanas.",
          "dosageFrequency":
              "Una o dos veces al día con comida (mañana o dividido AM/PM)",
          "dosageWarnings": [
            "Comience con 500mg para evaluar la tolerancia",
            "Los efectos son acumulativos - espere 4-8 semanas para beneficios completos",
            "Puede causar molestias gastrointestinales leves al principio",
            "Consulte a un médico si tiene alergia a los hongos"
          ],
          "tldr":
              "Hongo medicinal que estimula el factor de crecimiento nervioso para una mejor neuroplasticidad y función cognitiva.",
          "sideEffects": [
            "Raro: molestias gastrointestinales leves o erupción cutánea",
            "Muy raro: dificultad respiratoria (suspender inmediatamente)",
            "Generalmente bien tolerado con mínimos efectos secundarios"
          ]
        }
      }
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
      "focusLevel": 4,
      "mechanismOfAction":
          "Critical phospholipid component of neuronal cell membranes. Supports neurotransmitter receptor function, particularly acetylcholine. Modulates cortisol response and supports healthy HPA axis function. Enhances glucose metabolism in the brain.",
      "detailedBenefits": [
        "Improves working memory and information processing by 15-20%",
        "Enhances attention and reduces distractibility in Focus",
        "Reduces cortisol levels and stress-induced cognitive impairment",
        "Supports age-related cognitive maintenance"
      ],
      "timingRationale":
          "Can be taken any time of day with food for optimal absorption (fat-soluble). Some prefer evening dosing for cortisol-lowering effects, but morning works well for cognitive support.",
      "scientificEvidenceRank": 80,
      "studyLinks": {
        "Phosphatidylserine for Focus":
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
          "Essential brain phospholipid that enhances working memory, attention, and stress resilience in Focus.",
      "sideEffects": [
        "Rare: mild GI upset or insomnia (if taken late)",
        "Very rare: headache at high doses (>300mg)",
        "Generally well-tolerated with minimal side effects"
      ],
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "Fosfatidilserina (PS)",
          "description":
              "Fosfolipide essenziale per l'integrità delle membrane cellulari e la comunicazione tra neuroni.",
          "mechanismOfAction":
              "Componente fosfolipidico critico delle membrane cellulari neuronali. Supporta la funzione dei recettori dei neurotrasmettitori, in particolare l'acetilcolina. Modula la risposta al cortisolo e supporta una funzione sana dell'asse HPA. Potenzia il metabolismo del glucosio nel cervello.",
          "detailedBenefits": [
            "Migliora la memoria di lavoro e l'elaborazione delle informazioni del 15-20%",
            "Potenzia l'attenzione e riduce la distraibilità nel Focus",
            "Riduce i livelli di cortisolo e l'impairment cognitivo indotto dallo stress",
            "Supporta il mantenimento cognitivo legato all'età"
          ],
          "timingRationale":
              "Può essere assunto in qualsiasi momento della giornata con il cibo per un assorbimento ottimale (è liposolubile). Alcuni preferiscono il dosaggio serale per gli effetti di riduzione del cortisolo, ma il mattino funziona bene per il supporto cognitivo.",
          "dosageFrequency":
              "Una o due volte al giorno con pasti grassi (mattina e/o sera)",
          "dosageWarnings": [
            "Iniziare con 100mg per valutare la tolleranza",
            "Assumere con cibo contenente grassi per un assorbimento ottimale",
            "Può causare lieve insonnia se assunto tardi (raro)",
            "Scegliere PS derivata dal girasole in caso di allergie alla soia"
          ],
          "tldr":
              "Fosfolipide cerebrale essenziale che migliora la memoria di lavoro, l'attenzione e la resilienza allo stress."
        },
        "es": {
          "name": "Fosfatidilserina (PS)",
          "description":
              "Fosfolípido esencial para la integridad de las membranas celulares y la comunicación entre neuronas.",
          "mechanismOfAction":
              "Componente fosfolípido crítico de las membranas celulares neuronales. Apoya la función de los receptores de neurotransmisores, en particular la acetilcolina. Modula la respuesta al cortisol.",
          "detailedBenefits": [
            "Mejora la memoria de trabajo en un 15-20% en pruebas estándar",
            "Potencia la atención y reduce la distraibilidad en el Enfoque",
            "Reduce los niveles de cortisol y el deterioro cognitivo inducido por el estrés",
            "Apoya el mantenimiento cognitivo relacionado con la edad"
          ],
          "timingRationale":
              "Puede tomarse en cualquier momento del día con comida. Algunos prefieren la dosis vespertina para los efectos de reducción de cortisol.",
          "dosageFrequency":
              "Una o dos veces al día con comidas grasas (mañana y/o noche)",
          "dosageWarnings": [
            "Comience con 100mg para evaluar la tolerancia",
            "Tomar con alimentos que contengan grasa para una absorción óptima",
            "Puede causar insomnio leve si se toma tarde (raro)",
            "Elija PS derivada del girasol si tiene alérgicas a la soja"
          ],
          "tldr":
              "Fosfolípido cerebral esencial que mejora la memoria de trabajo, la atención y la resistencia al estrés."
        }
      }
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
      "focusLevel": 5,
      "mechanismOfAction":
          "Modulates serotonin, dopamine, and norepinephrine through crocin and safranal compounds. Acts as a mild NMDA receptor antagonist and enhances BDNF expression. Anti-inflammatory effects support neuronal health.",
      "detailedBenefits": [
        "Reduces impulsivity and restless energy comparable to low-dose methylphenidate",
        "Improves mood and reduces anxiety without sedation",
        "Enhances attention span and reduces distractibility",
        "Neuroprotective and anti-inflammatory properties"
      ],
      "timingRationale":
          "Morning dosing aligns with peak state periods. Effects build over 6-8 weeks. Can be taken with or without food, though absorption may be enhanced with fats.",
      "scientificEvidenceRank": 68,
      "studyLinks": {
        "Saffron vs methylphenidate for Focus":
            "https://pubmed.ncbi.nlm.nih.gov/30895760/",
        "Saffron for focus challenges":
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
        "May interact with blood pressure elements"
      ],
      "tldr":
          "Emerging Focus support with mood-stabilizing effects; some studies show efficacy comparable to low-dose Type As.",
      "sideEffects": [
        "Rare: mild nausea or headache at higher doses (>30mg)",
        "Very rare: dizziness or dry mouth",
        "Generally well-tolerated at recommended doses",
        "No significant side effects in most standard trials"
      ],
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "Zafferano (Crocus Sativus)",
          "description":
              "Spezia preziosa con proprietà stabilizzanti dell'umore e di supporto alla concentrazione.",
          "mechanismOfAction":
              "Modula serotonina, dopamina e norepinefrina. Agisce come blando antagonista del recettore NMDA e aumenta l'espressione del BDNF.",
          "detailedBenefits": [
            "Riduce l'impulsività e l'irrequietezza in modo paragonabile a bassi dosaggi di metilfenidato",
            "Migliora l'umore e riduce l'ansia senza sedazione",
            "Aumenta la durata dell'attenzione e riduce la distraibilità",
            "Proprietà neuroprotettive e antinfiammatorie"
          ],
          "timingRationale":
              "Il dosaggio mattutino si allinea con i periodi di picco. Gli effetti si accumulano in 6-8 settimane.",
          "dosageFrequency":
              "Una o due volte al giorno (mattina o diviso AM/PM)",
          "dosageWarnings": [
            "Non superare i 30mg al giorno",
            "Richiede 6-8 settimane per gli effetti completi",
            "Evitare in gravidanza",
            "Può interagire con farmaci per la pressione"
          ],
          "tldr":
              "Supporto emergente per il Focus con effetti stabilizzanti dell'umore; studi mostrano efficacia paragonabile a bassi dosaggi di Tipo A.",
          "sideEffects": [
            "Raro: lieve nausea o mal di testa",
            "Molto raro: vertigini o secchezza delle fauci",
            "Generalmente ben tollerato"
          ]
        },
        "es": {
          "name": "Azafrán (Crocus Sativus)",
          "description":
              "Especia valiosa con propiedades estabilizadoras del estado de ánimo y de apoyo a la concentración.",
          "mechanismOfAction":
              "Modula la serotonina, la dopamina y la norepinefrina. Actúa como un antagonista leve del receptor NMDA y aumenta la expresión de BDNF.",
          "detailedBenefits": [
            "Reduce la impulsividad y la inquietud de manera comparable a dosis bajas de metilfenidato",
            "Mejora el estado de ánimo y reduce la ansiedad sin sedación",
            "Aumenta la duración de la atención y la distraibilidad",
            "Propiedades neuroprotectoras y antiinflamatorias"
          ],
          "timingRationale":
              "La dosis matutina se alinea con los períodos de pico. Los efectos se acumulan en 6-8 semanas.",
          "dosageFrequency": "Una o dos veces al día (mañana o dividido AM/PM)",
          "dosageWarnings": [
            "No exceder los 30mg diarios",
            "Toma 6-8 semanas para efectos completos",
            "Evitar durante el embarazo",
            "Puede interactuar con medicamentos para la presión arterial"
          ],
          "tldr":
              "Apoyo emergente para el Enfoque con efectos estabilizadores del estado de ánimo; estudios muestran eficacia comparable a dosis bajas de Tipo A.",
          "sideEffects": [
            "Raro: náuseas leves o dolor de cabeza",
            "Muy raro: mareos o boca seca",
            "Generalmente bien tolerado"
          ]
        }
      }
    },
    {
      "id": "pycnogenol",
      "name": "Pycnogenol (Pine Bark Extract)",
      "category": "Antioxidant",
      "dosage": "1mg/kg",
      "timeOfDay": "morning",
      "benefits": ["Attention", "Hyperactivity Reduction", "Oxidative Stress"],
      "evidenceLevel": "moderate",
      "notes":
          "Standardized French maritime pine bark extract. Requires 8-12 weeks for full cognitive benefits.",
      "status": "beneficial",
      "focusLevel": 4,
      "mechanismOfAction":
          "Potent antioxidant containing proanthocyanidins that cross the blood-brain barrier. Enhances nitric oxide production for improved cerebral blood flow. Modulates dopamine and norepinephrine metabolism while reducing oxidative stress.",
      "detailedBenefits": [
        "Reduces restless energy and improves attention by 20-30% in standard trials",
        "Enhances antioxidant capacity and reduces neuroinflammation",
        "Improves concentration and visual-motor coordination",
        "May reduce need for Type A element in some cases"
      ],
      "timingRationale":
          "Morning dosing supports daytime cognitive function. Takes 8-12 weeks for full therapeutic effects. Take with food to enhance absorption and reduce GI upset.",
      "scientificEvidenceRank": 75,
      "studyLinks": {
        "Pycnogenol for Focus in children":
            "https://pubmed.ncbi.nlm.nih.gov/16499493/",
        "Attention and restless energy improvement":
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
          "Powerful antioxidant from pine bark that reduces restless energy and improves attention through enhanced blood flow.",
      "translations": {
        "it": {
          "name": "Picnogenolo (Estratto di Corteccia di Pino)",
          "description":
              "Potente antiossidante che migliora la circolazione e riduce lo stress ossidativo nel cervello.",
          "mechanismOfAction":
              "Antiossidante contenente proantocianidine. Migliora la produzione di ossido nitrico per un migliore flusso sanguigno cerebrale. Modula il metabolismo di dopamina e norepinefrina.",
          "detailedBenefits": [
            "Riduce l'irrequietezza e migliora l'attenzione del 20-30% nei test standard",
            "Potenzia la capacità antiossidante e riduce la neuroinfiammazione",
            "Migliora la concentrazione e la coordinazione visivo-motoria",
            "Può ridurre la necessità di elementi di Tipo A in alcuni casi"
          ],
          "timingRationale":
              "Il dosaggio mattutino supporta la funzione cognitiva diurna. Gli effetti sono cumulativi in 8-12 settimane.",
          "dosageFrequency":
              "Una o due volte al giorno con cibo (mattina o diviso AM/PM)",
          "dosageWarnings": [
            "Calcolare la dose come 1mg per kg di peso corporeo",
            "Richiede 8-12 settimane per gli effetti completi",
            "Può potenziare gli effetti degli anticoagulanti (monitorare se assunti)",
            "Iniziare con metà dose per valutare la tolleranza"
          ],
          "tldr":
              "Potente antiossidante dalla corteccia di pino che riduce l'irrequietezza e migliora l'attenzione attraverso un migliore flusso sanguigno."
        },
        "es": {
          "name": "Pycnogenol (Extracto de Corteza de Pino)",
          "description":
              "Potente antioxidante que mejora la circulación y reduce el estrés oxidativo en el cerebro.",
          "mechanismOfAction":
              "Antioxidante que contiene proantocianidinas. Mejora la producción de óxido nítrico para un mejor flujo sanguíneo cerebral. Modula el metabolismo de la dopamina y la norepinefrina.",
          "detailedBenefits": [
            "Reduce la inquietud y mejora la atención en un 20-30% en pruebas estándar",
            "Potencia la capacidad antioxidante y reduce la neuroinflamación",
            "Mejora la concentración y la coordinación visomotora",
            "Puede reducir la necesidad de elementos de Tipo A en algunos casos"
          ],
          "timingRationale":
              "La dosis matutina apoya la función cognitiva diurna. Los efectos son acumulativos en 8-12 semanas.",
          "dosageFrequency":
              "Una o dos veces al día con comida (mañana o dividido AM/PM)",
          "dosageWarnings": [
            "Calcule la dosis como 1mg por kg de peso corporal",
            "Toma 8-12 semanas para efectos completos",
            "Puede potenciar los efectos de los anticoagulantes (monitorear si se toman)",
            "Comience con media dosis para evaluar la tolerancia"
          ],
          "tldr":
              "Potente antioxidante de la corteza de pino que reduce la inquietud y mejora la atención a través de un mejor flujo sanguíneo."
        }
      },
      "sideEffects": [
        "Rare: mild headache (5-10% of users, usually dose-dependent)",
        "GI upset or nausea if taken on empty stomach",
        "Rare: dizziness or allergic skin reactions",
        "Very rare: increased bleeding or bruising (stop immediately)"
      ],
      "form": "Capsule"
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
      "focusLevel": 3,
      "mechanismOfAction":
          "Modulates gut-brain axis through vagus nerve signaling and neurotransmitter production. Beneficial bacteria produce GABA, serotonin precursors, and short-chain fatty acids that influence brain function. Reduces inflammation and supports immune regulation.",
      "detailedBenefits": [
        "Improves mood and reduces anxiety through gut-brain communication",
        "Supports production of neurotransmitters (90% of serotonin made in gut)",
        "Reduces inflammation linked to focus challenges",
        "Enhances nutrient absorption critical for brain function"
      ],
      "timingRationale":
          "Morning dosing on empty stomach (30 min before food) maximizes survival through stomach acid. Consistent daily use builds healthy microbiome over 4-8 weeks.",
      "scientificEvidenceRank": 65,
      "studyLinks": {
        "Probiotics and focus challenges":
            "https://pubmed.ncbi.nlm.nih.gov/31665527/",
        "Gut-brain axis in neurodevelopment":
            "https://pubmed.ncbi.nlm.nih.gov/30356668/",
        "Microbiome and cognitive wellness":
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
          "Supports gut-brain axis for neurotransmitter production; 90% of serotonin is produced in the gut.",
      "sideEffects": [
        "Common initially: mild bloating, gas, or digestive changes (1-2 weeks)",
        "Rare: allergic reaction to specific strains",
        "Very rare: infection in immunocompromised individuals",
        "Generally well-tolerated with minimal side effects"
      ],
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "Probiotici (Multi-Ceppo)",
          "description":
              "Batteri benefici che supportano l'asse intestino-cervello e la salute cognitiva generale.",
          "mechanismOfAction":
              "Modula l'asse intestino-cervello attraverso la segnalazione del nervo vago e la produzione di neurotrasmettitori (GABA, serotonina). Riduce l'infiammazione.",
          "detailedBenefits": [
            "Migliora l'umore e riduce l'ansia attraverso la comunicazione intestino-cervello",
            "Supporta la produzione di neurotrasmettitori (il 90% della serotonina è prodotta nell'intestino)",
            "Riduce l'infiammazione legata alle sfide di concentrazione",
            "Potenzia l'assorbimento dei nutrienti critici per la funzione cerebrale"
          ],
          "timingRationale":
              "Dosaggio mattutino a stomaco vuoto (30 min prima del cibo) per massimizzare la sopravvivenza all'acido gastrico.",
          "dosageFrequency":
              "Una volta al giorno a stomaco vuoto (30 min prima di colazione)",
          "dosageWarnings": [
            "Iniziare con una dose più bassa (5 miliardi di CFU) per valutare la tolleranza",
            "Può causare gonfiore o gas temporaneo (di solito si risolve in 1-2 settimane)",
            "Refrigerare per mantenere la potenza",
            "Scegliere formule multi-ceppo con Lactobacillus e Bifidobacterium"
          ],
          "tldr":
              "Batteri benefici che supportano la comunicazione intestino-cervello, la regolazione dell'umore e la produzione di neurotrasmettitori."
        },
        "es": {
          "name": "Probióticos (Multi-Cepa)",
          "description":
              "Bacterias beneficiosas que apoyan el eje intestino-cerebro y la salud cognitiva general.",
          "mechanismOfAction":
              "Modula el eje intestino-cerebro a través de la señalización del nervio vago y la producción de neurotransmisores (GABA, serotonina). Reduce la inflamación.",
          "detailedBenefits": [
            "Mejora el estado de ánimo y reduce la ansiedad a través de la comunicación intestino-cerebro",
            "Apoya la producción de neurotransmisores (el 90% de la serotonina se produce en el intestino)",
            "Reduce la inflamación ligada a los desafíos de concentración",
            "Potencia la absorción de nutrientes críticos para la función cerebral"
          ],
          "timingRationale":
              "Dosis matutina con el estómago vacío (30 min antes de la comida) para maximizar la supervivencia al ácido gástrico.",
          "dosageFrequency":
              "Una vez al día con el estómago vacío (30 min antes del desayuno)",
          "dosageWarnings": [
            "Comience con una dosis más baja (5 mil millones de UFC) para evaluar la tolerancia",
            "Puede causar hinchazón o gases temporales (generalmente se resuelve en 1-2 semanas)",
            "Refrigerar para mantener la potencia",
            "Elija fórmulas de múltiples cepas con Lactobacillus y Bifidobacterium"
          ],
          "tldr": "Bacterias beneficiosas que apoyan la comunicación intestino-cerebro, la regulación del estado de ánimo y la producción de neurotransmisores."
              "Bacterias beneficiosas que apoyan la comunicación intestino-cerebro, la regulación del estado de ánimo y la producción de neurotransmisores."
        }
      }
    },
    {
      "id": "red-dye-40",
      "name": "Red Dye 40 (Allura Red AC / E129)",
      "category": "Artificial Color",
      "description":
          "Synthetic petroleum-based food dye linked to significant behavioral problems in Focus. One of the 'Southampton Six' requiring warning labels in the EU.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Artificial dyes have been shown to trigger histamine release and may interfere with zinc metabolism. Zinc is a critical cofactor for neurotransmitter synthesis; its depletion can directly worsen restless energy and impulsivity in Focus-sensitive individuals.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Consumption should be eliminated to avoid behavioral flares.",
      "scientificEvidenceRank": 75,
      "studyLinks": {
        "Food additives and restless energy (Southampton)":
            "https://pubmed.ncbi.nlm.nih.gov/17825405/",
        "Artificial colors and Focus meta-analysis":
            "https://pubmed.ncbi.nlm.nih.gov/22331014/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Linked to increased restless energy in sensitive children",
        "May cause allergic reactions or skin sensitivity",
        "Listed as Allura Red AC or E129 on international labels",
        "Common in bright red snacks, cereals, and soft drinks"
      ],
      "tldr":
          "Synthetic red dye with high standard evidence for worsening Focus restless energy and impulsivity.",
      "form": "Liquid/Food Additive",
      "translations": {
        "it": {
          "name": "Rosso Allura AC (Red Dye 40 / E129)",
          "description":
              "Colorante sintetico a base di petrolio collegato a significativi problemi comportamentali nel Focus. Uno dei 'Southampton Six' che richiede etichette di avvertenza nell'UE.",
          "mechanismOfAction":
              "È stato dimostrato che i coloranti artificiali innescano il rilascio di istamina e possono interferire con il metabolismo dello zinco. Lo zinco è un cofattore critico per la sintesi dei neurotrasmettitori; la sua deplezione può peggiorare direttamente l'energia irrequieta e l'impulsività.",
          "timingRationale":
              "EVITARE: Il consumo dovrebbe essere eliminato per evitare riacutizzazioni comportamentali.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Collegato a un aumento dell'irrequietezza nei bambini sensibili",
            "Può causare reazioni allergiche o sensibilità cutanea",
            "Elencato come Rosso Allura AC o E129 sulle etichette internazionali",
            "Comune in snack rossi, cereali e bibite"
          ],
          "tldr":
              "Colorante rosso sintetico con elevate prove standard di peggioramento dell'energia irrequieta e dell'impulsività."
        },
        "es": {
          "name": "Rojo Allura AC (Red Dye 40 / E129)",
          "description":
              "Colorante sintético a base de petróleo vinculado a problemas de comportamiento significativos en Focus. Uno de los 'Southampton Six' que requiere etiquetas de advertencia en la UE.",
          "mechanismOfAction":
              "Se ha demostrado que los colorantes artificiales desencadenan la liberación de histamina y pueden interferir con el metabolismo del zinc. El zinc es un cofactor crítico para la síntesis de neurotransmisores; su agotamiento puede empeorar directamente la energía inquieta y la impulsividad.",
          "timingRationale":
              "EVITAR: El consumo debe eliminarse para evitar brotes de comportamiento.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Vinculado a un aumento de la inquietud en niños sensibles",
            "Puede causar reacciones alérgicas o sensibilidad en la piel",
            "Listado como Rojo Allura AC o E129 en etiquetas internacionales",
            "Común en bocadillos rojos, cereales y refrescos"
          ],
          "tldr":
              "Colorante rojo sintético con alta evidencia estándar de empeoramiento de la energía inquieta y la impulsividad."
        },
      }
    },
    {
      "id": "high-fructose-corn-syrup",
      "name": "High Fructose Corn Syrup (HFCS)",
      "category": "Sweetener",
      "description":
          "Highly processed sweetener that causes rapid blood sugar spikes and crashes, worsening focus challenges. Found in sodas, processed foods, and many packaged snacks.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "HFCS induces rapid insulin release leading to significant blood sugar fluctuations. The subsequent hypoglycemic 'crash' can temporarily deplete neurotransmitter reserves and cause intense brain fog, irritability, and worsened impulsivity in Focus individuals.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Consumption leads to neuro-energetic instability.",
      "scientificEvidenceRank": 70,
      "studyLinks": {
        "Sugar consumption and Focus behavior":
            "https://pubmed.ncbi.nlm.nih.gov/21129940/",
        "Sucrose vs HFCS in cognitive function":
            "https://pubmed.ncbi.nlm.nih.gov/16507461/"
      },
      "dosageByWeight": {
        "40-60": "0g (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Causes rapid blood sugar spikes followed by crashes",
        "Increases brain fog and difficulty concentrating",
        "Can lead to significant mood volatility",
        "Linked to systemic inflammation and metabolic stress"
      ],
      "tldr":
          "Processed sweetener causing blood sugar crashes and brain fog; avoid for stable energy and focus.",
      "form": "Liquid/Food Additive",
      "translations": {
        "it": {
          "name": "Sciroppo di Mais ad Alto Fruttosio (HFCS)",
          "description":
              "Dolcificante altamente processato che causa rapidi picchi e cali di zucchero nel sangue, peggiorando le sfide di concentrazione.",
          "mechanismOfAction":
              "L'HFCS induce un rapido rilascio di insulina portando a significative fluttuazioni della glicemia. Il successivo 'crollo' ipoglicemico può esaurire temporaneamente le riserve di neurotrasmettitori e causare nebbia cerebrale intensa, irritabilità e peggioramento dell'impulsività.",
          "timingRationale":
              "EVITARE: Il consumo porta a instabilità neuro-energetica.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Causa rapidi picchi di zucchero nel sangue seguiti da crolli",
            "Aumenta la nebbia cerebrale e la difficoltà di concentrazione",
            "Può portare a una significativa volatilità dell'umore",
            "Collegato a infiammazione sistemica e stress metabolico"
          ],
          "tldr":
              "Dolcificante processato che causa crolli di zucchero nel sangue e nebbia cerebrale; evitare per un'energia e una concentrazione stabili."
        },
        "es": {
          "name": "Jarabe de Maíz de Alta Fructosa (JMAF)",
          "description":
              "Edulcorante altamente procesado que causa picos y caídas rápidas de azúcar en la sangre, empeorando los desafíos de concentración.",
          "mechanismOfAction":
              "El JMAF induce una liberación rápida de insulina que conduce a fluctuaciones significativas de azúcar en la sangre. El posterior 'choque' hipoglucémico puede agotar temporalmente las reservas de neurotransmisores y causar niebla mental intensa, irritabilidad y empeoramiento de la impulsividad.",
          "timingRationale":
              "EVITAR: El consumo conduce a inestabilidad neuroenergética.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Causa picos rápidos de azúcar en la sangre seguidos de caídas",
            "Aumenta la niebla mental y la dificultad para concentrarse",
            "Puede provocar una volatilidad significativa del estado de ánimo",
            "Vinculado a la inflamación sistémica y al estrés metabólico"
          ],
          "tldr":
              "Edulcorante procesado que causa choques de azúcar en la sangre y niebla mental; evitar para una energía y concentración estables."
        }
      }
    },
    {
      "id": "sodium-benzoate",
      "name": "Sodium Benzoate (E211)",
      "category": "Preservative",
      "description":
          "Common preservative in soft drinks and processed foods that may increase restless energy when combined with artificial colors. Particularly problematic for children with Focus.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Sodium benzoate (E211) can cross the blood-brain barrier and has been shown to increase restless energy in its own right. It may interfere with mitochondrial function and potentially induce oxidative stress in the hippocampus.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Preservative with recognized behavioral impact.",
      "scientificEvidenceRank": 68,
      "studyLinks": {
        "Sodium benzoate and restless energy (Lancet)":
            "https://pubmed.ncbi.nlm.nih.gov/17825405/",
        "Cellular impact of food preservatives":
            "https://pubmed.ncbi.nlm.nih.gov/22331014/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Significantly amplifies the restless energy effects of synthetic food dyes",
        "May cause allergic flares or skin irritation in sensitive people",
        "Listed as Sodium Benzoate or E211",
        "Check for 'sodium benzoate' in sodas and condiments"
      ],
      "tldr":
          "Preservative linked to restless energy, especially when consumed with dyes; eliminate to reduce restlessness.",
      "form": "Liquid/Food Additive",
      "translations": {
        "it": {
          "name": "Benzoato di Sodio (E211)",
          "description":
              "Conservante comune nelle bevande analcoliche e negli alimenti processati che può aumentare l'energia irrequieta se combinato con coloranti artificiali.",
          "mechanismOfAction":
              "Il benzoato di sodio (E211) può attraversare la barriera emato-encefalica ed è stato dimostrato che aumenta l'energia irrequieta di per sé. Può interferire con la funzione mitocondriale e potenzialmente indurre stress ossidativo nell'ippocampo.",
          "timingRationale":
              "EVITARE: Conservante con impatto comportamentale riconosciuto.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Amplifica significativamente gli effetti dell'energia irrequieta dei coloranti alimentari sintetici",
            "Può causare reazioni allergiche o irritazioni cutanee in persone sensibili",
            "Elencato come Benzoato di Sodio o E211",
            "Controllare la presenza di 'benzoato di sodio' in bibite e condimenti"
          ],
          "tldr":
              "Conservante collegato all'energia irrequieta, specialmente se consumato con coloranti; eliminare per ridurre l'irrequietezza."
        },
        "es": {
          "name": "Benzoato de Sodio (E211)",
          "description":
              "Conservante común en refrescos y alimentos procesados que puede aumentar la energía inquieta cuando se combina con colorantes artificiales.",
          "mechanismOfAction":
              "El benzoato de sodio (E211) puede cruzar la barrera hematoencefálica y se ha demostrado que aumenta la energía inquieta por sí mismo. Puede interferir con la función mitocondrial y potencialmente inducir estrés oxidativo en el hipocampo.",
          "timingRationale":
              "EVITAR: Conservante con impacto conductual reconocido.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Amplifica significativamente los efectos de la energía inquieta de los colorantes alimentarios sintéticos",
            "Puede causar brotes alérgicos o irritación de la piel en personas sensibles",
            "Listado como Benzoato de Sodio o E211",
            "Busque 'benzoato de sodio' en refrescos y condimentos"
          ],
          "tldr":
              "Conservante vinculado a la energía inquieta, especialmente cuando se consume con colorantes; eliminar para reducir la inquietud."
        }
      }
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
      "focusLevel": 4,
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
        "Stress and working memory": "https://pubmed.ncbi.nlm.nih.gov/10688423/"
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
        "Take separately from Focus Profile As (competes for absorption)"
      ],
      "tldr":
          "Dopamine precursor amino acid; best for acute stress situations rather than daily use due to tolerance.",
      "translations": {
        "it": {
          "name": "L-Tirosina",
          "description":
              "Elemento costitutivo per dopamina, norepinefrina ed epinefrina. Meglio per situazioni di stress acuto.",
          "mechanismOfAction":
              "Si converte in L-DOPA tramite l'enzima tirosina idrossilasi, poi in dopamina. Supporta la sintesi delle catecolamine in condizioni di stress.",
          "detailedBenefits": [
            "Migliora le prestazioni cognitive sotto stress acuto",
            "Supporta la produzione di dopamina quando esaurita",
            "Può migliorare la memoria di lavoro durante compiti impegnativi",
            "Fornisce elementi costitutivi per la sintesi degli ormoni dello stress"
          ],
          "timingRationale":
              "Assumere a stomaco vuoto prima di compiti impegnativi. La tolleranza si sviluppa con l'uso quotidiano cronico.",
          "dosageFrequency":
              "Al bisogno o giornalmente (mattina) prima di compiti impegnativi",
          "dosageWarnings": [
            "Assumere a stomaco vuoto per evitare la competizione con altri aminoacidi",
            "La tolleranza si sviluppa entro 6 settimane con l'uso quotidiano",
            "Assumere separatamente da altri integratori di Tipo A",
            "Evitare in caso di ipertiroidismo o uso di MAO-inibitori"
          ],
          "tldr":
              "Aminoacido precursore della dopamina; meglio per situazioni di stress acuto piuttosto che per l'uso quotidiano a causa della tolleranza."
        },
        "es": {
          "name": "L-Tirosina",
          "description":
              "Bloque de construcción para dopamina, norepinefrina y epinefrina. Mejor para situaciones de estrés agudo.",
          "mechanismOfAction":
              "Se convierte en L-DOPA a través de la enzima tirosina hidroxilasa, luego en dopamina. Apoya la síntesis de catecolaminas en condiciones de estrés.",
          "detailedBenefits": [
            "Mejora el rendimiento cognitivo bajo estrés agudo",
            "Apoya la producción de dopamina cuando está agotada",
            "Puede mejorar la memoria de trabajo durante tareas exigentes",
            "Proporciona bloques de construcción para la síntesis de hormonas del estrés"
          ],
          "timingRationale":
              "Tomar con el estómago vacío antes de tareas exigentes. La tolerancia se desarrolla con el uso diario crónico.",
          "dosageFrequency":
              "Según sea necesario o diariamente (mañana) antes de tareas exigentes",
          "dosageWarnings": [
            "Tomar con el estómago vacío para evitar la competencia con otros aminoácidos",
            "La tolerancia se desarrolla en 6 semanas con el uso diario",
            "Tomar por separado de otros suplementos de Tipo A",
            "Evitar si padece hipertiroidismo o usa inhibidores de la MAO"
          ],
          "tldr":
              "Aminoácido precursor de dopamina; mejor para situaciones de estrés agudo que para el uso diario debido a la tolerancia."
        }
      },
      "sideEffects": [
        "Rare: headache or nausea at high doses",
        "Possible: irritability or anxiety if overstimulated",
        "Tolerance develops quickly with daily use",
        "Generally safe at recommended doses"
      ],
      "form": "Capsule"
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
      "focusLevel": 3,
      "mechanismOfAction":
          "B vitamins serve as essential cofactors for enzymes involved in dopamine, norepinephrine, and serotonin synthesis. Methylated forms (L-methylfolate, methylcobalamin) bypass genetic polymorphisms (MTHFR) that impair folate metabolism in 40-60% of the population.",
      "detailedBenefits": [
        "B6 (P5P) converts L-DOPA to dopamine via aromatic L-amino acid decarboxylase",
        "B9 (methylfolate) supports BH4 synthesis, required for tyrosine hydroxylase",
        "B12 (methylcobalamin) maintains myelin and supports methylation cycles",
        "Reduces homocysteine levels which can impair cognitive function"
      ],
      "timingRationale":
          "Morning dosing aligns with peak dopamine synthesis needs. B vitamins are water-soluble and absorbed quickly (30-60 min). Avoid evening dosing as B vitamins can be energizing and may interfere with sleep.",
      "scientificEvidenceRank": 85,
      "studyLinks": {
        "B vitamins and focus challenges":
            "https://pubmed.ncbi.nlm.nih.gov/27521327/",
        "Methylfolate in Focus with MTHFR polymorphism":
            "https://pubmed.ncbi.nlm.nih.gov/24284437/",
        "B6 and neurotransmitter synthesis":
            "https://pubmed.ncbi.nlm.nih.gov/18950248/"
      },
      "dosageByWeight": {
        "40-60": "25-50mg B-complex",
        "60-80": "50mg B-complex",
        "80-100": "50-100mg B-complex",
        "100-120": "100mg B-complex"
      },
      "dosageFrequency": "Once daily with breakfast",
      "dosageWarnings": [
        "High-dose B6 (\u003e100mg long-term) may cause peripheral neuropathy",
        "Niacin (B3) may cause flushing; use 'flush-free' forms if sensitive",
        "Methylated forms preferred for those with MTHFR mutations"
      ],
      "tldr":
          "Essential cofactors for neurotransmitter synthesis; methylated forms support dopamine production and bypass genetic limitations.",
      "translations": {
        "it": {
          "name": "Complesso Vitaminico B (Metilato)",
          "description":
              "Forma metilata (metilfolato, metilcobalamina) preferita. Cofattori essenziali per la produzione di dopamina.",
          "mechanismOfAction":
              "Le vitamine B servono come cofattori essenziali per gli enzimi coinvolti nella sintesi di dopamina, norepinefrina e serotonina. Le forme metilate aggirano i polimorfismi genetici (MTHFR).",
          "detailedBenefits": [
            "La B6 (P5P) converte la L-DOPA in dopamina",
            "La B9 (metilfolato) supporta la sintesi di BH4",
            "La B12 (metilcobalamina) mantiene la mielina e supporta i cicli di metilazione",
            "Riduce i livelli di omocisteina che possono compromettere la funzione cognitiva"
          ],
          "timingRationale":
              "Dosaggio mattutino con la colazione. Evitare la sera.",
          "dosageFrequency": "Una volta al giorno con la colazione",
          "dosageWarnings": [
            "Alte dosi di B6 (>100mg) possono causare neuropatia periferica",
            "La niacina (B3) può causare vampate; usare forme 'flush-free'",
            "Forme metilate preferite per chi ha mutazioni MTHFR"
          ],
          "tldr":
              "Cofattori essenziali per la sintesi dei neurotrasmettitori; le forme metilate supportano la produzione di dopamina e aggirano le limitazioni genetiche."
        },
        "es": {
          "name": "Complejo de Vitamina B (Metilado)",
          "description":
              "Se prefiere la forma metilada (metilfolato, metilcobalamina). Cofactores esenciales para la producción de dopamina.",
          "mechanismOfAction":
              "Las vitaminas B sirven como cofactores esenciales para las enzimas involucradas en la síntesis de dopamina, norepinefrina y serotonina. Las formas metiladas evitan los polimorfismos genéticos (MTHFR).",
          "detailedBenefits": [
            "La B6 (P5P) convierte la L-DOPA en dopamina",
            "La B9 (metilfolato) apoya la síntesis de BH4, necesaria para la tirosina hidroxilasa",
            "La B12 (metilcobalamina) mantiene la mielina y apoya los ciclos de metilación",
            "Reduce los niveles de homocisteína que pueden afectar la función cognitiva"
          ],
          "timingRationale":
              "Dosis matutina con el desayuno. Evitar por la noche.",
          "dosageFrequency": "Una vez al día con el desayuno",
          "dosageWarnings": [
            "Dosis altas de B6 (>100mg) pueden causar neuropatía periférica",
            "La niacina (B3) puede causar sofocos; use formas 'flush-free'",
            "Formas metiladas preferidas para quienes tienen mutaciones MTHFR"
          ],
          "tldr":
              "Cofactores esenciales para la síntesis de neurotransmisores; las formas metiladas apoyan la producción de dopamina y evitan las limitaciones genéticas."
        }
      },
      "form": "Capsule"
    },
    {
      "id": "rhodiola-rosea",
      "name": "Rhodiola Rosea",
      "category": "Adaptogen",
      "dosage": "200-400mg",
      "timeOfDay": "morning",
      "benefits": [
        "Mental Fatigue Reduction",
        "Stress Resilience",
        "Sustained Attention"
      ],
      "evidenceLevel": "moderate",
      "notes":
          "Standardized to 3% rosavins and 1% salidroside. Adaptogen that reduces mental fatigue without sedation.",
      "status": "beneficial",
      "focusLevel": 5,
      "mechanismOfAction":
          "Rhodiola modulates the HPA (hypothalamic-pituitary-adrenal) axis to improve stress resilience. It increases availability of serotonin and dopamine in the prefrontal cortex by inhibiting monoamine oxidase (MAO) enzymes. Also enhances ATP synthesis and reduces cortisol during chronic stress.",
      "detailedBenefits": [
        "Reduces mental fatigue during sustained cognitive tasks by 20-30%",
        "Improves stress-induced attention deficits",
        "Enhances working memory under pressure",
        "Supports dopamine and serotonin availability without depletion"
      ],
      "timingRationale":
          "Morning or early afternoon dosing recommended. Effects begin within 30 minutes and peak at 1-2 hours. Avoid evening use as it can be mildly stimulating and may interfere with sleep.",
      "scientificEvidenceRank": 76,
      "studyLinks": {
        "Rhodiola for mental fatigue":
            "https://pubmed.ncbi.nlm.nih.gov/19016404/",
        "Adaptogenic effects on stress":
            "https://pubmed.ncbi.nlm.nih.gov/11410073/",
        "Cognitive enhancement in fatigue":
            "https://pubmed.ncbi.nlm.nih.gov/20378318/"
      },
      "dosageByWeight": {
        "40-60": "200mg",
        "60-80": "300mg",
        "80-100": "400mg",
        "100-120": "400-500mg"
      },
      "dosageFrequency": "Once or twice daily (morning and early afternoon)",
      "dosageWarnings": [
        "May be mildly stimulating - avoid evening dosing",
        "Start with lower dose to assess tolerance",
        "Avoid with bipolar disorder (may trigger manic episodes)",
        "Generally well-tolerated with minimal side effects"
      ],
      "tldr":
          "Adaptogen that reduces mental fatigue and enhances stress resilience by modulating dopamine and serotonin.",
      "sideEffects": [
        "Rare: mild jitteriness or overstimulation",
        "Possible: dry mouth or dizziness",
        "Very rare: agitation in bipolar individuals",
        "Generally well-tolerated at recommended doses"
      ],
      "form": "Capsule",
      "translations": {
        "it": {
          "name": "Rodiola Rosea",
          "description":
              "Standardizzato al 3% rosavine e 1% salidroside. Adattogeno che riduce l'affaticamento mentale senza sedazione.",
          "mechanismOfAction":
              "La Rodiola modula l'asse HPA (ipotalamo-ipofisi-surrene) per migliorare la resilienza allo stress. Aumenta la disponibilità di serotonina e dopamina nella corteccia prefrontale inibendo gli enzimi monoaminossidasi (MAO). Migliora anche la sintesi di ATP e riduce il cortisolo durante lo stress cronico.",
          "timingRationale":
              "Dosaggio mattutino o primo pomeriggio raccomandato. Gli effetti iniziano entro 30 minuti e raggiungono il picco a 1-2 ore. Evitare l'uso serale in quanto può essere leggermente stimolante e può interferire con il sonno.",
          "detailedBenefits": [
            "Riduce l'affaticamento mentale del 20-30% durante compiti prolungati",
            "Migliora i deficit di attenzione indotti dallo stress",
            "Potenzia la memoria di lavoro sotto pressione",
            "Supporta la disponibilità di dopamina senza esaurimento"
          ],
          "dosageFrequency":
              "Una o due volte al giorno (mattina o primo pomeriggio)",
          "dosageWarnings": [
            "Iniziare con 200mg per valutare la stimolazione",
            "Efficacia rapida rispetto ad altri adattogeni",
            "Può causare insonnia se assunta tardi",
            "Standardizzata al 3% rosavine e 1% salidroside"
          ],
          "tldr":
              "Adattogeno che riduce l'affaticamento mentale e migliora la resilienza allo stress modulando dopamina e serotonina."
        },
        "es": {
          "name": "Rhodiola Rosea",
          "description":
              "Estandarizado al 3% de rosavinas y 1% de salidrosida. Adaptógeno que reduce la fatiga mental sin sedación.",
          "mechanismOfAction":
              "La Rhodiola modula el eje HPA para mejorar la resiliencia al estrés. Aumenta la disponibilidad de serotonina y dopamina al inhibir las enzimas MAO.",
          "detailedBenefits": [
            "Reduce la fatiga mental en un 20-30% durante tareas prolongadas",
            "Mejora los déficits de atención inducidos por el estrés",
            "Potencia la memoria de trabajo bajo presión",
            "Apoya la disponibilidad de dopamina sin agotamiento"
          ],
          "timingRationale":
              "Se recomienda la dosis por la mañana o temprano en la tarde. Evite el uso nocturno ya que puede ser levemente estimulante.",
          "dosageFrequency": "Una o dos veces al día (mañana o tarde temprano)",
          "dosageWarnings": [
            "Comience con 200mg para evaluar la estimulación",
            "Eficacia rápida en comparación con otros adaptógenos",
            "Puede causar insomnio si se toma tarde",
            "Estandarizado al 3% de rosavinas y 1% de salidrósido"
          ],
          "tldr":
              "Adaptógeno que reduce la fatiga mental y mejora la resiliencia al estrés modulando la dopamina y la serotonina."
        }
      }
    },
    {
      "id": "ashwagandha",
      "name": "Ashwagandha (KSM-66)",
      "category": "Adaptogen",
      "dosage": "300-600mg",
      "timeOfDay": "evening",
      "benefits": ["Stress Reduction", "Anxiety Management", "Sleep Quality"],
      "evidenceLevel": "high",
      "notes":
          "KSM-66 or Sensoril extracts preferred. Reduces cortisol and anxiety. Best for evening use due to calming effects.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "Ashwagandha's withanolides modulate GABAergic signaling to reduce anxiety and promote relaxation. It lowers cortisol levels by regulating the HPA axis. Also enhances BDNF (brain-derived neurotrophic factor) which supports neuroplasticity and stress resilience.",
      "detailedBenefits": [
        "Reduces cortisol levels by 23-28% in chronic stress",
        "Improves sleep quality and reduces sleep latency",
        "Reduces anxiety challenges by 40-50% in standard trials",
        "Supports executive function recovery after stressful periods"
      ],
      "timingRationale":
          "Evening dosing (1-2 hours before bed) is optimal for most people due to calming effects. Some may tolerate morning dosing for daytime anxiety, but it can cause drowsiness. Effects build over 2-4 weeks of consistent use.",
      "scientificEvidenceRank": 82,
      "studyLinks": {
        "Ashwagandha for stress and anxiety":
            "https://pubmed.ncbi.nlm.nih.gov/23439798/",
        "Cortisol reduction in chronic stress":
            "https://pubmed.ncbi.nlm.nih.gov/31517876/",
        "Sleep quality improvement": "https://pubmed.ncbi.nlm.nih.gov/31728244/"
      },
      "dosageByWeight": {
        "40-60": "300mg",
        "60-80": "400-500mg",
        "80-100": "500-600mg",
        "100-120": "600mg"
      },
      "dosageFrequency":
          "Once daily in the evening, or split into morning/evening doses",
      "dosageWarnings": [
        "May cause drowsiness - avoid driving after taking",
        "Can lower blood pressure and blood sugar - monitor if on elements",
        "Avoid during pregnancy (may stimulate uterine contractions)",
        "May interact with thyroid elements (can increase T4 levels)"
      ],
      "tldr":
          "Powerful adaptogen that reduces cortisol and anxiety; best for evening use to support sleep and stress recovery.",
      "translations": {
        "it": {
          "name": "Ashwagandha (KSM-66)",
          "description":
              "Estratti KSM-66 o Sensoril preferiti. Riduce il cortisolo e l'ansia. Ideale per l'uso serale grazie agli effetti calmanti.",
          "mechanismOfAction":
              "I witanolidi dell'Ashwagandha modulano la segnalazione GABAergica per ridurre l'ansia e promuovere il rilassamento. Abbassa i livelli di cortisolo regolando l'asse HPA. Migliora anche il BDNF (fattore neurotrofico derivato dal cervello) che supporta la neuroplasticità e la resilienza allo stress.",
          "timingRationale":
              "Il dosaggio serale (1-2 ore prima di coricarsi) è ottimale per la maggior parte delle persone grazie agli effetti calmanti. Alcuni possono tollerare il dosaggio mattutino per l'ansia diurna, ma può causare sonnolenza. Gli effetti si accumulano in 2-4 settimane di uso costante.",
          "detailedBenefits": [
            "Riduce i livelli di cortisolo del 23-28% nello stress cronico",
            "Migliora la qualità del sonno e riduce la latenza del sonno",
            "Riduce le sfide legate all'ansia del 40-50%",
            "Supporta il recupero della funzione esecutiva dopo periodi di stress"
          ],
          "dosageFrequency":
              "Una volta al giorno la sera, o divisa in dosi mattutine/serali",
          "dosageWarnings": [
            "Può causare sonnolenza - evitare di guidare dopo l'assunzione",
            "Può abbassare la pressione sanguigna e lo zucchero nel sangue",
            "Evitare in gravidanza",
            "Può interagire con i farmaci per la tiroide"
          ],
          "tldr":
              "Potente adattogeno che riduce il cortisolo e l'ansia; ideale per l'uso serale per supportare il sonno e il recupero dallo stress."
        },
        "es": {
          "name": "Ashwagandha (KSM-66)",
          "description":
              "Se prefieren extractos KSM-66 o Sensoril. Reduce el cortisol y la ansiedad. Mejor para uso nocturno debido a sus efectos calmantes.",
          "mechanismOfAction":
              "Los withanólidos de Ashwagandha modulan la señalización GABAérgica para reducir la ansiedad y promover la relajación. Reduce los niveles de cortisol regulando el eje HPA. También mejora el BDNF (factor neurotrófico derivado del cerebro) que apoya la neuroplasticidad y la resiliencia al estrés.",
          "detailedBenefits": [
            "Reduce los niveles de cortisol en un 23-28% en estrés crónico",
            "Mejora la calidad del sueño y reduce la latencia del sueño",
            "Reduce los desafíos de ansiedad en un 40-50% en ensayos estándar",
            "Apoya la recuperación de la función ejecutiva después de períodos estresantes"
          ],
          "timingRationale":
              "La dosis nocturna (1-2 horas antes de acostarse) es óptima para la mayoría de las personas debido a los efectos calmantes. Algunos pueden tolerar la dosis matutina para la ansiedad diurna, pero puede causar somnolencia. Los efectos se acumulan durante 2-4 semanas de uso constante.",
          "dosageFrequency": "Una o dos veces al día (mañana y/o noche)",
          "dosageWarnings": [
            "Evitar si padece enfermedades autoinmunes o hipertiroidismo",
            "Eficacia acumulativa; requiere 4-8 semanas para efectos máximos",
            "Puede causar somnolencia leve en algunos individuos",
            "El extracto KSM-66® es el más estudiado para funciones cognitivas"
          ],
          "tldr":
              "Potente adaptógeno que reduce el cortisol y la ansiedad; mejor para uso nocturno para apoyar el sueño y la recuperación del estrés."
        }
      }
    },
    {
      "id": "vitamin-c",
      "name": "Vitamin C (Ascorbic Acid)",
      "category": "Vitamin",
      "dosage": "500-1000mg",
      "timeOfDay": "morning",
      "benefits": [
        "Antioxidant Protection",
        "Dopamine Synthesis",
        "Immune Support"
      ],
      "evidenceLevel": "high",
      "notes":
          "⚠️ TIMING CRITICAL: Take 1+ hours BEFORE or 4+ hours AFTER Type A elements. Acidifies urine which increases Type A excretion.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "Vitamin C is a cofactor for dopamine beta-hydroxylase, the enzyme that converts dopamine to norepinephrine. It also protects catecholamines from oxidation and supports adrenal function. However, it acidifies urine which significantly increases the excretion rate of amphetamine-based Type As.",
      "detailedBenefits": [
        "Essential cofactor for dopamine-to-norepinephrine conversion",
        "Protects neurotransmitters from oxidative degradation",
        "Supports adrenal health during chronic stress",
        "Powerful antioxidant for brain tissue protection"
      ],
      "timingRationale":
          "CRITICAL: Vitamin C acidifies urine, which increases amphetamine excretion by up to 50%. Take at least 1 hour BEFORE Type A element, or wait 4+ hours after. Evening dosing (after routine item has worn off) is safest for those on Type As.",
      "scientificEvidenceRank": 88,
      "studyLinks": {
        "Vitamin C and dopamine synthesis":
            "https://pubmed.ncbi.nlm.nih.gov/7002348/",
        "Urinary pH and amphetamine excretion":
            "https://pubmed.ncbi.nlm.nih.gov/7361718/",
        "Antioxidant effects in brain":
            "https://pubmed.ncbi.nlm.nih.gov/15350981/"
      },
      "dosageByWeight": {
        "40-60": "500mg",
        "60-80": "750mg",
        "80-100": "1000mg",
        "100-120": "1000-1500mg"
      },
      "dosageFrequency":
          "Once or twice daily, timing separated from Type A elements",
      "dosageWarnings": [
        "⚠️ CRITICAL: Reduces effectiveness of your Routine Protocol if taken together",
        "Take 1+ hours BEFORE or 4+ hours AFTER Type A elements",
        "High doses (>2000mg) may cause GI upset or diarrhea",
        "Generally very safe; excess is excreted in urine"
      ],
      "tldr":
          "Essential for dopamine synthesis but MUST be timed carefully - acidifies urine and reduces Type A effectiveness.",
      "translations": {
        "it": {
          "name": "Vitamina C (Acido Ascorbico)",
          "description":
              "Cofattore essenziale per la sintesi della dopamina. ATTENZIONE: Acidifica le urine, riducendo l'efficacia degli elementi di Tipo A.",
          "mechanismOfAction":
              "La vitamina C è un cofattore per la dopamina beta-idrossilasi, l'enzima che converte la dopamina in norepinefrina. Protegge anche le catecolamine dall'ossidazione. Tuttavia, acidifica le urine che aumenta significativamente il tasso di escrezione dei farmaci anfetaminici.",
          "detailedBenefits": [
            "Cofattore essenziale per la conversione da dopamina a norepinefrina",
            "Protegge i neurotrasmettitori dalla degradazione ossidativa",
            "Supporta la salute surrenale durante lo stress cronico",
            "Potente antiossidante per la protezione del tessuto cerebrale"
          ],
          "timingRationale":
              "CRITICO: Assumere almeno 1 ora PRIMA o 4 ore DOPO gli elementi di Tipo A. L'uso serale è il più sicuro per chi assume stimolanti.",
          "dosageFrequency":
              "Una volta al giorno (preferibilmente la sera per chi assume stimolanti)",
          "dosageWarnings": [
            "CRITICO: Riduce l'efficacia del protocollo se assunto insieme",
            "Assumere 1+ ore PRIMA o 4+ ore DOPO elementi di Tipo A",
            "Dosi elevate (>2000mg) possono causare disturbi gastrici",
            "Generalmente molto sicuro; l'eccesso viene escreto nelle urine"
          ],
          "tldr":
              "Essenziale per la sintesi della dopamina ma DEVE essere temporizzata attentamente - acidifica le urine e riduce l'efficacia del Tipo A."
        },
        "es": {
          "name": "Vitamina C (Ácido Ascórbico)",
          "description":
              "Cofactor esencial para la síntesis de dopamina. PRECAUCIÓN: Acidifica la orina, reduciendo la eficacia de los elementos de Tipo A.",
          "mechanismOfAction":
              "La vitamina C es un cofactor para la dopamina beta-hidroxilasa, la enzima que convierte la dopamina en norepinefrina. También protege las catecolaminas de la oxidación. Sin embargo, acidifica la orina, lo que aumenta significativamente la tasa de excreción de medicamentos anfetamínicos.",
          "detailedBenefits": [
            "Cofactor esencial para la conversión de dopamina a norepinefrina",
            "Protege los neurotransmisores de la degradación oxidativa",
            "Apoya la salud suprarrenal durante el estrés crónico",
            "Potente antioxidante para la protección del tejido cerebral"
          ],
          "timingRationale":
              "CRÍTICO: Tomar al menos 1 hora ANTES o 4 horas DESPUÉS de los elementos de Tipo A. El uso nocturno es el más seguro para quienes toman estimulantes.",
          "dosageFrequency":
              "Una vez al día (preferiblemente por la noche para usuarios de estimulantes)",
          "dosageWarnings": [
            "CRÍTICO: Reduce la eficacia de su protocolo si se toma en conjunto",
            "Tomar 1+ horas ANTES o 4+ horas DESPUÉS de elementos Tipo A",
            "Dosis altas (>2000mg) pueden causar molestias gástricas",
            "Generalmente muy seguro; el exceso se excreta en la orina"
          ],
          "tldr":
              "Esencial para la síntesis de dopamina, pero DEBE programarse con cuidado: acidifica la orina y reduce la eficacia del Tipo A."
        }
      },
    },
    {
      "id": "acetyl-l-carnitine",
      "name": "Acetyl-L-Carnitine (ALCAR)",
      "category": "Amino Acid",
      "dosage": "500-1500mg",
      "timeOfDay": "morning",
      "benefits": [
        "Mental Energy",
        "Acetylcholine Production",
        "Inattentive Flow"
      ],
      "evidenceLevel": "high",
      "notes":
          "Crosses blood-brain barrier to enhance mitochondrial energy and increase dopamine. Significant benefit specifically for inattentive subtype Focus.",
      "status": "beneficial",
      "focusLevel": 4,
      "mechanismOfAction":
          "ALCAR is the acetylated form of L-carnitine that crosses the blood-brain barrier. It donates acetyl groups for acetylcholine synthesis (key neurotransmitter for attention and memory). Also transports fatty acids into mitochondria for ATP production and provides neuroprotective benefits.",
      "detailedBenefits": [
        "Enhances acetylcholine synthesis for improved attention",
        "Reduces inattentive-type challenges by 20-30% in trials",
        "Supports mitochondrial energy production in neurons",
        "Improves mental fatigue and processing speed"
      ],
      "timingRationale":
          "Morning dosing on an empty stomach maximizes absorption. Effects are noticeable within 30-60 minutes. Avoid evening dosing as it can be energizing and may interfere with sleep.",
      "scientificEvidenceRank": 78,
      "studyLinks": {
        "ALCAR for Focus inattentive type":
            "https://pubmed.ncbi.nlm.nih.gov/17444943/",
        "ALCAR for cognitive function":
            "https://pubmed.ncbi.nlm.nih.gov/28178168/",
        "Mitochondrial support in aging":
            "https://pubmed.ncbi.nlm.nih.gov/18065594/"
      },
      "dosageByWeight": {
        "40-60": "500-1000mg",
        "60-80": "750-1000mg",
        "80-100": "1000-1500mg",
        "100-120": "1500-2000mg"
      },
      "dosageFrequency":
          "Once or twice daily (morning, or morning + early afternoon)",
      "dosageWarnings": [
        "Most effective for inattentive-type Focus specifically",
        "May be stimulating - avoid evening dosing",
        "High doses (>2000mg) may cause fishy body odor (rare)",
        "Start with 500mg to assess cognitive tolerance"
      ],
      "tldr":
          "Supports brain energy and acetylcholine; particularly researched for the inattentive subtype of Focus.",
      "translations": {
        "it": {
          "name": "Acetil-L-Carnitina (ALCAR)",
          "description":
              "Attraversa la barriera emato-encefalica per aumentare l'energia mitocondriale e la dopamina. Beneficio significativo specificamente per il Focus di tipo disattento.",
          "mechanismOfAction":
              "ALCAR è la forma acetilata della L-carnitina che attraversa la barriera emato-encefalica. Dona gruppi acetilici per la sintesi dell'acetilcolina. Trasporta anche gli acidi grassi nei mitocondri per la produzione di ATP.",
          "timingRationale":
              "Dosaggio mattutino a stomaco vuoto. Evitare l'uso serale in quanto può essere energizzante.",
          "detailedBenefits": [
            "Potenzia la sintesi di acetilcolina per migliorare l'attenzione",
            "Riduce le sfide di tipo disattento del 20-30% nei test",
            "Supporta la produzione di energia mitocondriale nei neuroni",
            "Migliora l'affaticamento mentale e la velocità di elaborazione"
          ],
          "dosageFrequency":
              "Una o due volte al giorno (mattina o primo pomeriggio)",
          "dosageWarnings": [
            "Più efficace per il Focus di tipo disattento",
            "Può essere stimolante - evitare il dosaggio serale",
            "Dosi elevate (>2000mg) possono causare odore corporeo di pesce",
            "Iniziare con 500mg per valutare la tolleranza"
          ],
          "tldr":
              "Supporta l'energia cerebrale e l'acetilcolina; particolarmente ricercato per il sottotipo disattento di Focus."
        },
        "es": {
          "name": "Acetil-L-Carnitina (ALCAR)",
          "description":
              "Cruza la barrera hematoencefálica para mejorar la energía mitocondrial y aumentar la dopamina. Beneficio significativo específicamente para el Enfoque de tipo inatento.",
          "mechanismOfAction":
              "ALCAR es la forma acetilada de L-carnitina que cruza la barrera hematoencefálica. Dona grupos acetilo para la síntesis de acetilcolina. También transporta ácidos grasos a las mitocondrias para la producción de ATP.",
          "timingRationale":
              "Dosis matutina con el estómago vacío. Evite el uso nocturno, ya que puede ser energizante.",
          "detailedBenefits": [
            "Mejora la síntesis de acetilcolina para mejorar la atención",
            "Reduce los desafíos de tipo inatento en un 20-30%",
            "Apoya la producción de energía miotocondrial en las neuronas",
            "Mejora la fatiga mental y la velocidad de procesamiento"
          ],
          "dosageFrequency": "Una o dos veces al día (mañana o tarde temprano)",
          "dosageWarnings": [
            "Más eficaz para el Enfoque de tipo inatento específicamente",
            "Puede ser estimulante - evite la dosis vespertina",
            "Dosis altas (>2000mg) pueden causar olor corporal a pescado",
            "Comience con 500mg para evaluar la tolerancia cognitiva"
          ],
          "tldr":
              "Apoya la energía cerebral y la acetilcolina; particularmente investigado para el subtipo inatento de Enfoque."
        }
      },
      "sideEffects": [
        "Occasional: fishy body odor at high doses (>2000mg)",
        "Rare: mild GI upset or nausea",
        "Possible: increased energy/restlessness",
        "Generally well-tolerated at recommended doses"
      ]
    },
    {
      "id": "creatine",
      "name": "Creatine Monohydrate",
      "category": "Amino Acid",
      "dosage": "5g",
      "timeOfDay": "any",
      "benefits": [
        "Brain Energy",
        "Working Memory",
        "Mental Fatigue Resistance"
      ],
      "evidenceLevel": "high",
      "notes":
          "Monohydrate form is most researched. Supports ATP regeneration in brain cells. Particularly effective for sleep-deprived individuals.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "Creatine phosphate serves as a rapid ATP buffer in cells with high energy demands (brain, muscles). It donates phosphate groups to regenerate ATP from ADP, providing immediate energy for cognitive tasks. Brain creatine levels correlate with working memory performance and mental fatigue resistance.",
      "detailedBenefits": [
        "Improves working memory by 10-20% in research trials",
        "Reduces mental fatigue during sustained cognitive tasks",
        "Particularly effective during sleep deprivation",
        "Supports neuroprotection and brain energy reserves"
      ],
      "timingRationale":
          "Timing is flexible - creatine works through saturation (loading brain stores over 2-4 weeks). Can be taken any time of day with or without food. Some prefer post-workout or with meals for better absorption, but consistency matters more than timing.",
      "scientificEvidenceRank": 84,
      "studyLinks": {
        "Creatine for cognitive function":
            "https://pubmed.ncbi.nlm.nih.gov/29704637/",
        "Working memory improvement":
            "https://pubmed.ncbi.nlm.nih.gov/14600563/",
        "Mental fatigue and sleep deprivation":
            "https://pubmed.ncbi.nlm.nih.gov/17828627/"
      },
      "dosageByWeight": {
        "40-60": "3-5g",
        "60-80": "5g",
        "80-100": "5-7g",
        "100-120": "7-10g"
      },
      "dosageFrequency":
          "Once daily, any time (consistency more important than timing)",
      "dosageWarnings": [
        "May cause mild water retention (1-2 lbs)",
        "Drink adequate water (creatine pulls water into cells)",
        "Loading phase (20g/day for 5 days) optional but not necessary",
        "Extremely safe; one of the most researched supplements"
      ],
      "tldr":
          "Supports brain energy (ATP) regeneration; improves working memory and mental fatigue resistance.",
      "translations": {
        "it": {
          "name": "Creatina Monoidrato",
          "description":
              "Fornisce energia rapida (ATP) per il cervello. Migliora la memoria di lavoro e riduce l'affaticamento mentale.",
          "mechanismOfAction":
              "La creatina fosfato funge da tampone ATP rapido nelle cellule con elevate richieste energetiche (cervello, muscoli). Regola i livelli di ADP per mantenere l'energia cellulare.",
          "detailedBenefits": [
            "Migliora la memoria di lavoro del 10-20% negli studi di ricerca",
            "Riduce l'affaticamento mentale durante compiti cognitivi prolungati",
            "Particolarmente efficace durante la privazione del sonno",
            "Supporta la neuroprotezione e le riserve di energia cerebrale"
          ],
          "timingRationale":
              "Tempistica flessibile (saturazione). Assumere quotidianamente la dose di mantenimento.",
          "dosageFrequency":
              "Una volta al giorno, in qualsiasi momento (la costanza è più importante della tempistica)",
          "dosageWarnings": [
            "Può causare una lieve ritenzione idrica (0,5-1 kg)",
            "Bere adeguata acqua (la creatina attira acqua nelle cellule)",
            "Fase di carico opzionale ma non necessaria",
            "Estremamente sicuro; uno degli integratori più studiati"
          ],
          "tldr":
              "Supporta l'energia cerebrale (ATP); migliora la memoria di lavoro e riduce l'affaticamento mentale."
        },
        "es": {
          "name": "Creatina Monohidrato",
          "description":
              "Proporciona energía rápida (ATP) para el cerebro. Mejora la memoria de trabajo y reduce la fatiga mental.",
          "mechanismOfAction":
              "La creatina fosfato sirve como un amortiguador rápido de ATP en células con altas demandas de energía (cerebro, músculos).",
          "detailedBenefits": [
            "Mejora la memoria de trabajo en un 10-20% en estudios de investigación",
            "Reduce la fatiga mental durante tareas cognitivas sostenidas",
            "Particularmente eficaz durante la privación de sueño",
            "Apoya la neuroprotección y las reservas de energía cerebral"
          ],
          "timingRationale":
              "Tiempo flexible (saturación). Tomar diariamente la dosis de mantenimiento.",
          "dosageFrequency":
              "Una vez al día, en cualquier momento (la consistencia es más importante que el tiempo)",
          "dosageWarnings": [
            "Puede causar una leve retención de líquidos (0,5-1 kg)",
            "Beba suficiente agua (la creatina atrae agua a las células)",
            "Fase de carga opcional pero no necesaria",
            "Extremamente seguro; uno de los suplementos más investigados"
          ],
          "tldr":
              "Apoya la energía cerebral (ATP); mejora la memoria de trabajo y reduce la fatiga mental."
        }
      }
    },
    {
      "id": "curcumin",
      "name": "Curcumin (Turmeric Extract)",
      "category": "Antioxidant",
      "dosage": "500-1000mg",
      "timeOfDay": "any",
      "benefits": ["Anti-Inflammatory", "Neuroprotection", "Mood Support"],
      "evidenceLevel": "moderate",
      "notes":
          "Must be formulated for bioavailability (with piperine/black pepper or liposomal). Powerful anti-inflammatory for brain function.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "Curcumin is a potent anti-inflammatory that crosses the blood-brain barrier. It inhibits NF-κB (inflammatory pathway), increases BDNF (neuroplasticity), and modulates monoamine neurotransmitters. Also has antioxidant properties that protect neurons from oxidative stress. Note: Poor bioavailability unless enhanced with piperine or liposomal delivery.",
      "detailedBenefits": [
        "Reduces neuroinflammation linked to focus challenges",
        "Increases BDNF for neuroplasticity and learning",
        "Mild mood-enhancing effects (MAO inhibition)",
        "Neuroprotective against oxidative stress and aging"
      ],
      "timingRationale":
          "Flexible timing - can be taken with meals for better absorption. Fat-soluble, so taking with dietary fat enhances uptake. Divided doses (morning + evening) may maintain more stable blood levels. Effects are cumulative over weeks, not immediate.",
      "scientificEvidenceRank": 74,
      "studyLinks": {
        "Curcumin and BDNF": "https://pubmed.ncbi.nlm.nih.gov/23832433/",
        "Anti-inflammatory effects in brain":
            "https://pubmed.ncbi.nlm.nih.gov/17569207/",
        "Bioavailability enhancement with piperine":
            "https://pubmed.ncbi.nlm.nih.gov/9619120/"
      },
      "dosageByWeight": {
        "40-60": "500mg",
        "60-80": "750mg",
        "80-100": "1000mg",
        "100-120": "1000-1500mg"
      },
      "dosageFrequency": "Once or twice daily with meals containing fat",
      "dosageWarnings": [
        "MUST be enhanced for bioavailability (piperine, liposomal, or phytosome)",
        "May interact with blood thinners (mild anticoagulant effect)",
        "Can cause GI upset in some people - take with food",
        "Avoid high doses if you have gallbladder issues"
      ],
      "tldr":
          "Potente composto antinfiammatorio e neuroprotettivo; deve essere formulato per l'assorbimento (con piperina o liposomiale).",
      "translations": {
        "it": {
          "name": "Curcumina (Estratto di Curcuma)",
          "description":
              "Deve essere formulato per la biodisponibilità (con piperina/pepe nero o liposomiale). Potente antinfiammatorio per la funzione cerebrale.",
          "mechanismOfAction":
              "La curcumina è un potente antinfiammatorio che attraversa la barriera emato-encefalica. Inibisce NF-κB (via infiammatoria), aumenta il BDNF (neuroplasticità) e modula i neurotrasmettitori monoaminici. Ha anche proprietà antiossidanti che proteggono i neuroni dallo stress ossidativo.",
          "timingRationale":
              "Tempistica flessibile - può essere assunta con i pasti per un migliore assorbimento. Liposolubile, quindi l'assunzione con grassi alimentari migliora l'assorbimento. Dosi divise (mattina + sera) possono mantenere livelli ematici più stabili. Gli effetti sono cumulativi in settimane, non immediati.",
          "detailedBenefits": [
            "Riduce la neuroinfiammazione legata alle sfide del focus",
            "Aumenta il BDNF per la neuroplasticità e l'apprendimento",
            "Effetti di miglioramento dell'umore (inibizione MAO)",
            "Neuroprotettivo contro lo stress ossidativo e l'invecchiamento"
          ],
          "dosageFrequency":
              "Una o due volte al giorno con i pasti contenenti grassi",
          "dosageWarnings": [
            "DEVE essere potenziato per la biodisponibilità (piperina, liposomiale)",
            "Può interagire con anticoagulanti (lieve effetto anticoagulante)",
            "Può causare disturbi gastrici - assumere con cibo",
            "Evitare dosi elevate in caso di problemi alla cistifellea"
          ],
          "tldr":
              "Potente composto antinfiammatorio e neuroprotettivo; deve essere formulato per l'assorbimento (con piperina o liposomiale)."
        },
        "es": {
          "name": "Curcumina (Extracto de Cúrcuma)",
          "description":
              "Debe formularse para biodisponibilidad (con piperina/pimienta negra o liposomal). Potente antiinflamatorio para la función cerebral.",
          "mechanismOfAction":
              "La curcumina es un potente antiinflamatorio que atraviesa la barrera hematoencefálica. Inhibe NF-κB, aumenta el BDNF y modula los neurotransmisores monoaminas.",
          "detailedBenefits": [
            "Reduce la neuroinflamación vinculada a los desafíos de enfoque",
            "Aumenta el BDNF para la neuroplasticidad y el aprendizaje",
            "Efectos leves de mejora del estado de ánimo (inhibición de la MAO)",
            "Neuroprotector contra el estrés oxidativo y el envejecimiento"
          ],
          "timingRationale":
              "Tiempo flexible: se puede tomar con las comidas para una mejor absorción. Las dosis divididas pueden mantener niveles más estables.",
          "dosageFrequency":
              "Una o dos veces al día con comidas que contengan grasas",
          "dosageWarnings": [
            "DEBE mejorarse para la biodisponibilidad (piperina, liposomal)",
            "Puede interactuar con anticoagulantes (leve efecto anticoagulante)",
            "Puede causar molestias gástricas: tomar con alimentos",
            "Evite dosis altas si tiene problemas de vesícula biliar"
          ],
          "tldr":
              "Potente compuesto antiinflamatorio y neuroprotector; debe formularse para su absorción (con piperina o liposomal)."
        }
      }
    },
    {
      "id": "green-tea-extract",
      "name": "Green Tea Extract (EGCG)",
      "category": "Antioxidant",
      "dosage": "250-500mg EGCG",
      "timeOfDay": "morning",
      "benefits": ["Focus Enhancement", "Neuroprotection", "Fat Oxidation"],
      "evidenceLevel": "moderate",
      "notes":
          "Standardized to 50% EGCG (epigallocatechin gallate). Contains L-theanine naturally. Avoid high doses on empty stomach.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "EGCG crosses the blood-brain barrier and modulates dopamine and norepinephrine levels. It inhibits COMT (catechol-O-methyltransferase), the enzyme that breaks down dopamine, extending dopamine availability. Also provides neuroprotection through antioxidant activity and supports mitochondrial function.",
      "detailedBenefits": [
        "Extends dopamine half-life by inhibiting COMT enzyme",
        "Improves sustained attention and reduces mind-wandering",
        "Neuroprotective against oxidative stress and neurodegeneration",
        "Synergizes with L-theanine for calm, focused alertness"
      ],
      "timingRationale":
          "Morning dosing provides focus benefits throughout the day. Contains caffeine (unless decaffeinated), so avoid evening use. Take with food to prevent nausea. Effects peak 1-2 hours after ingestion. Decaffeinated extracts can be taken later in the day if needed.",
      "scientificEvidenceRank": 77,
      "studyLinks": {
        "EGCG and dopamine metabolism":
            "https://pubmed.ncbi.nlm.nih.gov/18296328/",
        "Green tea for cognitive function":
            "https://pubmed.ncbi.nlm.nih.gov/28056735/",
        "COMT inhibition and attention":
            "https://pubmed.ncbi.nlm.nih.gov/21129394/"
      },
      "dosageByWeight": {
        "40-60": "250mg EGCG",
        "60-80": "300-400mg EGCG",
        "80-100": "400-500mg EGCG",
        "100-120": "500mg EGCG"
      },
      "dosageFrequency": "Once or twice daily with meals",
      "dosageWarnings": [
        "Contains caffeine unless decaffeinated (30-50mg per dose)",
        "Take with food to avoid nausea (tannins can upset stomach)",
        "High doses (>800mg EGCG) may affect liver enzymes - monitor",
        "May interact with blood thinners and blood pressure elements"
      ],
      "tldr":
          "Extends dopamine availability by inhibiting COMT; provides neuroprotection and synergizes with L-theanine for focus.",
      "translations": {
        "it": {
          "name": "Estratto di Tè Verde (EGCG)",
          "description":
              "Standardizzato al 50% EGCG (epigallocatechina gallato). Contiene naturalmente L-teanina. Evitare dosi elevate a stomaco vuoto.",
          "mechanismOfAction":
              "L'EGCG attraversa la barriera emato-encefalica e modula i livelli di dopamina e norepinefrina. Inibisce la COMT (catecol-O-metiltransferasi), l'enzima che scompone la dopamina, estendendo la disponibilità di dopamina. Fornisce anche neuroprotezione attraverso l'attività antiossidante.",
          "timingRationale":
              "Il dosaggio mattutino fornisce benefici di concentrazione per tutto il giorno. Contiene caffeina (a meno che non sia decaffeinato), quindi evitare l'uso serale. Assumere con il cibo per prevenire la nausea.",
          "detailedBenefits": [
            "Estende l'emivita della dopamina inibendo l'enzima COMT",
            "Migliora l'attenzione sostenuta e riduce la distrazione",
            "Neuroprotettivo contro lo stress ossidativo e la neurodegenerazione",
            "Sinergizza con la L-teanina per uno stato di allerta calmo e focalizzato"
          ],
          "dosageFrequency": "Una o due volte al giorno con i pasti",
          "dosageWarnings": [
            "Contiene caffeina se non decaffeinato (30-50mg per dose)",
            "Assumere con cibo per evitare nausea (i tannini possono disturbare lo stomaco)",
            "Dosi elevate (>800mg EGCG) possono influenzare gli enzimi epatici",
            "Può interagire con farmaci per la pressione o anticoagulanti"
          ],
          "tldr":
              "Estende la disponibilità di dopamina inibendo la COMT; fornisce neuroprotezione e sinergizza con la L-teanina per la concentrazione."
        },
        "es": {
          "name": "Extracto de Té Verde (EGCG)",
          "description":
              "Estandarizado al 50% de EGCG (galato de epigalocatequina). Contiene L-teanina de forma natural. Evitar dosis altas con el estómago vacío.",
          "mechanismOfAction":
              "El EGCG atraviesa la barrera hematoencefálica y modula los niveles de dopamina y norepinefrina. Inhibe la COMT, extendiendo la disponibilidad de dopamina.",
          "detailedBenefits": [
            "Extiende la vida media de la dopamina al inhibir la enzima COMT",
            "Mejora la atención sostenida y reduce la distracción",
            "Neuroprotector contra el estrés oxidativo y la neurodegeneración",
            "Crea sinergia con la L-teanina para un estado de alerta tranquilo"
          ],
          "timingRationale":
              "La dosis matutina proporciona beneficios de concentración durante todo el día. Contiene cafeína, por lo que debe evitarse el uso nocturno.",
          "dosageFrequency": "Una o dos veces al día con comidas",
          "dosageWarnings": [
            "Contiene cafeína a menos que sea descafeinado (30-50mg por dosis)",
            "Tomar con alimentos para evitar náuseas (los taninos pueden molestar)",
            "Dosis altas (>800mg EGCG) pueden afectar las enzimas hepáticas",
            "Puede interactuar con medicamentos para la presión arterial"
          ],
          "tldr":
              "Extiende la disponibilidad de dopamina al inhibir la COMT; proporciona neuroprotección y crea sinergia con la L-teanina para la concentración."
        }
      }
    },
    {
      "id": "nac",
      "name": "N-Acetyl Cysteine (NAC)",
      "category": "Amino Acid",
      "dosage": "600-1200mg",
      "timeOfDay": "morning",
      "benefits": [
        "Glutathione Production",
        "Oxidative Stress Reduction",
        "Impulse Control"
      ],
      "evidenceLevel": "moderate",
      "notes":
          "Precursor to glutathione, the brain's master antioxidant. Modulates glutamate for impulse control. Take on empty stomach for best absorption.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "NAC is a precursor to glutathione, the brain's primary antioxidant defense system. It also modulates glutamate neurotransmission by restoring cystine-glutamate exchange in the nucleus accumbens, which is implicated in impulse control and compulsive behaviors. Additionally supports mitochondrial function and reduces neuroinflammation.",
      "detailedBenefits": [
        "Increases brain glutathione levels by 30-50% for neuroprotection",
        "Improves impulse control and reduces compulsive behaviors",
        "Protects dopaminergic neurons from oxidative damage",
        "May reduce irritability and emotional dysregulation"
      ],
      "timingRationale":
          "Morning dosing on empty stomach maximizes absorption (food reduces bioavailability by ~30%). Effects build over 2-4 weeks of consistent use. Some people split dose (morning + afternoon) for sustained glutathione production. Avoid evening dosing as it can be mildly energizing.",
      "scientificEvidenceRank": 79,
      "studyLinks": {
        "NAC for impulse control and Focus":
            "https://pubmed.ncbi.nlm.nih.gov/31109635/",
        "Glutathione and neuroprotection":
            "https://pubmed.ncbi.nlm.nih.gov/29706149/",
        "NAC and glutamate modulation":
            "https://pubmed.ncbi.nlm.nih.gov/23369637/"
      },
      "dosageByWeight": {
        "40-60": "600mg",
        "60-80": "900mg",
        "80-100": "1200mg",
        "100-120": "1200-1800mg"
      },
      "dosageFrequency":
          "Once or twice daily on empty stomach (30 min before meals)",
      "dosageWarnings": [
        "May cause GI upset - start with lower dose and increase gradually",
        "Can have sulfur smell/taste (normal, not harmful)",
        "Avoid if you have asthma (may trigger bronchospasm in rare cases)",
        "Generally very safe; used in hospitals for acetaminophen overdose"
      ],
      "tldr":
          "Boosts glutathione for neuroprotection and modulates glutamate for improved impulse control and reduced compulsivity.",
      "translations": {
        "it": {
          "name": "N-Acetil Cisteina (NAC)",
          "description":
              "Precursore del glutatione, il principale antiossidante del cervello. Modula il glutammato per il controllo degli impulsi. Assumere a stomaco vuoto.",
          "mechanismOfAction":
              "NAC è un precursore del glutatione, il principale sistema di difesa antiossidante del cervello. Modula anche la neurotrasmissione del glutammato ripristinando lo scambio cistina-glutammato nel nucleus accumbens, implicato nel controllo degli impulsi e nei comportamenti compulsivi.",
          "timingRationale":
              "Il dosaggio mattutino a stomaco vuoto massimizza l'assorbimento. Gli effetti si accumulano in 2-4 settimane. Alcune persone dividono la dose (mattina + pomeriggio). Evitare il dosaggio serale in quanto può essere leggermente energizzante.",
          "detailedBenefits": [
            "Aumenta i livelli cerebrali di glutatione del 30-50% per la neuroprotezione",
            "Migliora il controllo degli impulsi e riduce i comportamenti compulsivi",
            "Protegge i neuroni dopaminergici dal danno ossidativo",
            "Può ridurre l'irritabilità e la disregolazione emotiva"
          ],
          "dosageFrequency": "Una o due volte al giorno a stomaco vuoto",
          "dosageWarnings": [
            "Assumere a stomaco vuoto (30 min prima dei pasti)",
            "Può causare lievi disturbi gastrici",
            "L'odore di zolfo è normale per questo integratore",
            "Evitare se si soffre di asma (raro rischio di broncospasmo)"
          ],
          "tldr":
              "Aumenta il glutatione per la neuroprotezione e modula il glutammato per un migliore controllo degli impulsi."
        },
        "es": {
          "name": "N-Acetil Cisteína (NAC)",
          "description":
              "Precursor del glutatión, el principal antioxidante del cerebro. Modula el glutamato para el control de los impulsos. Tomar con el estómago vacío.",
          "mechanismOfAction":
              "NAC es un precursor del glutatión, el principal sistema de defensa antioxidante del cerebro. También modula la neurotransmisión de glutamato al restaurar el intercambio de cistina-glutamato en el núcleo accumbens, implicado en el control de los impulsos y los comportamientos compulsivos.",
          "timingRationale":
              "La dosis matutina con el estómago vacío maximiza la absorción. Los efectos se acumulan en 2-4 semanas. Algunas personas dividen la dosis (mañana + tarde). Evite la dosis nocturna ya que puede ser levemente energizante.",
          "detailedBenefits": [
            "Aumenta los niveles de glutatión cerebral en un 30-50%",
            "Mejora el control de impulsos y reduce comportamientos compulsivos",
            "Protege las neuronas dopaminérgicas del daño oxidativo",
            "Puede reducir la irritabilidad y la desregulación emocional"
          ],
          "dosageFrequency": "Una o dos veces al día con el estómago vacío",
          "dosageWarnings": [
            "Tomar con el estómago vacío (30 min antes de comer)",
            "Puede causar molestias gástricas leves",
            "El olor a azufre es normal en este suplemento",
            "Evitar si padece asma (riesgo raro de broncoespasmo)"
          ],
          "tldr":
              "Aumenta el glutatión para la neuroprotección y modula el glutamato para mejorar el control de los impulsos."
        }
      },
      "sideEffects": [
        "Common: sulfur smell/taste (normal, not harmful)",
        "Occasional: mild nausea or GI upset (take with food)",
        "Rare: skin rash or allergic reaction",
        "Generally safe and well-tolerated"
      ]
    },
    {
      "id": "huperzine-a",
      "name": "Huperzine A",
      "category": "Nootropic",
      "dosage": "50-200mcg",
      "timeOfDay": "morning",
      "benefits": [
        "Acetylcholine Enhancement",
        "Memory Consolidation",
        "Neuroprotection"
      ],
      "evidenceLevel": "moderate",
      "notes":
          "Potent acetylcholinesterase inhibitor. Very long half-life (24+ hours). Start low, cycle use (5 days on, 2 days off recommended).",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "Huperzine A is a reversible acetylcholinesterase inhibitor that prevents the breakdown of acetylcholine, increasing its availability in synapses. It has a very long half-life (24-36 hours) and also provides neuroprotection through NMDA receptor modulation and antioxidant effects. Supports memory formation and learning.",
      "detailedBenefits": [
        "Increases acetylcholine levels by 30-40% for enhanced attention",
        "Improves memory consolidation and recall",
        "Neuroprotective against glutamate excitotoxicity",
        "May enhance neuroplasticity and learning capacity"
      ],
      "timingRationale":
          "Morning dosing recommended due to 24+ hour half-life. Effects are cumulative and long-lasting. Cycling (5 days on, 2 days off) prevents tolerance and allows acetylcholinesterase levels to normalize. Take with or without food. Avoid daily use without breaks.",
      "scientificEvidenceRank": 71,
      "studyLinks": {
        "Huperzine A for cognitive enhancement":
            "https://pubmed.ncbi.nlm.nih.gov/23374481/",
        "Acetylcholinesterase inhibition and memory":
            "https://pubmed.ncbi.nlm.nih.gov/16007238/",
        "Neuroprotective effects": "https://pubmed.ncbi.nlm.nih.gov/18611150/"
      },
      "dosageByWeight": {
        "40-60": "50mcg",
        "60-80": "100mcg",
        "80-100": "150mcg",
        "100-120": "200mcg"
      },
      "dosageFrequency": "Once daily in morning, cycle 5 days on / 2 days off",
      "dosageWarnings": [
        "Very long half-life - do NOT take daily without breaks (cycle use)",
        "May cause vivid dreams or insomnia if taken too late in day",
        "Can cause cholinergic side effects (nausea, headache) at high doses",
        "Start with lowest dose and assess tolerance before increasing"
      ],
      "tldr":
          "Potent acetylcholinesterase inhibitor with 24+ hour half-life; enhances memory and attention but requires cycling to prevent tolerance.",
      "translations": {
        "it": {
          "name": "Uperzina A",
          "description":
              "Potente inibitore dell'acetilcolinesterasi. Emivita molto lunga (24+ ore). Iniziare basso, ciclizzare l'uso (consigliato 5 giorni sì, 2 no).",
          "mechanismOfAction":
              "L'Uperzina A è un inibitore reversibile dell'acetilcolinesterasi che previene la scomposizione dell'acetilcolina, aumentandone la disponibilità nelle sinapsi. Ha un'emivita molto lunga e fornisce anche neuroprotezione.",
          "timingRationale":
              "Dosaggio mattutino raccomandato a causa dell'emivita di 24+ ore. Ciclizzare (5 giorni sì, 2 no) previene la tolleranza. Assumere con o senza cibo.",
          "detailedBenefits": [
            "Aumenta la memoria a breve termine e la velocità di apprendimento",
            "Migliora la concentrazione e l'attenzione sostenuta",
            "Effetti neuroprotettivi contro la tossicità del glutammato",
            "Migliora la neuroplasticità influenzando i recettori NMDA"
          ],
          "dosageFrequency": "Una volta al giorno al mattino (Richiede Cicli)",
          "dosageWarnings": [
            "CRITICO: DEVE essere ciclizzato (es. 5 on / 2 off)",
            "Non assumere se si soffre di epilessia o asma grave",
            "Può causare nausea, crampi o aumento della salivazione",
            "Evitare se si assumono farmaci colinergici"
          ],
          "tldr":
              "Potente inibitore dell'acetilcolinesterasi con emivita di 24+ ore; migliora memoria e attenzione ma richiede cicli."
        },
        "es": {
          "name": "Huperzina A",
          "description":
              "Potente inhibidor de la acetilcolinesterasa. Vida media muy larga (24+ horas). Empezar bajo, completar ciclos (se recomienda 5 días sí, 2 no).",
          "mechanismOfAction":
              "La Huperzina A es un inhibidor reversible de la acetilcolinesterasa que previene la descomposición de la acetilcolina, aumentando su disponibilidad en las sinapsis. Tiene una vida media muy larga y también proporciona neuroprotección.",
          "timingRationale":
              "Se recomienda la dosis matutina debido a una vida media de 24+ horas. Completar ciclos (5 días sí, 2 no) previene la tolerancia. Tomar con o sin alimentos.",
          "detailedBenefits": [
            "Mejora la memoria a corto plazo y la velocidad de aprendizaje",
            "Aumenta el enfoque y la atención sostenida",
            "Efectos neuroprotectores contra la toxicidad del glutammato",
            "Mejora la neuroplasticidad al influir en los receptores NMDA"
          ],
          "dosageFrequency": "Una vez al día por la mañana (Requiere Ciclos)",
          "dosageWarnings": [
            "CRÍTICO: DEBE hacerse ciclos (ej. 5 días ON, 2 OFF)",
            "No tomar si padece epilepsia o asma grave",
            "Puede causar náuseas, calambres o aumento de la salivación",
            "Evitar si toma medicamentos colinérgicos"
          ],
          "tldr":
              "Potente inhibidor de la acetilcolinesterasa con una vida media de más de 24 horas; mejora la memoria y la atención, pero requiere ciclos."
        }
      },
    },
    {
      "id": "vinpocetine",
      "name": "Vinpocetine",
      "category": "Nootropic",
      "dosage": "10-20mg",
      "timeOfDay": "morning",
      "benefits": ["Cerebral Blood Flow", "Mental Clarity", "Neuroprotection"],
      "evidenceLevel": "low",
      "notes":
          "Derived from periwinkle plant. Enhances cerebral blood flow and glucose utilization. Take with food for better absorption.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "Vinpocetine supports optimal circulation and oxygen delivery to the brain. It promotes energy utilization in neural pathways and serves as a powerful antioxidant for cognitive longevity.",
      "detailedBenefits": [
        "Supports healthy delivery of oxygen/nutrients to the brain",
        "Promotes mental clarity and faster processing speed",
        "Enhances memory consolidation",
        "Supports neuroprotection against oxidative stress"
      ],
      "timingRationale":
          "Morning or early afternoon dosing with food maximizes absorption. Effects are noticeable within 1-2 hours. Avoid evening dosing as increased alertness can interfere with sleep.",
      "scientificEvidenceRank": 63,
      "studyLinks": {
        "Vinpocetine and cerebral blood flow":
            "https://pubmed.ncbi.nlm.nih.gov/12404671/",
        "Cognitive enhancement effects":
            "https://pubmed.ncbi.nlm.nih.gov/12895685/",
        "Neuroprotective mechanisms":
            "https://pubmed.ncbi.nlm.nih.gov/16389715/"
      },
      "dosageByWeight": {
        "40-60": "10mg",
        "60-80": "15mg",
        "80-100": "20mg",
        "100-120": "20-30mg"
      },
      "dosageFrequency": "Once or twice daily with meals",
      "dosageWarnings": [
        "Take with food (fat-soluble, poor absorption on empty stomach)",
        "May lower blood pressure - monitor if on BP elements",
        "Avoid during pregnancy (may affect blood flow to placenta)",
        "Can interact with blood thinners - consult advisor"
      ],
      "tldr":
          "Enhances cerebral blood flow and glucose utilization for improved mental clarity and processing speed.",
      "translations": {
        "it": {
          "name": "Vinpocetina",
          "description":
              "Derivato dalla pianta pervinca. Migliora il flusso sanguigno cerebrale e l'utilizzo del glucosio. Assumere con il cibo.",
          "mechanismOfAction":
              "La Vinpocetina supporta la circolazione ottimale e l'apporto di ossigeno al cervello. Promuove l'utilizzo di energia nei percorsi neurali e funge da potente antiossidante.",
          "timingRationale":
              "Dosaggio mattutino o primo pomeriggio con il cibo per massimizzare l'assorbimento. Effetti notevoli entro 1-2 ore. Evitare la sera.",
          "detailedBenefits": [
            "Migliora la circolazione sanguigna e l'ossigenazione del cervello",
            "Potenzia la vigilanza mentale e il recupero della memoria",
            "Supporta il metabolismo del glucosio cerebrale per l'energia",
            "Proprietà antinfiammatorie e antiossidanti nei neuroni"
          ],
          "dosageFrequency": "Una o due volte al giorno con il cibo",
          "dosageWarnings": [
            "Assumere sempre con il cibo per un assorbimento ottimale",
            "Può avere un lieve effetto anticoagulante - monitorare",
            "Non consigliato in caso di pre-gravidanza o gravidanza",
            "Evitare se si soffre di disturbi emorragici"
          ],
          "tldr":
              "Migliora il flusso sanguigno cerebrale e l'utilizzo del glucosio per una migliore chiarezza mentale."
        },
        "es": {
          "name": "Vinpocetina",
          "description":
              "Derivado de la planta vinca. Mejora el flujo sanguíneo cerebral y la utilización de glucosa. Tomar con alimentos.",
          "mechanismOfAction":
              "La vinpocetina favorece la circulación óptima y el suministro de oxígeno al cerebro. Promueve la utilización de energía en las vías neuronales y actúa como un potente antioxidante.",
          "timingRationale":
              "Dosis matutina o temprano en la tarde con alimentos para maximizar la absorción. Efectos notables dentro de 1-2 horas. Evitar por la noche.",
          "detailedBenefits": [
            "Mejora la circulación sanguínea y la oxigenación del cerebro",
            "Potencia el estado de alerta mental y la recuperación de memoria",
            "Apoya el metabolismo de la glucosa cerebral para la energía",
            "Propiedades antiinflamatorias y antioxidantes"
          ],
          "dosageFrequency": "Una o dos veces al día con alimentos",
          "dosageWarnings": [
            "Tomar siempre con alimentos para una absorción óptima",
            "Puede tener un ligero efecto anticoagulante",
            "No se recomienda en caso de embarazo o planificación",
            "Evitar si padece trastornos hemorrágicos"
          ],
          "tldr":
              "Mejora el flujo sanguíneo cerebral y la utilización de glucosa para una mejor claridad mental."
        }
      },
    },
    {
      "id": "mucuna-pruriens",
      "name": "Mucuna Pruriens (L-DOPA)",
      "category": "Amino Acid",
      "dosage": "300-500mg",
      "timeOfDay": "morning",
      "benefits": ["Dopamine Precursor", "Mood Enhancement", "Motivation"],
      "evidenceLevel": "moderate",
      "notes":
          "⚠️ Natural source of L-DOPA (dopamine precursor). Use cautiously - can deplete dopamine with chronic use. Cycle recommended.",
      "status": "beneficial",
      "focusLevel": 2,
      "mechanismOfAction":
          "Mucuna pruriens contains L-DOPA (levodopa), the direct precursor to dopamine. It crosses the blood-brain barrier and is converted to dopamine by aromatic L-amino acid decarboxylase. While this provides immediate dopamine boost, chronic use without cycling can downregulate dopamine receptors and deplete endogenous production. Also contains other neuroprotective compounds.",
      "detailedBenefits": [
        "Rapidly increases dopamine levels (within 30-60 minutes)",
        "Improves motivation, mood, and drive",
        "May enhance focus and mental energy",
        "Contains neuroprotective antioxidants beyond L-DOPA"
      ],
      "timingRationale":
          "Morning dosing on empty stomach maximizes L-DOPA absorption (protein competes for absorption). Effects peak within 1-2 hours. CRITICAL: Cycle use (3-5 days on, 2-3 days off) to prevent receptor downregulation and dopamine depletion. Not for daily long-term use.",
      "scientificEvidenceRank": 69,
      "studyLinks": {
        "Mucuna pruriens and dopamine":
            "https://pubmed.ncbi.nlm.nih.gov/15478206/",
        "L-DOPA for mood and motivation":
            "https://pubmed.ncbi.nlm.nih.gov/24931003/",
        "Neuroprotective effects": "https://pubmed.ncbi.nlm.nih.gov/23675006/"
      },
      "dosageByWeight": {
        "40-60": "300mg (15% L-DOPA extract)",
        "60-80": "400mg",
        "80-100": "500mg",
        "100-120": "500-600mg"
      },
      "dosageFrequency":
          "Once daily on empty stomach, CYCLE 3-5 days on / 2-3 days off",
      "dosageWarnings": [
        "⚠️ MUST CYCLE - chronic daily use depletes dopamine and downregulates receptors",
        "Take on empty stomach (protein blocks L-DOPA absorption)",
        "May cause nausea, especially at higher doses",
        "Avoid with MAO inhibitors or Parkinson's elements",
        "Not recommended for long-term daily use without cycling"
      ],
      "tldr":
          "Natural L-DOPA source for rapid dopamine boost; MUST be cycled to prevent receptor downregulation and depletion.",
      "translations": {
        "it": {
          "name": "Mucuna Pruriens (L-DOPA)",
          "description":
              "Fonte naturale di L-DOPA. Usare con cautela - può esaurire la dopamina con l'uso cronico. Ciclizzazione raccomandata.",
          "mechanismOfAction":
              "Contiene L-DOPA, il precursore diretto della dopamina. Attraversa la barriera emato-encefalica e viene convertito in dopamina. L'uso cronico senza cicli può down-regolare i recettori.",
          "timingRationale":
              "Dosaggio mattutino a stomaco vuoto. CRITICO: Ciclizzare l'uso (3-5 giorni sì, 2-3 no) per prevenire la down-regolazione dei recettori.",
          "detailedBenefits": [
            "Aumenta rapidamente i livelli di dopamina (entro 30-60 min)",
            "Migliora la motivazione, l'umore e la grinta",
            "Può potenziare il focus e l'energia mentale",
            "Contiene antiossidanti neuroprotettivi oltre alla L-DOPA"
          ],
          "dosageFrequency": "Una volta al giorno a stomaco vuoto (CICLIZZARE)",
          "dosageWarnings": [
            "DEVE essere ciclizzato (3-5 gg on / 2-3 gg off)",
            "Assumere a stomaco vuoto (le proteine bloccano l'assorbimento)",
            "Può causare nausea a dosaggi più elevati",
            "Evitare in combinazione con inibitori delle MAO"
          ],
          "tldr":
              "Fonte naturale di L-DOPA per un rapido aumento della dopamina; DEVE essere ciclizzato."
        },
        "es": {
          "name": "Mucuna Pruriens (L-DOPA)",
          "description":
              "Fuente natural de L-DOPA. Usar con precaución: puede agotar la dopamina con el uso crónico. Se recomienda completar ciclos.",
          "mechanismOfAction":
              "Contiene L-DOPA, el precursor directo de la dopamina. Cruza la barrera hematoencefálica y se convierte en dopamina. El uso crónico sin ciclos puede regular a la baja los receptores.",
          "timingRationale":
              "Dosis matutina con el estómago vacío. CRÍTICO: Completar ciclos de uso (3-5 días sí, 2-3 no) para prevenir la regulación a la baja de los receptores.",
          "detailedBenefits": [
            "Aumenta rápidamente los niveles de dopamina (30-60 min)",
            "Mejora la motivación, el estado de ánimo y el impulso",
            "Puede mejorar el enfoque y la energía mental",
            "Contiene antioxidantes neuroprotectores"
          ],
          "dosageFrequency":
              "Una vez al día con el estómago vacío (CICLIZZARE)",
          "dosageWarnings": [
            "DEBE completarse en ciclos (3-5 días sí, 2-3 no)",
            "Tomar con el estómago vacío (la proteína bloquea L-DOPA)",
            "Puede causar náuseas a dosis altas",
            "Evitar con inhibidores de la MAO"
          ],
          "tldr":
              "Fuente natural de L-DOPA para un rápido aumento de la dopamina; DEBE completarse en ciclos."
        }
      },
    },
    {
      "id": "alpha-gpc",
      "name": "Alpha-GPC",
      "category": "Nootropic",
      "dosage": "300-600mg",
      "timeOfDay": "morning",
      "benefits": [
        "Working Memory",
        "Acetylcholine Production",
        "Mental Clarity"
      ],
      "evidenceLevel": "moderate",
      "notes":
          "Premium choline source, highly bioavailable. Supports working memory and attention. Crosses blood-brain barrier efficiently.",
      "tldr":
          "Premium, highly bioavailable choline source for acetylcholine synthesis; improves working memory and attention.",
      "translations": {
        "it": {
          "name": "Alfa-GPC",
          "description":
              "Un precursore della colina ad alta biodisponibilità che supporta la salute cognitiva e la potenza fisica.",
          "mechanismOfAction":
              "Alfa-GPC è un composto di colina ad alta biodisponibilità che attraversa efficacemente la barriera emato-encefalica. Funge da precursore dell'acetilcolina, il neurotrasmettitore critico per l'attenzione e la memoria.",
          "detailedBenefits": [
            "Aumenta i livelli di acetilcolina del 40-50% entro 1-3 ore",
            "Migliora la memoria di lavoro e il richiamo mnemonico",
            "Potenzia la concentrazione e la chiarezza mentale",
            "Supporta la neuroplasticità e la capacità di apprendimento"
          ],
          "timingRationale":
              "Il dosaggio mattutino o prima di un compito cognitivo è ottimale. Gli effetti raggiungono il picco entro 1-3 ore. Evitare la sera per non disturbare il sonno.",
          "dosageFrequency":
              "Una o due volte al giorno (mattina e/o pomeriggio)",
          "dosageWarnings": [
            "Generalmente molto sicuro con effetti collaterali minimi",
            "Può causare mal di testa in alcune persone (eccesso di acetilcolina)",
            "Ridurre la dose se si avverte irritabilità",
            "Assumere con il cibo se causa lievi disturbi gastrici"
          ],
          "tldr":
              "Una colina superiore che supporta la memoria di lavoro e la produzione di acetilcolina."
        },
        "es": {
          "name": "Alfa-GPC",
          "description":
              "Un precursor de colina altamente biodisponible que apoya la salud cognitiva y la potencia física.",
          "mechanismOfAction":
              "Alfa-GPC es un compuesto de colina altamente biodisponible que cruza la barrera hematoencefálica con eficacia. Sirve como precursor de la acetilcolina.",
          "detailedBenefits": [
            "Aumenta los niveles de acetilcolina en un 40-50% en 1-3 horas",
            "Mejora la memoria de trabajo y la recuperación de información",
            "Potencia el enfoque y la claridad mental durante tareas cognitivas",
            "Apoya la neuroplasticidad y la capacidad de aprendizaje",
          ],
          "timingRationale":
              "La dosis matutina o previa a una tarea cognitiva es óptima. Los efectos alcanzan su punto máximo en 1-3 horas.",
          "dosageFrequency": "Una o dos veces al día (mañana y/o tarde)",
          "dosageWarnings": [
            "Generalmente muy seguro con mínimos efectos secundarios",
            "Puede causar dolor de cabeza (signo de exceso de acetilcolina)",
            "Reduzca la dosis si siente irritabilidad",
            "Tomar con comida si causa molestias gástricas leves"
          ],
          "tldr":
              "Una colina superior que apoya la memoria de trabajo y la producción de acetilcolina."
        }
      },
      "status": "beneficial",
      "focusLevel": 5,
      "mechanismOfAction":
          "Alpha-GPC (L-alpha glycerylphosphorylcholine) is a highly bioavailable choline compound that crosses the blood-brain barrier efficiently. It serves as a precursor to acetylcholine, the neurotransmitter critical for attention, memory, and learning. Also increases growth hormone release and supports cell membrane phospholipid synthesis.",
      "detailedBenefits": [
        "Increases acetylcholine levels by 40-50% within 1-3 hours",
        "Improves working memory and recall in standard trials",
        "Enhances focus and mental clarity during cognitive tasks",
        "Supports neuroplasticity and learning capacity"
      ],
      "timingRationale":
          "Morning or pre-cognitive task dosing is optimal. Effects peak within 1-3 hours. Can be taken with or without food. Some people split dose (morning + afternoon) for sustained acetylcholine support. Avoid evening dosing as it may interfere with sleep in sensitive individuals.",
      "scientificEvidenceRank": 78,
      "studyLinks": {
        "Alpha-GPC for cognitive enhancement":
            "https://pubmed.ncbi.nlm.nih.gov/12637119/",
        "Working memory and attention":
            "https://pubmed.ncbi.nlm.nih.gov/21156470/",
        "Acetylcholine synthesis mechanism":
            "https://pubmed.ncbi.nlm.nih.gov/14675803/"
      },
      "dosageByWeight": {
        "40-60": "300mg",
        "60-80": "400-500mg",
        "80-100": "500-600mg",
        "100-120": "600mg"
      },
      "dosageFrequency":
          "Once or twice daily (morning, or morning + afternoon)",
      "dosageWarnings": [
        "Generally very safe with minimal side effects",
        "May cause headaches in some people (sign of excess acetylcholine)",
        "Can cause GI upset at high doses - take with food if needed",
        "More expensive than other choline sources but better bioavailability"
      ]
    },
    {
      "id": "panax-ginseng",
      "name": "Panax Ginseng (Korean Ginseng)",
      "category": "Adaptogen",
      "dosage": "200-400mg",
      "timeOfDay": "morning",
      "benefits": [
        "Sustained Attention",
        "Mental Fatigue Reduction",
        "Dopaminergic Support"
      ],
      "evidenceLevel": "moderate",
      "notes":
          "Use standardized extract (4-7% ginsenosides). Contains ginsenosides that modulate dopamine and acetylcholine. Adaptogen for cognitive stamina.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "Panax ginseng contains ginsenosides that modulate neurotransmission and the HPA axis. It has been shown to increase dopamine and acetylcholine levels in the hippocampus and prefrontal cortex. Ginsenosides (especially Rg1 and Rb1) act as partial agonists for dopamine receptors and promote neuronal supervivencia and dendritic growth.",
      "detailedBenefits": [
        "Improves sustained attention during long cognitive tasks",
        "Reduces mental fatigue and subjective 'brain fog'",
        "Modulates dopamine and acetylcholine for better executive function",
        "Supports HPA axis resilience against chronic stress"
      ],
      "timingRationale":
          "Morning dosing is recommended to support daytime focus and energy. Effects are cumulative but acute improvements in attention are often noticed within 30-90 minutes. Avoid evening use as it can be mildly stimulating and may interfere with sleep.",
      "scientificEvidenceRank": 74,
      "studyLinks": {
        "Ginseng and cognitive performance in Focus":
            "https://pubmed.ncbi.nlm.nih.gov/22082268/",
        "Neurotransmitter modulation mechanisms":
            "https://pubmed.ncbi.nlm.nih.gov/23439798/",
        "Systematic review of cognitive effects":
            "https://pubmed.ncbi.nlm.nih.gov/20123133/"
      },
      "dosageByWeight": {
        "40-60": "200mg",
        "60-80": "300mg",
        "80-100": "400mg",
        "100-120": "400-500mg"
      },
      "dosageFrequency": "Once daily in the morning",
      "dosageWarnings": [
        "May be mildly stimulating - avoid evening dosing",
        "Can lower blood sugar - monitor if on diabetic elements",
        "May interact with blood thinners (warfarin/aspirin)",
        "Generally well-tolerated; occasional insomnia at high doses"
      ],
      "tldr":
          "Adaptogen that improves sustained attention and reduces mental fatigue through dopaminergic and cholinergic support.",
      "translations": {
        "it": {
          "name": "Panax Ginseng (Ginseng Coreano)",
          "description":
              "Usare estratto standardizzato (4-7% ginsenosidi). Adattogeno per la resistenza cognitiva.",
          "mechanismOfAction":
              "I ginsenosidi modulano i sistemi dei neurotrasmettitori (incluso il GABA) e supportano la funzione mitocondriale. Migliora il flusso sanguigno cerebrale e ha effetti antinfiammatori.",
          "detailedBenefits": [
            "Migliora la memoria di lavoro e le prestazioni mentali",
            "Riduce l'affaticamento mentale durante compiti prolungati",
            "Aumenta la vigilanza e i tempi di reazione",
            "Supporta la resilienza allo stress e la stabilità dell'umore"
          ],
          "timingRationale":
              "Dosaggio mattutino raccomandato. Gli effetti sono cumulativi ma miglioramenti acuti dell'attenzione sono spesso notati entro 30-90 minuti. Evitare l'uso serale.",
          "dosageFrequency": "Una volta al giorno (preferibilmente al mattino)",
          "dosageWarnings": [
            "Può essere stimolante - monitorare se si avverte ansia",
            "Può abbassare i livelli di zucchero nel sangue",
            "Interagisce con anticoagulanti e farmaci per il diabete",
            "Consigliata una pausa di una settimana dopo 2-3 settimane di uso"
          ],
          "tldr":
              "Adattogeno stimolante che migliora la vigilanza, la memoria di lavoro e combatte la stanchezza mentale."
        },
        "es": {
          "name": "Panax Ginseng (Ginseng Coreano)",
          "description":
              "Hierba adaptógena tradicional que mejora el estado de alerta, reduce la fatiga y apoya la memoria de trabajo.",
          "mechanismOfAction":
              "Los ginsenósidos modulan los sistemas de neurotransmisores y apoyan la función mitocondrial. Mejora el flujo sanguíneo cerebral.",
          "detailedBenefits": [
            "Mejora la memoria de trabajo y el rendimiento mental",
            "Reduce la fatiga mental durante tareas prolongadas",
            "Aumenta el estado de alerta y los tiempos de reacción",
            "Apoya la resiliencia al estrés y la estabilidad del ánimo"
          ],
          "timingRationale":
              "Tomar por la mañana. Puede ser levemente estimulante, por lo que debe evitarse el uso nocturno.",
          "dosageFrequency": "Una vez al día (preferiblemente por la mañana)",
          "dosageWarnings": [
            "Puede ser estimulante: controle si siente ansiedad",
            "Puede reducir los niveles de azúcar en sangre",
            "Interactúa con anticoagulantes y medicamentos para la diabetes",
            "Se recomienda un descanso de una semana tras 2-3 semanas de uso"
          ],
          "tldr":
              "Adaptógeno estimulante que mejora el alerta, la memoria de trabajo y combate la fatiga mental."
        }
      },
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
          "Similar to Pycnogenol. Standardized maritime pine bark extract containing proanthocyanidins. Requires 8-12 weeks for full cognitive benefits.",
      "status": "beneficial",
      "focusLevel": 4,
      "mechanismOfAction":
          "Potent antioxidant containing proanthocyanidins that cross the blood-brain barrier. Enhances nitric oxide production for improved cerebral blood flow. Modulates dopamine and norepinephrine metabolism while reducing oxidative stress.",
      "detailedBenefits": [
        "Reduces restless energy and improves attention by 20-30% in standard trials",
        "Enhances antioxidant capacity and reduces neuroinflammation",
        "Improves concentration and visual-motor coordination",
        "Supports cerebral blood flow and oxygen delivery"
      ],
      "timingRationale":
          "Morning dosing supports daytime cognitive function. Effects are cumulative over 8-12 weeks. Take with food to enhance absorption and reduce GI upset.",
      "scientificEvidenceRank": 73,
      "studyLinks": {
        "Pine bark extract for Focus in children":
            "https://pubmed.ncbi.nlm.nih.gov/16499493/",
        "Attention and restless energy improvement":
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
        "Generally well-tolerated at recommended doses"
      ],
      "tldr":
          "Cost-effective alternative to Pycnogenol that improves cerebral blood flow and reduces neuroinflammation.",
      "translations": {
        "it": {
          "name": "Corteccia di Pino Marittimo",
          "description":
              "Estratto standardizzato (spesso Marchio P.) ricco di proantocianidine. Migliora la microcircolazione e il focus.",
          "mechanismOfAction":
              "Migliora la funzione endoteliale e la produzione di ossido nitrico, aumentando il flusso sanguigno cerebrale. Ha potenti effetti antinfiammatori e antiossidanti.",
          "detailedBenefits": [
            "Migliora l'attenzione e la concentrazione nei compiti di focus",
            "Promuove una migliore circolazione sanguigna cerebrale",
            "Riduce lo stress ossidativo legato alla funzione cognitiva",
            "Supporta la memoria di lavoro e la velocità di elaborazione"
          ],
          "timingRationale":
              "Dosaggio giornaliero con il cibo per un assorbimento costante. Gli effetti spesso richiedono 2-4 settimane per manifestarsi pienamente.",
          "dosageFrequency": "Una volta al giorno con il cibo",
          "dosageWarnings": [
            "Può interagire con farmaci anticoagulanti",
            "Monitorare se si hanno disturbi emorragici",
            "Assumere con il cibo se causa lievi disturbi gastrici",
            "Effetti cumulativi - attendere 4 settimane per i benefici completi"
          ],
          "tldr":
              "Migliora la circolazione cerebrale e l'attenzione attraverso il supporto dell'ossido nitrico e l'azione antiossidante."
        },
        "es": {
          "name": "Corteza de Pino Marítimo",
          "description":
              "Extracto estandarizado rico en proantocianidinas. Mejora la microcirculación y el enfoque cognitivo.",
          "mechanismOfAction":
              "Mejora la función endotelial y la producción de óxido nítrico, aumentando el flujo sanguíneo cerebral y la oxigenación.",
          "detailedBenefits": [
            "Mejora la atención y la concentración en tareas de enfoque",
            "Promuove una mejor circulación sanguínea cerebral",
            "Reduce el estrés oxidativo vinculado a la función cognitiva",
            "Apoya la memoria de trabajo y la velocidad de procesamiento"
          ],
          "timingRationale":
              "Dosis diaria con alimentos para una absorción constante. Los efectos suelen requerir 2-4 semanas para manifestarse plenamente.",
          "dosageFrequency": "Una vez al día con alimentos",
          "dosageWarnings": [
            "Puede interactuar con medicamentos anticoagulantes",
            "Monitorear si se tienen trastornos hemorrágicos",
            "Tomar con comida si causa molestias gástricas leves",
            "Efectos acumulativos: esperar 4 semanas para beneficios finales"
          ],
          "tldr":
              "Mejora la circulación cerebral y la atención mediante el soporte del óxido nítrico y la acción antioxidante."
        }
      },
    },
    {
      "id": "phosphatidylcholine",
      "name": "Phosphatidylcholine (PC)",
      "category": "Lipid",
      "dosage": "1200mg",
      "timeOfDay": "any",
      "benefits": [
        "Cell Membrane Support",
        "Acetylcholine Production",
        "Neuronal Structure"
      ],
      "evidenceLevel": "moderate",
      "notes":
          "A major phospholipid and source of choline. Essential for building and maintaining neuronal membranes.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "Phosphatidylcholine is a vital phospholipid component of all cell membranes, particularly enriched in the brain. It provides choline for the synthesis of acetylcholine, the primary neurotransmitter for learning and memory. It also supports membrane fluidity and neurotransmitter receptor function.",
      "detailedBenefits": [
        "Provides precursor for acetylcholine (vital for memory/focus)",
        "Supports structural integrity of neuronal membranes",
        "Enhances cerebral metabolic activity",
        "Supports liver health and lipid transport"
      ],
      "timingRationale":
          "Can be taken any time of day. Take with a meal containing some fat for optimal absorption, as it is a lipid-soluble nutrient.",
      "scientificEvidenceRank": 65,
      "studyLinks": {
        "Choline and cognitive function":
            "https://pubmed.ncbi.nlm.nih.gov/22071706/",
        "Phospholipids in brain health":
            "https://pubmed.ncbi.nlm.nih.gov/30606018/"
      },
      "dosageByWeight": {
        "40-60": "600-1200mg",
        "60-80": "1200-2400mg",
        "80-100": "2400-3600mg",
        "100-120": "3600-4800mg"
      },
      "dosageFrequency": "One to two times daily with food",
      "dosageWarnings": [
        "High doses (>5g) may cause fishy body odor, sweating, or nausea",
        "Consult advisor if taking cholinergic elements",
        "Soy-derived (choose sunflower PC if you have soy allergies)"
      ],
      "tldr":
          "Essential phospholipid for cell membrane health and acetylcholine precursor.",
      "translations": {
        "it": {
          "name": "Fosfatidilcolina (PC)",
          "description":
              "Componente principale delle membrane cellulari. Precursore dell'acetilcolina.",
          "mechanismOfAction":
              "Supporta l'integrità strutturale dei neuroni e serve come riserva di colina per la sintesi dell'acetilcolina. Protegge le membrane cellulari cerebrali.",
          "detailedBenefits": [
            "Fornisce colina per la sintesi costante di acetilcolina",
            "Mantiene la fluidità e l'integrità della membrana neuronale",
            "Supporta la salute del fegato e il metabolismo dei grassi",
            "Migliora la comunicazione tra le cellule cerebrali"
          ],
          "timingRationale":
              "Assumere con i pasti per un assorbimento ottimale. È liposolubile, quindi i grassi alimentari aiutano l'uptake.",
          "dosageFrequency": "Una volta al giorno con un pasto",
          "dosageWarnings": [
            "Può causare lievi disturbi gastrointestinali",
            "Consultare un medico se si assumono farmaci colinergici",
            "Derivato dalla soia (scegliere PC di girasole in caso di allergie)",
            "Dosi molto elevate possono causare odore corporeo di pesce"
          ],
          "tldr":
              "Fosfolipide essenziale per la salute delle membrane cellulari e precursore dell'acetilcolina."
        },
        "es": {
          "name": "Fosfatidilcolina (PC)",
          "description":
              "Componente principal de las membranas celulares. Precursor de acetilcolina.",
          "mechanismOfAction":
              "Apoya la integridad estructural de las neuronas y sirve como reservorio de colina para la síntesis de acetilcolina. Protege las membranas.",
          "detailedBenefits": [
            "Proporciona colina para la síntesis constante de acetilcolina",
            "Mantiene la fluidez e integridad de la membrana neuronal",
            "Apoya la salud del hígado y el metabolismo de las grasas",
            "Mejora la comunicación entre las células cerebrales"
          ],
          "timingRationale":
              "Tomar con las comidas para una absorción óptima. Es soluble en grasa, por lo que la grasa dietética ayuda.",
          "dosageFrequency": "Una vez al día con una comida",
          "dosageWarnings": [
            "Puede causar molestias gastrointestinales leves",
            "Consulte a un médico si toma medicamentos colinérgicos",
            "Derivado de la soja (elija PC de girasol si tiene alergia)",
            "Dosis muy altas pueden causar olor corporal a pescado"
          ],
          "tldr":
              "Fosfolípido esencial para la salud de la membrana celular y precursor de acetilcolina."
        }
      },
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
          "Mixed tocopherols preferred. Protects omega-3 fats from oxidation and supports brain membrane health.",
      "status": "beneficial",
      "focusLevel": 2,
      "mechanismOfAction":
          "Vitamin E is the primary fat-soluble antioxidant in brain cell membranes, shielding them from lipid peroxidation. It works synergistically with Omega-3 fatty acids, preventing them from oxidizing and losing their neuroprotective properties. It also supports cognitive function by reducing neuroinflammation.",
      "detailedBenefits": [
        "Protects neuronal membrane lipids from oxidative damage",
        "Synergistically stabilizes Omega-3 fatty acids in the brain",
        "Supports long-term cognitive maintenance and neuroprotection",
        "Reduces oxidative stress markers in the central nervous system"
      ],
      "timingRationale":
          "Water-soluble vitamins are easily excreted, but Vitamin E is fat-soluble and should be taken with a meal containing some fat for optimal absorption. Morning or evening use is generally fine.",
      "scientificEvidenceRank": 60,
      "studyLinks": {
        "Vitamin E and cognitive performance":
            "https://pubmed.ncbi.nlm.nih.gov/24337199/",
        "Antioxidant protection in brain":
            "https://pubmed.ncbi.nlm.nih.gov/11264871/"
      },
      "dosageByWeight": {
        "40-60": "100-200 IU",
        "60-80": "200-400 IU",
        "80-100": "400 IU",
        "100-120": "400-800 IU"
      },
      "dosageFrequency": "Once daily with a fatty meal",
      "dosageWarnings": [
        "High doses (>800 IU) may increase bleeding risk especially if on blood thinners",
        "Use mixed tocopherols (alpha, beta, gamma, delta) for full spectrum benefits",
        "Generally very safe at recommended doses"
      ],
      "tldr":
          "Fat-soluble antioxidant that protects brain membranes; works synergistically with omega-3s.",
      "translations": {
        "it": {
          "name": "Vitamina E (Tocoferoli Misti)",
          "description":
              "Preferire tocoferoli misti. Protegge i grassi omega-3 dall'ossidazione e supporta la salute delle membrane cerebrali.",
          "mechanismOfAction":
              "La vitamina E è il principale antiossidante liposolubile nelle membrane cellulari cerebrali, proteggendole dalla perossidazione lipidica. Lavora in sinergia con gli acidi grassi Omega-3.",
          "timingRationale":
              "Assumere con un pasto contenente grassi. Mattina o sera va bene.",
          "detailedBenefits": [
            "Protegge i lipidi della membrana neuronale dal danno ossidativo",
            "Stabilizza sinergicamente gli acidi grassi Omega-3 nel cervello",
            "Supporta il mantenimento cognitivo a lungo termine e la neuroprotezione",
            "Riduce i marcatori di stress ossidativo nel sistema nervoso centrale"
          ],
          "dosageFrequency": "Una volta al giorno con un pasto grasso",
          "dosageWarnings": [
            "Alte dosi (>800 UI) possono aumentare il rischio di sanguinamento",
            "Utilizzare tocoferoli misti per benefici a spettro completo",
            "Generalmente molto sicuro alle dosi raccomandate"
          ],
          "tldr":
              "Antiossidante liposolubile che protegge le membrane cerebrali; lavora in sinergia con gli omega-3."
        },
        "es": {
          "name": "Vitamina E (Tocoferoles Mixtos)",
          "description":
              "Se prefieren los tocoferoles mixtos. Protege las grasas omega-3 de la oxidación y apoya la salud de la membrana cerebral.",
          "mechanismOfAction":
              "La vitamina E es el principal antioxidante liposoluble en las membranas celulares del cerebro, protegiéndolas de la peroxidación lipídica. Funciona sinérgicamente con los ácidos grasos Omega-3.",
          "timingRationale":
              "Tomar con una comida que contenga grasa. Mañana o noche está bien.",
          "detailedBenefits": [
            "Protege los lípidos de la membrana neuronal del daño oxidativo",
            "Estabiliza sinérgicamente los ácidos grasos Omega-3 en el cerebro",
            "Apoya el mantenimiento cognitivo a largo plazo y la neuroprotección",
            "Reduce los marcadores de estrés oxidativo en el sistema nervioso central"
          ],
          "dosageFrequency": "Una vez al día con una comida grasa",
          "dosageWarnings": [
            "Dosis altas (>800 UI) pueden aumentar el riesgo de sangrado",
            "Use tocoferoles mixtos para beneficios de espectro completo",
            "Generalmente muy seguro en las dosis recomendadas"
          ],
          "tldr":
              "Antioxidante liposoluble que protege las membranas cerebrales; funciona sinérgicamente con omega-3."
        }
      },
    },
    {
      "id": "coq10",
      "name": "Coenzyme Q10 (Ubiquinol)",
      "category": "Antioxidant",
      "dosage": "100-200mg",
      "timeOfDay": "morning",
      "benefits": [
        "Mitochondrial Energy",
        "Brain Cell Energy",
        "Antioxidant Protection"
      ],
      "evidenceLevel": "moderate",
      "notes":
          "Ubiquinol form preferred for better absorption. Supports ATP production in mitochondria.",
      "status": "beneficial",
      "focusLevel": 3,
      "mechanismOfAction":
          "CoQ10 is a critical component of the electron transport chain in mitochondria, facilitating ATP (cellular energy) production. The ubiquinol form is the reduced, active antioxidant form that protects cell membranes from oxidative damage. Brain cells have high energy demands and are particularly vulnerable to mitochondrial dysfunction.",
      "detailedBenefits": [
        "Enhances mitochondrial ATP production in neurons",
        "Protects dopaminergic neurons from oxidative stress",
        "May improve mental fatigue and processing speed",
        "Supports cardiovascular health (important for brain blood flow)"
      ],
      "timingRationale":
          "Morning dosing with a fatty meal maximizes absorption (CoQ10 is fat-soluble). Supports daytime energy production when cognitive demands are highest. Avoid evening dosing as it may be energizing.",
      "scientificEvidenceRank": 68,
      "studyLinks": {
        "CoQ10 and cognitive function":
            "https://pubmed.ncbi.nlm.nih.gov/31806905/",
        "Mitochondrial dysfunction in Focus":
            "https://pubmed.ncbi.nlm.nih.gov/28093713/",
        "Ubiquinol vs ubiquinone bioavailability":
            "https://pubmed.ncbi.nlm.nih.gov/17287847/"
      },
      "dosageByWeight": {
        "40-60": "50-100mg",
        "60-80": "100-150mg",
        "80-100": "150-200mg",
        "100-120": "200-300mg"
      },
      "dosageFrequency": "Once daily with a fatty meal (breakfast or lunch)",
      "dosageWarnings": [
        "May interact with blood thinners (warfarin) - consult advisor",
        "Can lower blood pressure - monitor if on BP elements",
        "Ubiquinol form is more expensive but better absorbed",
        "Generally very safe; side effects rare at recommended doses"
      ],
      "tldr":
          "Supports mitochondrial energy production and provides antioxidant protection for high-energy brain cells.",
      "translations": {
        "it": {
          "name": "Coenzima Q10 (Ubiquinolo)",
          "description":
              "Forma ubiquinolo preferita per un migliore assorbimento. Supporta la produzione di ATP nei mitocondri.",
          "mechanismOfAction":
              "Il CoQ10 è un componente critico della catena di trasporto degli elettroni nei mitocondri, facilitando la produzione di ATP. La forma ubiquinolo è l'antiossidante attivo ridotto.",
          "timingRationale":
              "Dosaggio mattutino con un pasto grasso. Supporta la produzione di energia diurna. Evitare l'uso serale.",
          "detailedBenefits": [
            "Potenzia la produzione di ATP mitocondriale nei neuroni",
            "Protegge i neuroni dopaminergici dallo stress ossidativo",
            "Può migliorare la fatica mentale e la velocità di elaborazione",
            "Supporta la salute cardiovascolare"
          ],
          "dosageFrequency": "Una volta al giorno con un pasto grasso",
          "dosageWarnings": [
            "Può interagire con anticoagulanti (warfarin)",
            "Può abbassare la pressione sanguigna",
            "La forma ubiquinolo è più costosa ma meglio assorbita",
            "Generalmente molto sicuro; effetti collaterali rari"
          ],
          "tldr":
              "Supporta la produzione di energia mitocondriale e fornisce protezione antiossidante per le cellule cerebrali ad alta energia."
        },
        "es": {
          "name": "Coenzima Q10 (Ubiquinol)",
          "description":
              "Se prefiere la forma de ubiquinol para una mejor absorción. Apoya la producción de ATP en las mitocondrias.",
          "mechanismOfAction":
              "La CoQ10 es un componente crítico de la cadena de transporte de electrones en las mitocondrias, lo que facilita la producción de ATP. La forma de ubiquinol es el antioxidante activo reducido.",
          "timingRationale":
              "Dosis matutina con una comida grasa. Apoya la producción de energía durante el día. Evite el uso nocturno.",
          "detailedBenefits": [
            "Mejora la producción de ATP mitocondrial en las neuronas",
            "Protege las neuronas dopaminérgicas del estrés oxidativo",
            "Puede mejorar la fatiga mental y la velocidad de procesamiento",
            "Apoya la salud cardiovascular"
          ],
          "dosageFrequency": "Una vez al día con una comida grasa",
          "dosageWarnings": [
            "Puede interactuar con anticoagulantes (warfarina)",
            "Puede bajar la presión arterial",
            "La forma de ubiquinol es más cara pero se absorbe mejor",
            "Generalmente muy seguro; los efectos secundarios son raros"
          ],
          "tldr":
              "Apoya la producción de energía mitocondrial y proporciona protección antioxidante para las células cerebrales de alta energía."
        }
      },
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
          "Essential for neurodevelopment and dopamine receptor sensitivity. Avoid megadoses.",
      "status": "beneficial",
      "focusLevel": 2,
      "mechanismOfAction":
          "Retinoic acid, a derivative of Vitamin A, is a potent signaling molecule in the brain that regulates gene expression. It is critical for the induction of dopamine receptors and supporting overall neuroplasticity. Proper levels are essential for neurodevelopment and hippocampal function.",
      "detailedBenefits": [
        "Supports induction and sensitivity of dopamine receptors",
        "Crucial for hippocampal neurogenesis and memory",
        "Regulates gene expression essential for neurodevelopment",
        "Acts as a powerful antioxidant to protect visual processing pathways"
      ],
      "timingRationale":
          "As a fat-soluble vitamin, it must be taken with a meal containing some dietary fat to reach the bloodstream. Timing is flexible, though most include it with their largest meal.",
      "scientificEvidenceRank": 62,
      "studyLinks": {
        "Retinoic acid and dopamine receptors":
            "https://pubmed.ncbi.nlm.nih.gov/11547055/",
        "Vitamin A in hippocampal plasticit":
            "https://pubmed.ncbi.nlm.nih.gov/17502394/"
      },
      "dosageByWeight": {
        "40-60": "1000-2000 IU",
        "60-80": "2000-3000 IU",
        "80-100": "3000-5000 IU",
        "100-120": "5000 IU"
      },
      "dosageFrequency": "Once daily with a fatty meal",
      "dosageWarnings": [
        "⚠️ AVOID megadoses: Toxic above 10,000 IU daily long-term (polar bear liver effect)",
        "Pregnant women should consult advisor (risk of birth defects at high doses)",
        "Beta-carotene is a safer precursor for those at risk of toxicity"
      ],
      "tldr":
          "Fat-soluble vitamin supporting neuroplasticity and dopamine receptor function; avoid megadoses.",
      "translations": {
        "it": {
          "name": "Vitamina A (Retinolo)",
          "description":
              "Essenziale per la neurosviluppo e la sensibilità dei recettori della dopamina. Evitare megadosi.",
          "mechanismOfAction":
              "L'acido retinoico, un derivato della vitamina A, è una potente molecola di segnalazione nel cervello che regola l'espressione genica. È critico per l'induzione dei recettori della dopamina.",
          "timingRationale":
              "Assumere con un pasto contenente grassi. La tempistica è flessibile.",
          "detailedBenefits": [
            "Supporta l'induzione e la sensibilità dei recettori della dopamina",
            "Cruciale per la neurogenesi ippocampale e la memoria",
            "Regola l'espressione genica essenziale per il neurosviluppo",
            "Agisce come potente antiossidante per proteggere le vie visive"
          ],
          "dosageFrequency": "Una volta al giorno con un pasto grasso",
          "dosageWarnings": [
            "⚠️ EVITARE megadosi: Tossico sopra 10.000 UI al giorno a lungo termine",
            "Le donne in gravidanza dovrebbero consultare un medico",
            "Il beta-carotene è un precursore più sicuro per chi è a rischio di tossicità"
          ],
          "tldr":
              "Vitamina liposolubile che supporta la neuroplasticità e la funzione dei recettori della dopamina; evitare megadosi."
        },
        "es": {
          "name": "Vitamina A (Retinol)",
          "description":
              "Esencial para el neurodesarrollo y la sensibilidad del receptor de dopamina. Evite las megadosis.",
          "mechanismOfAction":
              "El ácido retinoico, un derivado de la vitamina A, es una potente molécula de señalización en el cerebro que regula la expresión génica. Es fundamental para la inducción de receptores de dopamina.",
          "timingRationale":
              "Tomar con una comida que contenga grasa. El horario es flexible.",
          "detailedBenefits": [
            "Apoya la inducción y sensibilidad de los receptores de dopamina",
            "Crucial para la neurogénesis del hipocampo y la memoria",
            "Regula la expresión génica esencial para el neurodesarrollo",
            "Actúa como un potente antioxidante para proteger las vías visuales"
          ],
          "dosageFrequency": "Una vez al día con una comida grasa",
          "dosageWarnings": [
            "⚠️ EVITE megadosis: Tóxico por encima de 10,000 UI diarias a largo plazo",
            "Las mujeres embarazadas deben consultar a un asesor",
            "El betacaroteno es un precursor más seguro para quienes están en riesgo"
          ],
          "tldr":
              "Vitamina liposoluble que apoya la neuroplasticidad y la función del receptor de dopamina; evite las megadosis."
        }
      },
    },
    {
      "id": "st-johns-wort",
      "name": "St. John's Wort",
      "category": "Herb",
      "dosage": "300mg",
      "timeOfDay": "morning",
      "benefits": ["Mild Depression", "Mood Support"],
      "evidenceLevel": "moderate",
      "notes":
          "⚠️ CAUTION: Powerful CYP450 enzyme inducer. Interacts with MANY elements including birth control, antidepressants, and blood thinners. NOT recommended for Focus.",
      "status": "caution",
      "focusLevel": 2,
      "mechanismOfAction":
          "St. John's Wort contains hypericin and hyperforin which modulate serotonin, dopamine, and norepinephrine reuptake. However, it is a potent inducer of CYP450 enzymes (particularly CYP3A4), which dramatically increases the metabolism of many elements, reducing their effectiveness. This makes it incompatible with most pharmaceutical supports.",
      "detailedBenefits": [
        "May help mild to moderate depression (comparable to SSRIs in some studies)",
        "Modulates multiple neurotransmitter systems",
        "Natural alternative to pharmaceutical antidepressants for some people"
      ],
      "timingRationale":
          "Morning dosing if used. However, NOT RECOMMENDED for people with Focus due to extensive drug compatibilitys with Type A elements and other common supports. Effects build over 2-4 weeks. The CYP450 induction persists for weeks after discontinuation.",
      "scientificEvidenceRank": 65,
      "studyLinks": {
        "St. John's Wort for depression":
            "https://pubmed.ncbi.nlm.nih.gov/18843608/",
        "Drug compatibilitys and CYP450 induction":
            "https://pubmed.ncbi.nlm.nih.gov/15106147/",
        "Contrainelements and safety":
            "https://pubmed.ncbi.nlm.nih.gov/24931003/"
      },
      "dosageByWeight": {
        "40-60": "300mg",
        "60-80": "300-600mg",
        "80-100": "600mg",
        "100-120": "600-900mg"
      },
      "dosageFrequency":
          "Once or twice daily (NOT RECOMMENDED for Focus users)",
      "dosageWarnings": [
        "⚠️ CRITICAL: Reduces effectiveness of birth control pills by 50%+",
        "⚠️ Interacts with SSRIs, SNRIs (serotonin syndrome risk)",
        "⚠️ Reduces effectiveness of blood thinners, immunosuppressants, HIV elements",
        "⚠️ May interact with Focus Profile A elements",
        "Causes photosensitivity - increases sun sensitivity",
        "NOT RECOMMENDED for people on multiple elements"
      ],
      "tldr":
          "Herb for mild depression but EXTENSIVE drug compatibilitys make it unsuitable for most Focus users on elements.",
      "translations": {
        "it": {
          "name": "Iperico (Erba di San Giovanni)",
          "description":
              "Contiene ipericina e iperforina che modulano la ricaptazione di serotonina, dopamina e norepinefrina. Tuttavia, è un potente induttore degli enzimi CYP450 (in particolare CYP3A4), il che aumenta drammaticamente il metabolismo di molti elementi, riducendo la loro efficacia. Questo lo rende incompatibile con la maggior parte dei supporti farmaceutici.",
          "mechanismOfAction":
              "Iperico contiene ipericina e iperforina che modulano la ricaptazione di serotonina, dopamina e norepinefrina. Tuttavia, è un potente induttore degli enzimi CYP450 (in particolare CYP3A4), il che aumenta drammaticamente il metabolismo di molti elementi, riducendo la loro efficacia.",
          "timingRationale":
              "Dosaggio mattutino se usato. Tuttavia, NON RACCOMANDATO per le persone con Focus a causa delle estese incompatibilità farmacologiche con elementi di Tipo A e altri supporti comuni. Gli effetti si accumulano in 2-4 settimane. L'induzione del CYP450 persiste per settimane dopo l'interruzione.",
          "detailedBenefits": [
            "Può aiutare la depressione da lieve a moderata",
            "Modula diversi sistemi di neurotrasmettitori",
            "Alternativa naturale agli antidepressivi farmaceutici per alcuni"
          ],
          "dosageFrequency": "Una o due volte al giorno (NON RACCOMANDATA)",
          "dosageWarnings": [
            "⚠️ CRITICO: Riduce l'efficacia della pillola anticoncezionale del 50%+",
            "⚠️ Interagisce con SSRI, SNRI (rischio sindrome serotoninergica)",
            "⚠️ Riduce l'efficacia di anticoagulanti e immunosoppressori",
            "⚠️ Può interagire con farmaci di Tipo A",
            "Causa fotosensibilità",
            "NON RACCOMANDATO per chi assume più farmaci"
          ],
          "tldr":
              "Erba per depressione lieve ma le ESTESE incompatibilità farmacologiche la rendono inadatta per la maggior parte degli utenti Focus in trattamento."
        },
        "es": {
          "name": "Hierba de San Juan",
          "description":
              "Contiene hipericina e hiperforina que modulan la recaptación de serotonina, dopamina y norepinefrina. Sin embargo, es un potente inductor de las enzimas CYP450 (particularmente CYP3A4), lo que aumenta drásticamente el metabolismo de muchos elementos, reduciendo su eficacia. Esto lo hace incompatible con la mayoría de los soportes farmacéuticos.",
          "mechanismOfAction":
              "La hierba de San Juan contiene hipericina e hiperforina que modulan la recaptación de serotonina, dopamina y norepinefrina. Sin embargo, es un potente inductor de las enzimas CYP450 (particularmente CYP3A4), lo que aumenta drásticamente el metabolismo de muchos elementos, reduciendo su eficacia.",
          "timingRationale":
              "Dosis matutina si se usa. Sin embargo, NO SE RECOMIENDA para personas con Focus debido a las amplias incompatibilidades farmacológicas con los elementos de Tipo A y otros soportes comunes. Los efectos se acumulan durante 2-4 semanas. La inducción de CYP450 persiste durante semanas después de la interrupción.",
          "detailedBenefits": [
            "Puede ayudar con la depresión leve a moderada",
            "Modula múltiples sistemas de neurotransmisores",
            "Alternativa natural a los antidepresivos farmacéuticos para algunos"
          ],
          "dosageFrequency": "Una o dos veces al día (NO SE RECOMIENDA)",
          "dosageWarnings": [
            "⚠️ CRÍTICO: Reduce la eficacia de las píldoras anticonceptivas en un 50%+",
            "⚠️ Interactúa con ISRS, IRSN (riesgo de síndrome serotoninérgico)",
            "⚠️ Reduce la eficacia de anticoagulantes e inmunosupresores",
            "⚠️ Puede interactuar con elementos Tipo A",
            "Causa fotosensibilidad",
            "NO SE RECOMIENDA para personas con múltiples medicamentos"
          ],
          "tldr":
              "Hierba para la depresión leve, pero las EXTENSAS incompatibilidades farmacológicas la hacen inadecuada para la mayoría de los usuarios de Focus en tratamiento."
        }
      },
    },
    {
      "id": "valerian-root",
      "name": "Valerian Root",
      "category": "Herb",
      "dosage": "300-600mg",
      "timeOfDay": "evening",
      "benefits": ["Sleep Support", "Anxiety Reduction"],
      "evidenceLevel": "low",
      "notes":
          "⚠️ CAUTION: Sedating herb for sleep. Can cause morning grogginess. May interact with other sedatives. Not for daytime use.",
      "status": "caution",
      "focusLevel": 2,
      "mechanismOfAction":
          "Valerian root contains valerenic acid which modulates GABA-A receptors, similar to benzodiazepines but much weaker. It increases GABA availability and has mild sedative effects. However, response is highly variable between individuals, and it can cause paradoxical stimulation in some people. Also inhibits CYP450 enzymes.",
      "detailedBenefits": [
        "May reduce sleep latency (time to fall asleep) by 15-20 minutes",
        "Mild anxiolytic effects through GABAergic activity",
        "Non-addictive alternative to prescription sleep aids for some"
      ],
      "timingRationale":
          "Evening only, 30-120 minutes before bed. Highly variable onset time between individuals. Can cause significant morning grogginess or 'hangover' effect. NOT for daytime use. Effects may build over 2-4 weeks of consistent use. Avoid if you need to wake up alert.",
      "scientificEvidenceRank": 58,
      "studyLinks": {
        "Valerian for sleep quality":
            "https://pubmed.ncbi.nlm.nih.gov/16335332/",
        "GABA modulation mechanism":
            "https://pubmed.ncbi.nlm.nih.gov/15650394/",
        "Safety and drug compatibilitys":
            "https://pubmed.ncbi.nlm.nih.gov/17145239/"
      },
      "dosageByWeight": {
        "40-60": "300mg",
        "60-80": "400-500mg",
        "80-100": "500-600mg",
        "100-120": "600mg"
      },
      "dosageFrequency": "Once daily in evening, 30-120 min before bed",
      "dosageWarnings": [
        "⚠️ Can cause significant morning grogginess or 'hangover'",
        "⚠️ May interact with other sedatives, alcohol, benzodiazepines",
        "⚠️ Can cause paradoxical stimulation in some people",
        "Avoid before driving or operating machinery",
        "May inhibit CYP450 enzymes - potential drug compatibilitys",
        "Discontinue 2 weeks before surgery (anesthesia compatibility)"
      ],
      "tldr":
          "Sedating herb for sleep support; highly variable effects and can cause morning grogginess.",
      "translations": {
        "it": {
          "name": "Radice di Valeriana",
          "description":
              "La radice di valeriana contiene acido valerenico che modula i recettori GABA-A, simile alle benzodiazepine ma molto più debole. Aumenta la disponibilità di GABA e ha lievi effetti sedativi. Tuttavia, la risposta è altamente variabile tra gli individui e può causare stimolazione paradossa in alcune persone. Inibisce anche gli enzimi CYP450.",
          "mechanismOfAction":
              "La radice di valeriana contiene acido valerenico che modula i recettori GABA-A, simile alle benzodiazepine ma molto più debole. Aumenta la disponibilità di GABA e ha lievi effetti sedativi. Tuttavia, la risposta è altamente variabile tra gli individui e può causare stimolazione paradossa in alcune persone.",
          "timingRationale":
              "Solo la sera, 30-120 minuti prima di coricarsi. Tempo di insorgenza altamente variabile tra gli individui. Può causare significativo stordimento mattutino o effetto 'postumi della sbornia'. NON per uso diurno. Gli effetti possono accumularsi in 2-4 settimane di uso costante.",
          "detailedBenefits": [
            "Può ridurre la latenza del sonno (tempo per addormentarsi) di 15-20 minuti",
            "Effetti ansiolitici lievi attraverso l'attività GABAergica",
            "Alternativa non additiva ai sonniferi su prescrizione per alcuni"
          ],
          "dosageFrequency":
              "Una volta al giorno la sera, 30-120 min prima di dormire",
          "dosageWarnings": [
            "Può causare stordimento mattutino o effetto 'postumi'",
            "Può interagire con altri sedativi, alcol o benzodiazepine",
            "Può causare stimolazione paradossa in alcune persone",
            "Evitare prima di guidare o usare macchinari"
          ],
          "tldr":
              "Erba sedativa per il supporto del sonno; effetti altamente variabili e può causare stordimento mattutino."
        },
        "es": {
          "name": "Raíz de Valeriana",
          "description":
              "La raíz de valeriana contiene ácido valerénico que modula los receptores GABA-A, similar a las benzodiazepinas pero mucho más débil. Aumenta la disponibilidad de GABA y tiene efectos sedantes leves. Sin embargo, la respuesta es muy variable entre individuos y puede causar estimulación paradójica en algunas personas. También inhibe las enzimas CYP450.",
          "mechanismOfAction":
              "La raíz de valeriana contiene ácido valerénico que modula los receptores GABA-A, similar a las benzodiazepinas pero mucho más débil. Aumenta la disponibilidad de GABA y tiene efectos sedantes leves. Sin embargo, la respuesta es muy variable entre individuos y puede causar estimulación paradójica en algunas personas.",
          "timingRationale":
              "Solo por la noche, 30-120 minutos antes de acostarse. Tiempo de inicio muy variable entre individuos. Puede causar aturdimiento matutino significativo o efecto de 'resaca'. NO para uso diurno. Los efectos pueden acumularse durante 2-4 semanas de uso constante.",
          "detailedBenefits": [
            "Puede reducir la latencia del sueño (tiempo para dormirse) en 15-20 minutos",
            "Efectos ansiolíticos leves a través de la actividad GABAérgica",
            "Alternativa no adictiva a los somníferos recetados para algunos"
          ],
          "dosageFrequency":
              "Una vez al día por la noche, 30-120 min antes de acostarse",
          "dosageWarnings": [
            "Puede causar aturdimiento matutino significativo o efecto de 'resaca'",
            "Puede interactuar con otros sedantes, alcohol o benzodiazepinas",
            "Puede causar estimulación paradójica en algunas personas",
            "Evitar antes de conducir o manejar maquinaria"
          ],
          "tldr":
              "Hierba sedante para el apoyo del sueño; efectos altamente variables y puede causar aturdimiento matutino."
        }
      },
    },
    {
      "id": "kava-kava",
      "name": "Kava Kava",
      "category": "Herb",
      "dosage": "200-300mg kavalactones",
      "timeOfDay": "evening",
      "benefits": ["Anxiety Reduction", "Relaxation"],
      "evidenceLevel": "moderate",
      "notes":
          "⚠️ CAUTION: Effective anxiolytic but LIVER TOXICITY RISK. Banned in several countries. Use only high-quality noble kava. Monitor liver enzymes. NOT for long-term use.",
      "status": "caution",
      "focusLevel": 2,
      "mechanismOfAction":
          "Kava's kavalactones modulate GABA-A receptors and block voltage-gated sodium channels, producing anxiolytic and muscle-relaxant effects without sedation at lower doses. However, certain kava preparations (especially those using stems/leaves or non-noble varieties) contain hepatotoxic compounds that can cause severe liver damage. Mechanism of liver toxicity is not fully understood.",
      "detailedBenefits": [
        "Reduces anxiety by 50-60% in standard trials (comparable to benzodiazepines)",
        "Non-sedating anxiolytic at moderate doses",
        "May improve sleep quality without morning grogginess"
      ],
      "timingRationale":
          "Evening dosing preferred due to relaxation effects. Lower doses can be used during day for anxiety without sedation, but evening use is safer. Effects begin within 30-60 minutes. CRITICAL: Use only noble kava varieties (not tudei kava) and avoid long-term daily use due to liver toxicity risk.",
      "scientificEvidenceRank": 64,
      "studyLinks": {
        "Kava for anxiety disorders":
            "https://pubmed.ncbi.nlm.nih.gov/23235473/",
        "Hepatotoxicity concerns and safety":
            "https://pubmed.ncbi.nlm.nih.gov/17406128/",
        "Mechanism of action": "https://pubmed.ncbi.nlm.nih.gov/15639154/"
      },
      "dosageByWeight": {
        "40-60": "150-200mg kavalactones",
        "60-80": "200-250mg kavalactones",
        "80-100": "250-300mg kavalactones",
        "100-120": "300mg kavalactones"
      },
      "dosageFrequency": "Once daily in evening, NOT for long-term daily use",
      "dosageWarnings": [
        "⚠️ CRITICAL: LIVER TOXICITY RISK - monitor liver enzymes if using",
        "⚠️ Use ONLY noble kava varieties (not tudei kava or stem/leaf preparations)",
        "⚠️ Avoid if you have liver disease or take hepatotoxic elements",
        "⚠️ Do NOT combine with alcohol (increases liver toxicity risk)",
        "Can cause skin changes (kava dermopathy) with chronic use",
        "May interact with sedatives, anesthesia, and CYP450-metabolized drugs",
        "Banned in several countries due to safety concerns"
      ],
      "tldr":
          "Potent anxiolytic herb but SERIOUS liver toxicity risk; use only noble varieties and monitor liver function.",
      "translations": {
        "it": {
          "name": "Kava Kava",
          "description":
              "I kavalattoni della Kava modulano i recettori GABA-A e bloccano i canali del sodio voltaggio-dipendenti, producendo effetti ansiolitici e miorilassanti senza sedazione a dosi inferiori. Tuttavia, alcune preparazioni di kava (specialmente quelle che utilizzano steli/foglie o varietà non nobili) contengono composti epatotossici che possono causare gravi danni al fegato.",
          "mechanismOfAction":
              "I kavalattoni della Kava modulano i recettori GABA-A e bloccano i canali del sodio voltaggio-dipendenti, producendo effetti ansiolitici e miorilassanti senza sedazione a dosi inferiori. Tuttavia, alcune preparazioni di kava (specialmente quelle che utilizzano steli/foglie o varietà non nobili) contengono composti epatotossici che possono causare gravi danni al fegato.",
          "timingRationale":
              "Dosaggio serale preferito per gli effetti rilassanti. Dosi più basse possono essere usate durante il giorno per l'ansia senza sedazione, ma l'uso serale è più sicuro. Gli effetti iniziano entro 30-60 minuti. CRITICO: Utilizzare solo varietà di kava nobili e evitare l'uso quotidiano a lungo termine a causa del rischio di tossicità epatica.",
          "detailedBenefits": [
            "Riduce l'ansia del 50-60% nei test standard (paragonabile alle benzodiazepine)",
            "Ansiolitico non sedativo a dosi moderate",
            "Può migliorare la qualità del sonno senza stordimento mattutino"
          ],
          "dosageFrequency":
              "Una volta al giorno la sera, NON per uso quotidiano a lungo termine",
          "dosageWarnings": [
            "⚠️ CRITICO: RISCHIO DI TOSSICITÀ EPATICA - monitorare gli enzimi epatici",
            "⚠️ Utilizzare SOLO varietà di kava nobili (non preparati di gambo/foglia)",
            "⚠️ Evitare in caso di malattie epatiche o uso di sostanze epatotossiche",
            "⚠️ NON combinare con alcol (aumenta il rischio di tossicità epatica)"
          ],
          "tldr":
              "Potente erba ansiolitica ma GRAVE rischio di tossicità epatica; utilizzare solo varietà nobili e monitorare la funzionalità epatica."
        },
        "es": {
          "name": "Kava Kava",
          "description":
              "Las kavalactonas de Kava modulan los receptores GABA-A y bloquean los canales de sodio dependientes de voltaje, produciendo efectos ansiolíticos y relajantes musculares sin sedación a dosis más bajas. Sin embargo, ciertas preparaciones de kava (especialmente aquellas que usan tallos/hojas o variedades no nobles) contienen compuestos hepatotóxicos que pueden causar daño hepático severo.",
          "mechanismOfAction":
              "Las kavalactonas de Kava modulan los receptores GABA-A y bloquean los canales de sodio dependientes de voltaje, produciendo efectos ansiolíticos y relajantes musculares sin sedación a dosis más bajas. Sin embargo, ciertas preparaciones de kava (especialmente aquellas que usan tallos/hojas o variedades no nobles) contienen compuestos hepatotóxicos que pueden causar daño hepático severo.",
          "timingRationale":
              "Se prefiere la dosis nocturna debido a los efectos de relajación. Se pueden usar dosis más bajas durante el día para la ansiedad sin sedación, pero el uso nocturno es más seguro. Los efectos comienzan dentro de los 30-60 minutos. CRÍTICO: Use solo variedades de kava nobles y evite el uso diario a largo plazo debido al riesgo de toxicidad hepática.",
          "detailedBenefits": [
            "Reduce la ansiedad en un 50-60% en ensayos estándar (comparable a las benzodiazepinas)",
            "Ansiolítico no sedante a dosis moderadas",
            "Puede mejorar la calidad del sueño sin aturdimiento matutino"
          ],
          "dosageFrequency":
              "Una vez al día por la noche, NO para uso diario prolongado",
          "dosageWarnings": [
            "⚠️ CRÍTICO: RIESGO DE TOXICIDAD HEPÁTICA - controle las enzimas hepáticas",
            "⚠️ Use SOLO variedades de kava noble (no preparaciones de tallo/hoja)",
            "⚠️ Evitar si tiene enfermedad hepática o toma elementos hepatotóxicos",
            "⚠️ NO combinar con alcohol (aumenta el riesgo de toxicidad hepática)"
          ],
          "tldr":
              "Potente hierba ansiolítica pero GRAVE riesgo de toxicidad hepática; use solo variedades nobles y controle la función hepática."
        }
      },
    },
    {
      "id": "dmae",
      "name": "DMAE (Dimethylaminoethanol)",
      "category": "Nootropic",
      "dosage": "100-300mg",
      "timeOfDay": "morning",
      "benefits": ["Focus", "Mood"],
      "evidenceLevel": "low",
      "notes":
          "⚠️ CAUTION: Theoretical choline precursor but limited evidence. May cause overstimulation, insomnia, or headaches. Not well-researched for Focus.",
      "status": "caution",
      "focusLevel": 2,
      "mechanismOfAction":
          "DMAE is theorized to be a precursor to choline and acetylcholine, but this mechanism is poorly supported by research. It may modulate cholinergic activity through unclear pathways. Some studies suggest it stabilizes cell membranes. However, evidence for cognitive benefits is weak and inconsistent. May cause neural overstimulation in some individuals.",
      "detailedBenefits": [
        "Anecdotal reports of improved focus and mental clarity",
        "May have mild mood-enhancing effects",
        "Theoretical support for acetylcholine production (weak evidence)"
      ],
      "timingRationale":
          "Morning dosing if used, as it can be stimulating and cause insomnia. However, NOT RECOMMENDED due to limited evidence and potential for side effects. Effects are highly variable and unpredictable. Some people experience overstimulation, headaches, or irritability.",
      "scientificEvidenceRank": 42,
      "studyLinks": {
        "DMAE for cognitive function (limited evidence)":
            "https://pubmed.ncbi.nlm.nih.gov/3526687/",
        "Safety concerns and side effects":
            "https://pubmed.ncbi.nlm.nih.gov/6153094/",
        "Mechanism of action (theoretical)":
            "https://pubmed.ncbi.nlm.nih.gov/7301036/"
      },
      "dosageByWeight": {
        "40-60": "100mg",
        "60-80": "150-200mg",
        "80-100": "200-300mg",
        "100-120": "300mg"
      },
      "dosageFrequency": "Once daily in morning (NOT RECOMMENDED)",
      "dosageWarnings": [
        "⚠️ Limited scientific evidence for benefits",
        "⚠️ May cause overstimulation, insomnia, headaches, irritability",
        "⚠️ Can worsen challenges in some people with Focus",
        "Avoid if you have bipolar disorder (may trigger mania)",
        "May interact with cholinergic elements",
        "Not recommended during pregnancy or breastfeeding",
        "Better alternatives available (Alpha-GPC, CDP-Choline)"
      ],
      "tldr":
          "Theoretical nootropic with weak evidence and unpredictable effects; better choline sources available.",
      "translations": {
        "it": {
          "name": "DMAE",
          "description":
              "Precursore dell'acetilcolina. Migliora il tono della pelle come effetto collaterale. Supporta l'attenzione.",
          "mechanismOfAction":
              "Il DMAE aumenta livelli di colina e acetilcolina nel cervello. Agisce anche come scavenger di radicali liberi.",
          "timingRationale":
              "Dosaggio mattutino. Evitare durante la gravidanza.",
          "detailedBenefits": [
            "Segnalazioni aneddotiche di miglioramento del focus e della chiarezza mentale",
            "Può avere lievi effetti di miglioramento dell'umore",
            "Supporto teorico per la produzione di acetilcolina (evidenza debole)"
          ],
          "dosageFrequency":
              "Una volta al giorno al mattino (NON RACCOMANDATO)",
          "dosageWarnings": [
            "⚠️ Evidenza scientifica limitata per i benefici",
            "⚠️ Può causare sovrastimolazione, insonnia, mal di testa, irritabilità",
            "⚠️ Può peggiorare le sfide in alcune persone con ADHD",
            "Evitare in caso di disturbo bipolare (può scatenare mania)",
            "Non raccomandato in gravidanza o allattamento"
          ],
          "tldr":
              "Precursore dell'acetilcolina che supporta l'attenzione e la concentrazione mentale."
        },
        "es": {
          "name": "DMAE",
          "description":
              "Precursor de acetilcolina. Mejora el tono de la piel como efecto secundario. Apoya la atención.",
          "mechanismOfAction":
              "El DMAE aumenta los niveles de colina y acetilcolina en el cerebro. También actúa como eliminador de radicales libres.",
          "detailedBenefits": [
            "Informes anecdóticos de mayor enfoque y claridad mental",
            "Puede tener efectos leves que mejoran el estado de ánimo",
            "Soporte teórico para la producción de acetilcolina (evidencia débil)"
          ],
          "timingRationale": "Dosis matutina. Evitar durante el embarazo.",
          "dosageFrequency": "Una vez al día por la mañana (NO RECOMENDADO)",
          "dosageWarnings": [
            "⚠️ Evidencia científica limitada de los beneficios",
            "⚠️ Puede causar sobreestimulación, insomnio, dolores de cabeza, irritabilidad",
            "⚠️ Puede empeorar los desafíos en algunas personas con TDAH",
            "Evite si tiene trastorno bipolar (puede desencadenar manía)",
            "No recomendado durante el embarazo o la lactancia"
          ],
          "tldr":
              "Nootrópico teórico con evidencia débil y efectos impredecibles; mejores fuentes de colina disponibles."
        }
      },
    },
    {
      "id": "caffeine",
      "name": "Caffeine (with L-Theanine)",
      "category": "Type A",
      "dosage": "50-100mg",
      "timeOfDay": "morning",
      "benefits": ["Alertness", "Focus", "Reaction Time"],
      "evidenceLevel": "high",
      "notes":
          "⚠️ MUST combine with L-Theanine (2:1 ratio) for Focus to minimize jitters and anxiety. Alone may worsen impulsivity.",
      "status": "caution",
      "focusLevel": 5,
      "mechanismOfAction":
          "Caffeine is an adenosine receptor antagonist that prevents adenosine from binding to its receptors, thereby increasing alertness and wakefulness. It also indirectly increases dopamine and norepinephrine levels. When combined with L-Theanine, the 'jittery' side effects are mitigated through GABAergic modulation, creating a synergy that improves sustained attention without overstimulation.",
      "detailedBenefits": [
        "Reduces sleepiness and improves subjective alertness",
        "Enhances reaction time and processing speed",
        "Improves sustained attention when combined with L-Theanine",
        "Temporarily increases dopamine availability in the striatum"
      ],
      "timingRationale":
          "Morning use is best for alertness. Avoid use after 2:00 PM to prevent interference with sleep architecture (Caffeine has a ~5-6 hour half-life). Effects peak within 30-60 minutes. Use carefully with Type A items to avoid tachycardia or excessive anxiety.",
      "scientificEvidenceRank": 82,
      "studyLinks": {
        "Caffeine and L-Theanine synergy":
            "https://pubmed.ncbi.nlm.nih.gov/18681988/",
        "Caffeine effects on focus challenges":
            "https://pubmed.ncbi.nlm.nih.gov/21437156/",
        "Adenosine and dopamine compatibilitys":
            "https://pubmed.ncbi.nlm.nih.gov/11283318/"
      },
      "dosageByWeight": {
        "40-60": "50mg + 100mg L-Theanine",
        "60-80": "50-100mg + 100-200mg L-Theanine",
        "80-100": "100mg + 200mg L-Theanine",
        "100-120": "100-150mg + 200-300mg L-Theanine"
      },
      "dosageFrequency": "Once or twice daily (before 2 PM)",
      "dosageWarnings": [
        "⚠️ May increase heart rate and blood pressure",
        "⚠️ Can worsen anxiety, jitters, and sleep latency",
        "⚠️ Tolerance builds quickly; regular breaks are recommended",
        "⚠️ Avoid if sensitive to Type As or have heart conditions"
      ],
      "tldr":
          "Must be paired with L-Theanine to mitigate jitters; provides temporary alertness and focus but use with caution with Focus elements.",
      "translations": {
        "it": {
          "name": "Caffeina",
          "description":
              "Studiata per le sfide di concentrazione, ma spesso causa un 'crollo'. Usare con saggezza.",
          "mechanismOfAction":
              "Antagonista dei recettori dell'adenosina che previene il legame dell'adenosina, aumentando la vigilanza. Aumenta indirettamente i livelli di dopamina e norepinefrina.",
          "detailedBenefits": [
            "Riduce la sonnolenza e migliora la vigilanza soggettiva",
            "Migliora il tempo di reazione e la velocità di elaborazione",
            "Potenzia l'attenzione sostenuta se combinata con L-Teanina",
            "Aumenta temporaneamente la disponibilità di dopamina"
          ],
          "timingRationale":
              "L'uso mattutino è il migliore. Evitare dopo le 14:00 per non interferire con il sonno (emivita di ~5-6 ore). Picco entro 30-60 minuti.",
          "dosageFrequency": "Una o due volte al giorno (prima delle 14:00)",
          "dosageWarnings": [
            "Può aumentare la frequenza cardiaca e la pressione sanguigna",
            "Può peggiorare ansia, tremori e latenza del sonno",
            "La tolleranza si sviluppa rapidamente; consigliate pause regolari",
            "Evitare se sensibili agli stimolanti o con problemi cardiaci"
          ],
          "tldr":
              "Deve essere abbinata alla L-Teanina per mitigare i tremori; fornisce allerta temporanea ma usare con cautela."
        },
        "es": {
          "name": "Cafeína",
          "description":
              "Estudiada para desafíos de concentración, pero a menudo causa un 'choque'. Usar con sabiduría.",
          "mechanismOfAction":
              "Antagonista de los receptores de adenosina que evita que la adenosina se una a sus receptores, aumentando el estado de alerta. Aumenta indirectamente la dopamina.",
          "detailedBenefits": [
            "Reduce la somnolencia y mejora el estado de alerta subjetivo",
            "Mejora el tiempo de reacción y la velocidad de procesamiento",
            "Mejora la atención sostenida cuando se combina con L-Teanina",
            "Aumenta temporalmente la disponibilidad de dopamina"
          ],
          "timingRationale":
              "El uso matutino es mejor. Evite el uso después de las 2:00 PM para no interferir con el sueño. Los efectos alcanzan su punto máximo en 30-60 min.",
          "dosageFrequency": "Una o dos veces al día (antes de las 2 PM)",
          "dosageWarnings": [
            "Puede aumentar la frecuencia cardíaca y la presión arterial",
            "Puede empeorar la ansiedad, los nervios y la latencia del sueño",
            "La tolerancia se desarrolla rápido; se recomiendan descansos",
            "Evitar si es sensible a estimulantes o tiene problemas cardíacos"
          ],
          "tldr":
              "Debe combinarse con L-Teanina para mitigar el nerviosismo; proporciona alerta temporal pero úsela con precaución."
        }
      },
      "form": "Capsule"
    },
    {
      "id": "melatonin",
      "name": "Melatonin",
      "category": "Hormone",
      "dosage": "0.3-3mg",
      "timeOfDay": "evening",
      "benefits": ["Sleep Latency", "Sleep Quality", "Circadian Rhythm"],
      "evidenceLevel": "high",
      "notes":
          "⚠️ Use only for sleep. Use lowest effective dose (0.3-1mg often better than high doses). Does not treat attention challenges.",
      "status": "caution",
      "focusLevel": 2,
      "mechanismOfAction":
          "Melatonin is a hormone naturally produced by the pineal gland in response to darkness. It signals to the HPA axis and suprachiasmatic nucleus that it is time for sleep. Focus is frequently associated with a delayed melatonin onset; exogenous supplementation helps reset the circadian rhythm and reduces sleep latency (time to fall asleep).",
      "detailedBenefits": [
        "Reduces sleep latency by 15-30 minutes on average",
        "Helps synchronize the circadian rhythm in cases of delayed sleep phase",
        "Improves overall sleep quality and duration",
        "May reduce evening restlessness and 'tired but wired' feelings"
      ],
      "timingRationale":
          "Take 30-60 minutes before desired bedtime. Dim lights after taking to support natural production. Avoid 'screen time' (blue light) which suppresses melatonin. For circadian rhythm resetting, take at a consistent time every evening. Not for daytime use.",
      "scientificEvidenceRank": 89,
      "studyLinks": {
        "Melatonin for sleep in Focus":
            "https://pubmed.ncbi.nlm.nih.gov/30635432/",
        "Circadian rhythm and Focus":
            "https://pubmed.ncbi.nlm.nih.gov/30107544/",
        "Low dose vs high dose melatonin":
            "https://pubmed.ncbi.nlm.nih.gov/11600521/"
      },
      "dosageByWeight": {
        "40-60": "0.3-0.5mg",
        "60-80": "0.5-1mg",
        "80-100": "1-2mg",
        "100-120": "3mg"
      },
      "dosageFrequency": "Once daily, 30-60 min before bed",
      "dosageWarnings": [
        "⚠️ May cause morning grogginess if dose is too high",
        "⚠️ Can cause vivid dreams or nightmares in some individuals",
        "⚠️ May interact with blood pressure and diabetes elements",
        "⚠️ Long-term daily use in children should be generally supervised",
        "Not recommended for pregnant or breastfeeding women"
      ],
      "tldr":
          "Hormone that helps reset circadian rhythm and reduce sleep latency; highly effective for Focus-related sleep issues at low doses.",
      "translations": {
        "it": {
          "name": "Melatonina",
          "description":
              "Ormone per la regolazione del sonno. Dosi basse (0.5-3mg) sono spesso più efficaci.",
          "mechanismOfAction":
              "Regola il ritmo circadiano segnalando al corpo che è ora di dormire. Agisce come un potente antiossidante e aiuta a sincronizzare i cicli sonno-veglia.",
          "detailedBenefits": [
            "Riduce il tempo necessario per addormentarsi (latenza)",
            "Migliora la qualità e l'efficienza del sonno",
            "Aiuta a resettare il ritmo circadiano nei viaggiatori",
            "Supporta la neuroprotezione durante il riposo notturno"
          ],
          "timingRationale":
              "Assumere 30-60 minuti prima di coricarsi. Dosi minime (0.3-0.5mg) sono spesso più efficaci per il ritmo circadiano rispetto a dosi elevate.",
          "dosageFrequency": "Una volta al giorno (la sera)",
          "dosageWarnings": [
            "Può causare sonnolenza residua al mattino se la dose è eccessiva",
            "Non utilizzare durante la guida o l'uso di macchinari",
            "L'uso a lungo termine nei bambini deve essere supervisionato",
            "Non raccomandata in gravidanza o allattamento"
          ],
          "tldr":
              "Ormone del sonno per regolare il ritmo circadiano; iniziare con dosi basse."
        },
        "es": {
          "name": "Melatonina",
          "description":
              "Hormona para la regulación del sueño. Las dosis bajas (0.5-3 mg) suelen ser más efectivas.",
          "mechanismOfAction":
              "Regula el ritmo circadiano indicando al cuerpo que es hora de dormir. Actúa como un potente antioxidante y ayuda a sincronizar los ciclos.",
          "detailedBenefits": [
            "Reduce el tiempo necesario para conciliar el sueño",
            "Mejora la calidad y la eficiencia del sueño",
            "Ayuda a restablecer el ritmo circadiano en viajeros",
            "Apoya la neuroprotección durante el descanso"
          ],
          "timingRationale":
              "Tomar 30-60 minutos antes de acostarse. Las dosis bajas son a menudo más efectivas para el ritmo circadiano.",
          "dosageFrequency": "Una vez al día (por la noche)",
          "dosageWarnings": [
            "Puede causar somnolencia matutina si la dosis es alta",
            "No usar durante la conducción o uso de maquinaria",
            "El uso a largo plazo en niños debe ser supervisado",
            "No recomendada para mujeres embarazadas o lactantes"
          ],
          "tldr":
              "Hormona del sueño para regular el ritmo circadiano; comience con dosis bajas."
        }
      },
    },
    {
      "id": "5-htp",
      "name": "5-HTP (5-Hydroxytryptophan)",
      "category": "Amino Acid",
      "dosage": "50-100mg",
      "timeOfDay": "evening",
      "benefits": ["Mood Stability", "Sleep Quality", "Serotonin Support"],
      "evidenceLevel": "moderate",
      "notes":
          "⚠️ CRITICAL: Serotonin precursor. AVOID with SSRIs, SNRIs, or other serotonergic elements (risk of Serotonin Syndrome).",
      "status": "beneficial",
      "focusLevel": 2,
      "mechanismOfAction":
          "5-HTP is the immediate precursor to serotonin (5-HT). Unlike tryptophan, it crosses the blood-brain barrier very efficiently and does not require a transport molecule. It is directly decarboxylated into serotonin, which regulates mood, sleep, and impulse control. Serotonin is also a precursor to melatonin, supporting natural sleep architecture.",
      "detailedBenefits": [
        "Improves evening mood and reduces emotional dysregulation",
        "Enhances sleep quality by increasing natural melatonin production",
        "May reduce impulsive behaviors and carbohydrate cravings",
        "Supports emotional resilience in Focus users with comorbid anxiety"
      ],
      "timingRationale":
          "Evening dosing is optimal because serotonin supports melatonin production and can have a calming effect. Effects are often noticed within 1-2 hours for sleep. Dose should be 50-100mg; higher doses increase risk of nausea and side effects without much added benefit for most. Take with a small carb snack for best absorption.",
      "scientificEvidenceRank": 72,
      "studyLinks": {
        "5-HTP for depression and mood":
            "https://pubmed.ncbi.nlm.nih.gov/15146197/",
        "Serotonin and impulse control":
            "https://pubmed.ncbi.nlm.nih.gov/20561551/",
        "Safety and compatibility with SSRIs":
            "https://pubmed.ncbi.nlm.nih.gov/22129819/"
      },
      "dosageByWeight": {
        "40-60": "50mg",
        "60-80": "50-100mg",
        "80-100": "100mg",
        "100-120": "100-200mg"
      },
      "dosageFrequency": "Once daily in the evening",
      "dosageWarnings": [
        "⚠️ AVOID if taking SSRIs, SNRIs, MAOIs, or other antidepressants",
        "⚠️ Risk of Serotonin Syndrome (high fever, agitation, confusion)",
        "⚠️ May cause nausea or GI upset - take with food if needed",
        "Not for long-term daily use without supervision; cycle breaks recommended"
      ],
      "tldr":
          "Serotonin precursor that supports mood and sleep; highly effective but dangerous if combined with specific antidepressants.",
      "translations": {
        "it": {
          "name": "5-HTP (5-Idrossitriptofano)",
          "description":
              "Il 5-HTP è un composto che il corpo produce dall'aminoacido triptofano. È un precursore del neurotrasmettitore serotonina, che svolge un ruolo fondamentale nella regolazione dell'umore, del sonno e dei comportamenti impulsivi.",
          "mechanismOfAction":
              "Il 5-HTP è il precursore immediato della serotonina (5-HT). A differenza del triptofano, attraversa la barriera emato-encefalica in modo molto efficiente. Viene direttamente decarbossilato in serotonina, che regola l'umore e il controllo degli impulsi. La serotonina è anche un precursore della melatonina, supportando l'architettura naturale del sonno.",
          "detailedBenefits": [
            "Migliora l'umore serale e riduce la disregolazione emotiva",
            "Migliora la qualità del sonno aumentando la produzione naturale di melatonina",
            "Può ridurre i comportamenti impulsivi e la voglia di carboidrati",
            "Supporta la resilienza emotiva negli utenti Focus con ansia correlata"
          ],
          "timingRationale":
              "Il dosaggio serale è ottimale perché la serotonina supporta la produzione di melatonina e ha un effetto calmante. Gli effetti sono spesso notati entro 1-2 ore per il sonno. Assumere con un piccolo spuntino di carboidrati per un migliore assorbimento.",
          "dosageFrequency": "Una volta al giorno la sera",
          "dosageWarnings": [
            "⚠️ EVITARE se si assumono SSRI, SNRI, MAO o altri antidepressivi",
            "⚠️ Rischio di Sindrome Serotoninergica (febbre alta, agitazione, confusione)",
            "⚠️ Può causar nausea o disturbi gastrointestinali - assumere con cibo se necessario",
            "Non per uso quotidiano a lungo termine senza supervisione"
          ],
          "tldr":
              "Precursore della serotonina che supporta l'umore e il sonno; altamente efficace ma pericoloso se combinato con specifici antidepressivi."
        },
        "es": {
          "name": "5-HTP (5-Hidroxitriptófano)",
          "description":
              "El 5-HTP es un compuesto que el cuerpo produce a partir del aminoácido triptófano. Es un precursor del neurotransmisor serotonina, que desempeña un papel fundamental en la regulación del estado de ánimo, el sueño y los comportamientos impulsivos.",
          "mechanismOfAction":
              "El 5-HTP es el precursor inmediato de la serotonina (5-HT). A diferencia del triptófano, cruza la barrera hematoencefálica de manera muy eficiente. Se descarboxila directamente en serotonina, que regula el estado de ánimo y el control de los impulsos. La serotonina también es un precursor de la melatonina, apoyando la arquitectura natural del sueño.",
          "detailedBenefits": [
            "Mejora el estado de ánimo vespertino y reduce la desregulación emocional",
            "Mejora la calidad del sueño al aumentar la producción natural de melatonina",
            "Puede reducir los comportamientos impulsivos y los antojos de carbohidratos",
            "Apoya la resiliencia emocional en usuarios con ansiedad comórbida"
          ],
          "timingRationale":
              "La dosis nocturna es óptima porque la serotonina apoya la producción de melatonina y puede tener un efecto calmante. Los efectos a menudo se notan dentro de 1-2 horas para dormir. Tomar con un pequeño refrigerio de carbohidratos para una mejor absorción.",
          "dosageFrequency": "Una vez al día por la noche",
          "dosageWarnings": [
            "⚠️ EVITAR si toma ISRS, IRSN, IMAO u otros antidepresivos",
            "⚠️ Riesgo de Síndrome Serotoninérgico (fiebre alta, agitación, confusión)",
            "⚠️ Puede causar náuseas o malestar gastrointestinal; tomar con comida si es necesario",
            "No para uso diario prolongado sin supervisión"
          ],
          "tldr":
              "Precursor de serotonina que apoya el estado de ánimo y el sueño; altamente eficaz pero peligroso si se combina con antidepresivos específicos."
        }
      }
    },
    {
      "id": "copper",
      "name": "Copper",
      "category": "Mineral",
      "dosage": "1-2mg",
      "timeOfDay": "morning",
      "benefits": [
        "Dopamine Synthesis",
        "Energy Production",
        "Iron Metabolism"
      ],
      "evidenceLevel": "moderate",
      "notes":
          "⚠️ CAUTION: Only supplement if you take high-dose Zinc (Zn:Cu ratio of 15:1). Typical Focus users often have HIGH copper and LOW zinc.",
      "status": "caution",
      "focusLevel": 2,
      "mechanismOfAction":
          "Copper is a required cofactor for dopamine beta-hydroxylase, the enzyme that converts dopamine into norepinephrine. It is also essential for mitochondrial energy production (cytochrome c oxidase) and iron metabolism. However, copper and zinc compete for absorption; chronic high zinc intake can cause copper deficiency, and elevated copper-to-zinc ratios are a biomarker frequently observed in Focus populations.",
      "detailedBenefits": [
        "Supports the conversion of dopamine to norepinephrine",
        "Essential for mitochondrial ATP (energy) production",
        "Required for iron absorption and hemoglobin synthesis",
        "Supports connective tissue and neurotransmitter balance"
      ],
      "timingRationale":
          "Take in the morning with food to minimize potential GI upset. If taking Zinc, separate doses or use a combined formula that maintains the 15:1 Zinc-to-Copper ratio. Copper absorption is inhibited by high doses of Vitamin C; separate these by at least 2 hours.",
      "scientificEvidenceRank": 61,
      "studyLinks": {
        "Copper/Zinc ratios in Focus populations":
            "https://pubmed.ncbi.nlm.nih.gov/21350130/",
        "Copper role in dopamine metabolism":
            "https://pubmed.ncbi.nlm.nih.gov/11252112/",
        "Mineral competition for absorption":
            "https://pubmed.ncbi.nlm.nih.gov/11110860/"
      },
      "dosageByWeight": {
        "40-60": "0.5-1mg",
        "60-80": "1mg",
        "80-100": "1-2mg",
        "100-120": "2mg"
      },
      "dosageFrequency": "Once daily, preferably with food",
      "dosageWarnings": [
        "⚠️ High doses can be toxic and cause oxidative stress",
        "⚠️ May cause nausea, vomiting, or stomach pain if taken on empty stomach",
        "⚠️ DO NOT supplement if you already have high copper levels (common in Focus)",
        "⚠️ Long-term high-dose use can interfere with zinc and vitamin C status"
      ],
      "tldr":
          "Essential mineral for norepinephrine synthesis; only supplement if zinc intake is high, as copper/zinc balance is critical for Focus management.",
      "translations": {
        "it": {
          "name": "Rame",
          "description":
              "Minerale essenziale per la sintesi della norepinefrina; integrare solo se l'apporto di zinco è elevato.",
          "mechanismOfAction":
              "Il rame è un cofattore richiesto per la dopamina beta-idrossilasi, l'enzima che converte la dopamina in norepinefrina. È anche essenziale per la produzione di energia mitocondriale.",
          "detailedBenefits": [
            "Supporta la conversione della dopamina in norepinefrina",
            "Essenziale per la produzione di ATP (energia) mitocondriale",
            "Necessario per l'assorbimento del ferro e la sintesi dell'emoglobina",
            "Supporta il tessuto connettivo e l'equilibrio dei neurotrasmettitori"
          ],
          "timingRationale":
              "Assumere al mattino con il cibo per ridurre i disturbi gastrici. Se si assume zinco, separare le dosi per mantenere il rapporto 15:1.",
          "dosageFrequency": "Una volta al giorno, preferibilmente con il cibo",
          "dosageWarnings": [
            "⚠️ Dosi elevate possono essere tossiche e causare stress ossidativo",
            "⚠️ Può causare nausea o dolore addominale a stomaco vuoto",
            "⚠️ NON integrare se i livelli di rame sono già elevati",
            "⚠️ L'uso a lungo termine può interferire con lo stato dello zinco"
          ],
          "tldr":
              "Minerale essenziale per la sintesi della norepinefrina; integrare solo se l'apporto di zinco è elevato."
        },
        "es": {
          "name": "Cobre",
          "description":
              "Mineral esencial para la síntesis de norepinefrina; suplementar solo si la ingesta de zinc es alta.",
          "mechanismOfAction":
              "El cobre es un cofactor necesario para la dopamina beta-hidroxilasa, la enzima que convierte la dopamina en norepinefrina.",
          "detailedBenefits": [
            "Apoya la conversión de dopamina en norepinefrina",
            "Esencial para la producción de ATP (energía) mitocondrial",
            "Necesario para la absorción de hierro y la síntesis de hemoglobina",
            "Apoya el tejido conectivo y el equilibrio de neurotransmisores"
          ],
          "timingRationale":
              "Tomar por la mañana con comida. Si toma zinc, separe las dosis para mantener el ratio 15:1.",
          "dosageFrequency": "Una vez al día, preferiblemente con comida",
          "dosageWarnings": [
            "⚠️ Las dosis altas pueden ser tóxicas y causar estrés oxidativo",
            "⚠️ Puede causar náuseas o dolor de estómago con el estómago vacío",
            "⚠️ NO suplementar si ya tiene niveles altos de cobre",
            "⚠️ El uso prolongado puede interferir con los niveles de zinc"
          ],
          "tldr":
              "Mineral esencial para la síntesis de norepinefrina; suplementar solo si la ingesta de zinc es alta."
        }
      }
    },
    {
      "id": "b6-high-dose",
      "name": "Vitamin B6 (High-Dose Standalone)",
      "category": "Vitamin",
      "dosage": "25-50mg",
      "timeOfDay": "morning",
      "benefits": [
        "Neurotransmitter Synthesis",
        "Dopamine Support",
        "Energy Metabolism"
      ],
      "evidenceLevel": "high",
      "notes":
          "⚠️ CRITICAL: High standalone doses (>100mg/day) long-term can cause IRREVERSIBLE peripheral neuropathy (nerve damage). Best used in Magnesium+B6 combinations.",
      "status": "caution",
      "focusLevel": 2,
      "mechanismOfAction":
          "Pyridoxine (Vitamin B6) is a critical cofactor for over 100 enzymatic reactions, most notably the conversion of L-DOPA to dopamine and 5-HTP to serotonin. It is essential for amino acid metabolism and the creation of heme. However, excessive levels of pyridoxine can inhibit natural B6 metabolism and damage sensory neurons, leading to peripheral neuropathy characterized by numbness and tingling.",
      "detailedBenefits": [
        "Cofactor for the synthesis of dopamine, serotonin, and GABA",
        "Essential for mitochondrial energy production and iron metabolism",
        "Supports homocysteine metabolism for cardiovascular health",
        "May reduce PMS-related mood challenges in some individuals"
      ],
      "timingRationale":
          "Take in the morning with food to support daytime neurotransmitter synthesis. Avoid evening use as high doses can cause vivid dreams or insomnia in sensitive individuals. Do not exceed 100mg total daily intake from all sources combined (Tolerable Upper Intake Level).",
      "scientificEvidenceRank": 76,
      "studyLinks": {
        "Vitamin B6 and neurotransmitter synthesis":
            "https://pubmed.ncbi.nlm.nih.gov/20126403/",
        "B6 toxicity and peripheral neuropathy":
            "https://pubmed.ncbi.nlm.nih.gov/22116704/",
        "B6 and Magnesium synergy for Focus":
            "https://pubmed.ncbi.nlm.nih.gov/16846314/"
      },
      "dosageByWeight": {
        "40-60": "10-25mg",
        "60-80": "25mg",
        "80-100": "50mg",
        "100-120": "50-100mg"
      },
      "dosageFrequency": "Once daily with food",
      "dosageWarnings": [
        "⚠️ AVOID exceeding 100mg/day from all sources combined",
        "⚠️ DISCONTINUE immediately if you experience numbness, tingling, or nerve pain",
        "⚠️ Long-term use of standalone high doses carries greater risk than B-complex",
        "⚠️ May interfere with the metabolism of certain anti-seizure elements"
      ],
      "tldr":
          "Essential cofactor for dopamine and serotonin synthesis, but high standalone doses carry a risk of nerve damage; best used in balanced formulas.",
      "translations": {
        "it": {
          "name": "Vitamina B6 (Alto Dosaggio)",
          "description":
              "Cofattore critico per la sintesi dei neurotrasmettitori. Dosi elevate (>100mg) possono causare neuropatia periferica irreversibile.",
          "mechanismOfAction":
              "La piridossina (Vitamina B6) è un cofattore essenziale per la conversione di L-DOPA in dopamina e 5-HTP in serotonina.",
          "detailedBenefits": [
            "Cofattore per la sintesi di dopamina, serotonina e GABA",
            "Essenziale per la produzione di energia mitocondriale",
            "Supporta il metabolismo dell'omocisteina",
            "Può ridurre le sfide dell'umore legate alla PMS"
          ],
          "timingRationale":
              "Assumere al mattino con il cibo. Evitare l'uso serale poiché può causare sogni vividi. Non superare i 100mg totali al giorno.",
          "dosageFrequency": "Una volta al giorno con il cibo",
          "dosageWarnings": [
            "⚠️ EVITARE di superare i 100mg al giorno",
            "⚠️ INTERROMPERE immediatamente in caso di intorpidimento o formicolio",
            "⚠️ Il rischio di danni ai nervi è reale con dosi elevate isolate",
            "⚠️ Può interferire con alcuni farmaci anticonvulsivanti"
          ],
          "tldr":
              "Cofattore essenziale per la dopamina, ma dosi elevate isolate comportano rischi per i nervi; meglio in formule bilanciate."
        },
        "es": {
          "name": "Vitamina B6 (Alta Dosis)",
          "description":
              "Cofactor crítico para la síntesis de neurotransmisores. Dosis altas (>100mg) pueden causar neuropatía periférica irreversible.",
          "mechanismOfAction":
              "La piridoxina (Vitamina B6) es un cofactor crítico para la conversión de L-DOPA en dopamina y 5-HTP en serotonina.",
          "detailedBenefits": [
            "Cofactor para la síntesis de dopamina, serotonina y GABA",
            "Esencial para la producción de energía mitocondrial",
            "Apoya el metabolismo de la homocisteina",
            "Puede reducir los desafíos del estado de ánimo relacionados con el SPM"
          ],
          "timingRationale":
              "Tomar por la mañana con comida. Evite el uso nocturno ya que puede causar sueños vívidos. No exceder los 100mg diarios totales.",
          "dosageFrequency": "Una vez al día con comida",
          "dosageWarnings": [
            "⚠️ EVITAR exceder los 100mg al día",
            "⚠️ SUSPENDER inmediatamente si siente entumecimiento u hormigueo",
            "⚠️ El riesgo de daño nervioso es real con dosis altas aisladas",
            "⚠️ Puede interferir con ciertos medicamentos anticonvulsivos"
          ],
          "tldr":
              "Cofactor esencial para la dopamina, pero dosis altas aisladas conllevan riesgo de daño nervioso; mejor en fórmulas equilibradas."
        }
      }
    },
    {
      "id": "yellow-5",
      "name": "Yellow 5 (Tartrazine / E102)",
      "category": "Artificial Color",
      "description":
          "Synthetic coal-tar dye linked to increased restless energy and asthma flares. Requires 'may have an adverse effect on activity and attention in children' warning in the EU.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Tartrazine can induce histamine release and depletes body stores of zinc and vitamin B6. Since B6 is a crucial cofactor for dopamine synthesis, its depletion can lead to neurochemical imbalances and behavioral disruption.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Eliminating from diet is recommended for state control.",
      "scientificEvidenceRank": 73,
      "studyLinks": {
        "Southampton study on additives":
            "https://pubmed.ncbi.nlm.nih.gov/17825405/",
        "Zinc depletion and tartrazine":
            "https://pubmed.ncbi.nlm.nih.gov/7930261/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Known to trigger hives and asthma in sensitive individuals",
        "Significant correlation with impulsivity in Focus children",
        "Listed as Tartrazine or E102",
        "Common in pickles, mustard, cereals, and neon-colored snacks"
      ],
      "tldr":
          "Artificial yellow dye linked to restless energy and zinc/B6 depletion; avoid to maintain neurotransmitter balance.",
      "translations": {
        "it": {
          "name": "Giallo 5 (Tartrazina / E102)",
          "description":
              "Colorante sintetico derivato dal catrame di carbone collegato a un aumento dell'energia irrequieta e riacutizzazioni dell'asma. Richiede l'avvertenza 'può influire negativamente sull'attività e l'attenzione dei bambini' nell'UE.",
          "mechanismOfAction":
              "La tartrazina può indurre il rilascio di istamina e impoverire le riserve corporee di zinco e vitamina B6. Poiché la B6 è un cofattore cruciale per la sintesi della dopamina, la sua deplezione può portare a squilibri neurochimici e disturbi comportamentali.",
          "timingRationale":
              "EVITARE: L'eliminazione dalla dieta è raccomandata per il controllo dello stato.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Noto per innescare orticaria e asma in individui sensibili",
            "Significativa correlazione con l'impulsività nei bambini Focus",
            "Elencato come Tartrazina o E102",
            "Comune in sottaceti, senape, cereali e snack"
          ],
          "tldr":
              "Colorante artificiale giallo collegato all'energia irrequieta e alla deplezione di zinco/B6; evitare per mantenere l'equilibrio dei neurotrasmettitori."
        },
        "es": {
          "name": "Amarillo 5 (Tartrazina / E102)",
          "description":
              "Colorante sintético derivado del alquitrán de hulla vinculado a un aumento de la energía inquieta y brotes de asma. Requiere la advertencia 'puede tener efectos negativos sobre la actividad y la atención de los niños' en la UE.",
          "mechanismOfAction":
              "La tartrazina puede inducir la liberación de histamina y agotar las reservas corporales de zinc y vitamina B6. Dado que la B6 es un cofactor crucial para la síntesis de dopamina, su agotamiento puede provocar desequilibrios neuroquímicos y trastornos del comportamiento.",
          "timingRationale":
              "EVITAR: Se recomienda eliminar de la dieta para el control del estado.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Conocido por desencadenar urticaria y asma en individuos sensibles",
            "Correlación significativa con la impulsividad en niños con Focus",
            "Listado como Tartrazina o E102",
            "Común en encurtidos, mostaza, cereales y bocadillos de colores neón"
          ],
          "tldr":
              "Colorante artificial amarillo vinculado a la energía inquieta y al agotamiento de zinc/B6; evitar para mantener el equilibrio de neurotransmisores."
        }
      },
    },
    {
      "id": "yellow-6",
      "name": "Yellow 6 (Sunset Yellow / E110)",
      "category": "Artificial Color",
      "description":
          "Azo dye shown to increase active energy and potentially contribute to adrenal gland tumors in animal studies.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Mimics the effects of a neuro-excitatory toxin in sensitive individuals, triggering hypersensitivity reactions that present as focus challenges like restlessness and poor concentration.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Should be eliminated from an Focus-friendly diet.",
      "scientificEvidenceRank": 72,
      "studyLinks": {
        "Hyperactivity in 3-year-olds and 8/9-year-olds":
            "https://pubmed.ncbi.nlm.nih.gov/17825405/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Azo dye with high correlation to school-age restless energy",
        "Listed as Sunset Yellow FCF or E110",
        "Common in orange sodas, baked goods, and cheese snacks"
      ],
      "tldr":
          "Orange food dye that increases restless energy; highly recommended to avoid in Focus users.",
      "translations": {
        "it": {
          "name": "Giallo 6 (Giallo Tramonto / E110)",
          "description":
              "Colorante azoico che ha dimostrato di aumentare l'energia attiva e potenzialmente contribuire ai tumori delle ghiandole surrenali in studi su animali.",
          "mechanismOfAction":
              "Imita gli effetti di una tossina neuro-eccitatoria in individui sensibili, scatenando reazioni di ipersensibilità che si presentano come sfide di concentrazione come irrequietezza e scarsa concentrazione.",
          "timingRationale":
              "EVITARE: Dovrebbe essere eliminato da una dieta amica del Focus.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Colorante azoico con alta correlazione con l'irrequietezza in età scolare",
            "Elencato come Giallo Tramonto FCF o E110",
            "Comune in bibite arancioni, prodotti da forno e snack al formaggio"
          ],
          "tldr":
              "Colorante alimentare arancione che aumenta l'energia irrequieta; altamente raccomandato da evitare negli utenti Focus."
        },
        "es": {
          "name": "Amarillo 6 (Amarillo Crepúsculo / E110)",
          "description":
              "Colorante azoico que ha demostrado aumentar la energía activa y potencialmente contribuir a tumores de las glándulas suprarrenales en estudios con animales.",
          "mechanismOfAction":
              "Imita los efectos de una toxina neuroexcitatoria en individuos sensibles, desencadenando reacciones de hipersensibilidad que se presentan como desafíos de concentración como inquietud y falta de concentración.",
          "timingRationale":
              "EVITAR: Debe eliminarse de una dieta amigable con Focus.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Colorante azoico con alta correlación con la inquietud en edad escolar",
            "Listado como Amarillo Ocaso FCF o E110",
            "Común en refrescos de naranja, productos horneados y bocadillos de queso"
          ],
          "tldr":
              "Colorante alimentario naranja que aumenta la energía inquieta; muy recomendable evitar en usuarios de Focus."
        }
      },
    },
    {
      "id": "red-3",
      "name": "Red 3 (Erythrosine / E127)",
      "category": "Artificial Color",
      "description":
          "Synthetic cherry-pink dye associated with thyroid disruption and significant behavioral changes in Focus users. Banned in many countries for food use.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Erythrosine can interfere with iodine metabolism and thyroid function. Thyroid imbalances are closely linked to cognitive dysfunction, anxiety, and restlessness, which can severely exacerbate existing focus challenges.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Consumption is linked to hormonal and behavioral disruption.",
      "scientificEvidenceRank": 70,
      "studyLinks": {
        "Artificial dyes and thyroid function":
            "https://pubmed.ncbi.nlm.nih.gov/24584102/",
        "Behavioral effects of Red 3":
            "https://pubmed.ncbi.nlm.nih.gov/7161718/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Banned by FDA for use in cosmetics/drugs due to cancer risk in rats",
        "Significant impact on behavioral stability in sensitive individuals",
        "Listed as Erythrosine or E127",
        "Often found in maraschino cherries and some baked goods"
      ],
      "tldr":
          "Red dye with thyroid-disrupting potential that worsens Focus restlessness; eliminate from diet.",
      "translations": {
        "it": {
          "name": "Rosso 3 (Eritrosina / E127)",
          "description":
              "Colorante sintetico rosa ciliegia associato a disfunzioni tiroidee e cambiamenti comportamentali significativi negli utenti Focus. Vietato in molti paesi per uso alimentare.",
          "mechanismOfAction":
              "L'eritrosina può interferire con il metabolismo dello iodio e la funzione tiroidea. Gli squilibri tiroidei sono strettamente legati a disfunzioni cognitive, ansia e irrequietezza, che possono esacerbare gravemente le sfide di concentrazione esistenti.",
          "timingRationale":
              "EVITARE: Il consumo è collegato a disturbi ormonali e comportamentali.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Vietato dalla FDA per l'uso in cosmetici/farmaci a causa del rischio di cancro nei ratti",
            "Impatto significativo sulla stabilità comportamentale in individui sensibili",
            "Elencato come Eritrosina o E127",
            "Spesso presente nelle ciliegie al maraschino e in alcuni prodotti da forno"
          ],
          "tldr":
              "Colorante rosso con potenziale di interruzione della tiroide che peggiora l'irrequietezza del Focus; eliminare dalla dieta."
        },
        "es": {
          "name": "Rojo 3 (Eritrosina / E127)",
          "description":
              "Colorante sintético rosa cereza asociado con la alteración de la tiroides y cambios significativos de comportamiento en usuarios de Focus. Prohibido en muchos países para uso alimentario.",
          "mechanismOfAction":
              "La eritrosina puede interferir con el metabolismo del yodo y la función tiroidea. Los desequilibrios tiroideos están estrechamente relacionados con la disfunción cognitiva, la ansiedad y la inquietud, lo que puede exacerbar gravemente los desafíos de concentración existentes.",
          "timingRationale":
              "EVITAR: El consumo está relacionado con la alteración hormonal y conductual.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Prohibido por la FDA para uso en cosméticos/medicamentos debido al riesgo de cáncer en ratas",
            "Impacto significativo en la estabilidad conductual en individuos sensibles",
            "Listado como Eritrosina o E127",
            "A menudo se encuentra en cerezas marasquinas y algunos productos horneados"
          ],
          "tldr":
              "Colorante rojo con potencial de alteración de la tiroides que empeora la inquietud de Focus; eliminar de la dieta."
        }
      },
    },
    {
      "id": "blue-1",
      "name": "Blue 1 (Brilliant Blue / E133)",
      "category": "Artificial Color",
      "description":
          "Petroleum-derived blue dye that can cross the blood-brain barrier. Linked to restless energy and allergic reactions.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Unlike many other dyes, Blue 1 can cross the blood-brain barrier and has been shown to inhibit neuro-signaling in certain contexts. It triggers inflammatory responses that can manifest as increased impulsivity and mood instability.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Should be removed from Focus nutritional plans.",
      "scientificEvidenceRank": 68,
      "studyLinks": {
        "Blue 1 and blood-brain barrier":
            "https://pubmed.ncbi.nlm.nih.gov/15531024/",
        "FDA report on food dyes and behavior":
            "https://www.fda.gov/media/100000/download"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Can cross the blood-brain barrier directly",
        "Associated with allergic reactions and behavioral flares",
        "Listed as Brilliant Blue FCF or E133",
        "Found in blue-colored beverages, candy, and ice cream"
      ],
      "tldr":
          "Blue dye that crosses the blood-brain barrier and serves as a behavioral trigger for many Focus users.",
      "translations": {
        "it": {
          "name": "Blu 1 (Blu Brillante / E133)",
          "description":
              "Colorante blu derivato dal petrolio che può attraversare la barriera emato-encefalica. Collegato a energia irrequieta e reazioni allergiche.",
          "mechanismOfAction":
              "A differenza di molti altri coloranti, il Blu 1 può attraversare la barriera emato-encefalica ed è stato dimostrato che inibisce la neuro-segnalazione in certi contesti. Innesca risposte infiammatorie che possono manifestarsi come maggiore impulsività e instabilità dell'umore.",
          "timingRationale":
              "EVITARE: Dovrebbe essere rimosso dai piani nutrizionali Focus.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Può attraversare direttamente la barriera emato-encefalica",
            "Associato a reazioni allergiche e picchi comportamentali",
            "Elencato come Blu Brillante FCF o E133",
            "Si trova in bevande blu, caramelle e gelati"
          ],
          "tldr":
              "Colorante blu che attraversa la barriera emato-encefalica e funge da fattore scatenante comportamentale per molti utenti Focus."
        },
        "es": {
          "name": "Azul 1 (Azul Brillante / E133)",
          "description":
              "Colorante azul derivado del petróleo que puede cruzar la barrera hematoencefálica. Vinculado a energía inquieta y reacciones alérgicas.",
          "mechanismOfAction":
              "A diferencia de muchos otros colorantes, el Azul 1 puede cruzar la barrera hematoencefálica y se ha demostrado que inhibe la neuroseñalización en ciertos contextos. Desencadena respuestas inflamatorias que pueden manifestarse como aumento de la impulsividad e inestabilidad del estado de ánimo.",
          "timingRationale":
              "EVITAR: Debe eliminarse de los planes nutricionales de Focus.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Puede cruzar directamente la barrera hematoencefálica",
            "Asociado a reacciones alérgicas y picos conductuales",
            "Listado como Azul Brillante FCF o E133",
            "Se encuentra en bebidas azules, caramelos y helados"
          ],
          "tldr":
              "Colorante azul que cruza la barrera hematoencefálica y sirve como desencadenante conductual para muchos usuarios de Focus."
        }
      },
    },
    {
      "id": "blue-2",
      "name": "Blue 2 (Indigo Carmine / E132)",
      "category": "Artificial Color",
      "description":
          "Synthetic color associated with restless energy and potential neurotoxicity in animal studies.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Blue 2 triggers neuro-inflammatory pathways in sensitive individuals, leading to a state of 'hyper-arousal' that directly mirrors Focus restless energy challenges.",
      "detailedBenefits": <String>[],
      "timingRationale": "AVOID: Exclusion from diet is highly recommended.",
      "scientificEvidenceRank": 67,
      "studyLinks": {
        "Indigo Carmine and behavioral toxicity":
            "https://pubmed.ncbi.nlm.nih.gov/6582312/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Linked to brain tumors in some older animal studies with high intake",
        "Consistent trigger for Focus restless energy in standard reports",
        "Listed as Indigo Carmine or E132",
        "Common in candy, beverages, and pet foods"
      ],
      "tldr":
          "Synthetic blue dye associated with behavioral hyper-arousal and restlessness.",
      "translations": {
        "it": {
          "name": "Blu 2 (Indigotina / E132)",
          "description":
              "Colore sintetico associato a energia irrequieta e potenziale neurotossicità in studi su animali.",
          "mechanismOfAction":
              "Il Blu 2 innesca percorsi neuro-infiammatori in individui sensibili, portando a uno stato di 'iper-eccitazione' che rispecchia direttamente le sfide di energia irrequieta del Focus.",
          "timingRationale":
              "EVITARE: L'esclusione dalla dieta è altamente raccomandata.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Collegato a tumori cerebrali in alcuni vecchi studi su animali con alta assunzione",
            "Fattore scatenante costante per l'irrequietezza del Focus nei rapporti standard",
            "Elencato come Indigotina o E132",
            "Comune in caramelle, bevande e alimenti per animali"
          ],
          "tldr":
              "Colorante blu sintetico associato a iper-eccitazione comportamentale e irrequietezza."
        },
        "es": {
          "name": "Azul 2 (Indigotina / E132)",
          "description":
              "Color sintético asociado con energía inquieta y potencial neurotoxicidad en estudios con animales.",
          "mechanismOfAction":
              "El Azul 2 desencadena vías neuroinflamatorias en individuos sensibles, llevando a un estado de 'hiperexcitación' que refleja directamente los desafíos de energía inquieta de Focus.",
          "timingRationale":
              "EVITAR: Se recomienda encarecidamente la exclusión de la dieta.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Vinculado a tumores cerebrales en algunos estudios animales antiguos con alta ingesta",
            "Desencadenante constante de inquietud en informes estándar",
            "Listado como Indigotina o E132",
            "Común en caramelos, bebidas y alimentos para mascotas"
          ],
          "tldr":
              "Colorante azul sintético asociado con hiperexcitación conductual e inquietud."
        }
      },
    },
    {
      "id": "carmoisine",
      "name": "Carmoisine (Azorubine / E122)",
      "category": "Artificial Color",
      "description":
          "One of the primary 'Southampton Six' azo dyes with established links to restless energy in school-age children.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Similar to other azo dyes, it triggers histamine release which acts as a central nervous system irritant in Focus users, causing decreased focus and increased physical motion.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Removing from diet reduces cumulative behavioral load.",
      "scientificEvidenceRank": 71,
      "studyLinks": {
        "Southampton Study (Lancet)":
            "https://pubmed.ncbi.nlm.nih.gov/17825405/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "One of the 'Southampton Six' requiring mandatory EU warnings",
        "Strongly associated with inattention and restless energy",
        "Listed as Azorubine or E122",
        "Common in jams, red desserts, and jellies"
      ],
      "tldr":
          "Azo red dye from the Southampton study with proven restless energy links.",
      "translations": {
        "it": {
          "name": "Carmoisina (Azorubina / E122)",
          "description":
              "Uno dei 'Southampton Six', coloranti azoici con legami stabiliti all'energia irrequieta nei bambini in età scolare.",
          "mechanismOfAction":
              "Simile ad altri coloranti azoici, innesca il rilascio di istamina che agisce come un irritante del sistema nervoso centrale negli utenti Focus, causando diminuzione della concentrazione e aumento del movimento fisico.",
          "timingRationale":
              "EVITARE: La rimozione dalla dieta riduce il carico comportamentale cumulativo.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Colorante azoico vietato negli USA e in altri paesi",
            "Collegato a iperattività e mancanza di concentrazione negli utenti Focus",
            "Elencato come Carmoisina o E122",
            "Si trova in marmellate, dolci e bevande analcoliche"
          ],
          "tldr":
              "Colorante rosso azoico dello studio di Southampton con comprovati legami con l'energia irrequieta."
        },
        "es": {
          "name": "Carmoisina (Azorrubina / E122)",
          "description":
              "Uno de los principales tintes azoicos 'Southampton Six' con vínculos establecidos con la energía inquieta en niños en edad escolar.",
          "mechanismOfAction":
              "Al igual que otros tintes azoicos, desencadena la liberación de histamina que actúa como un irritante del sistema nervioso central en los usuarios de Focus, causando una disminución de la concentración y un aumento del movimiento físico.",
          "timingRationale":
              "EVITAR: Eliminar de la dieta reduce la carga conductual acumulada.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Colorante azoico prohibido en EE. UU. y otros países",
            "Relacionado con hiperactividad y falta de concentración en usuarios de Focus",
            "Listado como Carmoisina o E122",
            "Se encuentra en mermeladas, dulces y refrescos"
          ],
          "tldr":
              "Tinte rojo azoico del estudio de Southampton con vínculos comprobados con la energía inquieta."
        }
      },
    },
    {
      "id": "quinoline-yellow",
      "name": "Quinoline Yellow (E104)",
      "category": "Artificial Color",
      "description":
          "Synthetic yellow dye that significantly increased Global Hyperactivity scores in large-scale standard trials.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Causes central nervous system excitation and can induce allergic-like responses that disrupt prefrontal cortex function (the area responsible for executive control).",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Elimination from diet reduces behavioral interference.",
      "scientificEvidenceRank": 69,
      "studyLinks": {
        "EFSA reassessment of Quinoline Yellow":
            "https://www.efsa.europa.eu/en/efsajournal/pub/1329"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "One of the 'Southampton Six' behavioral triggers",
        "Frequently combined with sodium benzoate (amplifies effect)",
        "Listed as Quinoline Yellow or E104",
        "Common in smoked fish and some citrus-flavored drinks"
      ],
      "tldr":
          "Yellow dye that disrupts executive function and increases restless energy scores.",
      "translations": {
        "it": {
          "name": "Giallo di Chinolina (E104)",
          "description":
              "Colorante giallo sintetico che ha aumentato significativamente i punteggi globali di iperattività in studi standard su larga scala.",
          "mechanismOfAction":
              "Causa eccitazione del sistema nervoso centrale e può indurre risposte simil-allergiche che disturbano la funzione della corteccia prefrontale (l'area responsabile del controllo esecutivo).",
          "timingRationale":
              "EVITARE: L'eliminazione dalla dieta riduce l'interferenza comportamentale.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Associato a iperattività e orticaria in individui sensibili",
            "Richiede avvertenza UE per gli effetti sull'attenzione dei bambini",
            "Elencato come Giallo di Chinolina o E104",
            "Comune in gelati, bibite e prodotti per l'igiene"
          ],
          "tldr":
              "Colorante giallo che disturba la funzione esecutiva e aumenta i punteggi di energia irrequieta."
        },
        "es": {
          "name": "Amarillo de Quinolina (E104)",
          "description":
              "Colorante amarillo sintético que aumentó significativamente las puntuaciones de hiperactividad global en ensayos estándar a gran escala.",
          "mechanismOfAction":
              "Causa excitación del sistema nervioso central y puede inducir respuestas similares a las alérgicas que interrumpen la función de la corteza prefrontal (el área responsable del control ejecutivo).",
          "timingRationale":
              "EVITAR: La eliminación de la dieta reduce la interferencia conductual.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Asociado con hiperactividad y urticaria en personas sensibles",
            "Requiere advertencia de la UE por efectos en la atención infantil",
            "Listado como Amarillo de Quinolina o E104",
            "Común en helados, refrescos y productos de higiene"
          ],
          "tldr":
              "Colorante amarillo que interrumpe la función ejecutiva y aumenta las puntuaciones de energía inquieta."
        }
      },
    },
    {
      "id": "allura-red",
      "name": "Allura Red AC (E129)",
      "category": "Artificial Color",
      "description":
          "The most common red food dye (Red 40 in USA), proven to increase restless energy in school-age children across international studies.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Triggers the release of pro-inflammatory cytokines and histamine in the brain, leading to a state of cognitive arousal that manifests as impulsivity and poor concentration.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Highly recommended for elimination in Focus users.",
      "scientificEvidenceRank": 74,
      "studyLinks": {
        "Meta-analysis of food dyes and behavior":
            "https://pubmed.ncbi.nlm.nih.gov/22331014/",
        "Southampton Study Results": "https://pubmed.ncbi.nlm.nih.gov/17825405/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "The single most prevalent behavioral trigger dye in the Western diet",
        "Often hidden in white or non-red foods as a 'color enhancer'",
        "Listed as Allura Red AC, Red 40, or E129",
        "Ubiquitous in soft drinks, candy, and colorful cereals"
      ],
      "tldr":
          "The most common behavioral trigger dye; avoid to reduce impulsivity and Focus flares.",
      "translations": {
        "it": {
          "name": "Rosso Allura AC (E129)",
          "description":
              "Il colorante alimentare rosso più comune (Red 40 negli USA), dimostrato di aumentare l'energia irrequieta nei bambini in età scolare in studi internazionali.",
          "mechanismOfAction":
              "Innesca il rilascio di citochine pro-infiammatorie e istamina nel cervello, portando a uno stato di eccitazione cognitiva che si manifesta come impulsività e scarsa concentrazione.",
          "timingRationale":
              "EVITARE: Altamente raccomandato per l'eliminazione negli utenti Focus.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Il colorante scatenante più comune nella dieta occidentale",
            "Innesca il rilascio di istamina e citochine infiammatorie",
            "Elencato come Rosso Allura AC, Rosso 40 o E129",
            "Onnipresente in bibite, caramelle e cereali colorati"
          ],
          "tldr":
              "Il colorante scatenante comportamentale più comune; evitare per ridurre l'impulsività e le riacutizzazioni del Focus."
        },
        "es": {
          "name": "Rojo Allura AC (E129)",
          "description":
              "El tinte rojo para alimentos más común (Red 40 en EE. UU.), probado que aumenta la energía inquieta en niños en edad escolar en estudios internacionales.",
          "mechanismOfAction":
              "Desencadena la liberación de citocinas proinflamatorias e histamina en el cerebro, lo que lleva a un estado de excitación cognitiva que se manifiesta como impulsividad y falta de concentración.",
          "timingRationale":
              "EVITAR: Muy recomendado para su eliminación en usuarios de Focus.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "El tinte desencadenante más común en la dieta occidental",
            "Desencadena la liberación de histamina y citocinas inflamatorias",
            "Listado como Rojo Allura AC, Rojo 40 o E129",
            "Ubicuo en refrescos, caramelos y cereales coloridos"
          ],
          "tldr":
              "El tinte desencadenante conductual más común; evitar para reducir la impulsividad y los brotes de Focus."
        }
      },
    },
    {
      "id": "aspartame",
      "name": "Aspartame (E951)",
      "category": "Artificial Sweetener",
      "description":
          "Synthetic sweetener that may interfere with amino acid balance and neurotransmitter synthesis in sensitive individuals.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Aspartame contains phenylalanine, which can compete with other large neutral amino acids (like tyrosine) for transport across the blood-brain barrier. High levels may interfere with the synthesis of dopamine and serotonin, potentially worsening mood and focus in Focus individuals.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: May cause neurochemical instability and brain fog.",
      "scientificEvidenceRank": 58,
      "studyLinks": {
        "Aspartame and neurobehavioral effects":
            "https://pubmed.ncbi.nlm.nih.gov/28198205/",
        "Phenylalanine and large neutral amino acids":
            "https://pubmed.ncbi.nlm.nih.gov/17684524/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "May trigger migraines or brain fog in sensitive individuals",
        "Interferes with the amino acid balance used for dopamine synthesis",
        "Listed as Aspartame or E951",
        "Found in diet sodas, sugar-free gum, and low-calorie snacks"
      ],
      "tldr":
          "Artificial sweetener that can disrupt neurotransmitter precursors; avoid to maintain cognitive clarity.",
      "translations": {
        "it": {
          "name": "Aspartame (E951)",
          "description":
              "Dolcificante sintetico che può interferire con l'equilibrio degli aminoacidi e la sintesi dei neurotrasmettitori in individui sensibili.",
          "mechanismOfAction":
              "L'aspartame contiene fenilalanina, che può competere con altri grandi aminoacidi neutri (come la tirosina) per il trasporto attraverso la barriera emato-encefalica. Alti livelli possono interferire con la sintesi di dopamina e serotonina, peggiorando potenzialmente l'umore e la concentrazione negli individui Focus.",
          "timingRationale":
              "EVITARE: Può causare instabilità neurochimica e nebbia cerebrale.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Contiene fenilalanina (pericolo per chi soffre di PKU)",
            "Può competere con la tirosina per il trasporto cerebrale",
            "Potenziale interruzione della sintesi di dopamina e serotonina",
            "Associato a mal di testa e vertigini in individui sensibili"
          ],
          "tldr":
              "Dolcificante artificiale che può disturbare i precursori dei neurotrasmettitori; evitare per mantenere la chiarezza cognitiva."
        },
        "es": {
          "name": "Aspartamo (E951)",
          "description":
              "Edulcorante sintético que puede interferir con el equilibrio de aminoácidos y la síntesis de neurotransmisores en personas sensibles.",
          "mechanismOfAction":
              "El aspartamo contiene fenilalanina, que puede competir con otros aminoácidos neutros grandes (como la tirosina) por el transporte a través de la barrera hematoencefálica. Los niveles altos pueden interferir con la síntesis de dopamina y serotonina, empeorando potencialmente el estado de ánimo y la concentración en personas con Focus.",
          "timingRationale":
              "EVITAR: Puede causar inestabilidad neuroquímica y niebla cerebral.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Contiene fenilalanina (peligro para PKU)",
            "Puede competir con la tirosina por el transporte cerebral",
            "Posible interrupción de la síntesis de dopamina y serotonina",
            "Asociado con dolores de cabeza y mareos en personas sensibles"
          ],
          "tldr":
              "Edulcorante artificial que puede alterar los precursores de neurotransmisores; evitar para mantener la claridad cognitiva."
        }
      },
    },
    {
      "id": "sucralose",
      "name": "Sucralose",
      "category": "Artificial Sweetener",
      "description":
          "Artificial sweetener that may disrupt the gut microbiome and potentially trigger neuro-inflammatory responses.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Sucralose has been shown to significantly alter the gut microbiome and may increase intestinal permeability. Since the gut-brain axis is critical for Focus management, chronic gut disruption can lead to systemic inflammation and indirect behavioral worsening.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Long-term gut health is foundational for focused performance.",
      "scientificEvidenceRank": 55,
      "studyLinks": {
        "Sucralose and the gut microbiome":
            "https://pubmed.ncbi.nlm.nih.gov/30138244/",
        "Artificial sweeteners and systemic inflammation":
            "https://pubmed.ncbi.nlm.nih.gov/31201202/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "May cause digestive upset or bloating in some individuals",
        "Disrupts beneficial bacteria needed for neurotransmitter health",
        "Frequently found in 'Sugar-Free' processed products",
        "Can trigger anecdotal reports of worsening brain fog"
      ],
      "tldr":
          "Artificial sweetener that may disrupt the gut-brain axis; avoid for optimal digestive and cognitive health.",
      "translations": {
        "it": {
          "name": "Sucralosio",
          "description":
              "Dolcificante artificiale che può disturbare il microbioma intestinale e potenzialmente innescare risposte neuro-infiammatorie.",
          "mechanismOfAction":
              "È stato dimostrato che il sucralosio altera significativamente il microbioma intestinale e può aumentare la permeabilità intestinale. Poiché l'asse intestino-cervello è critico per la gestione del Focus, la perturbazione cronica dell'intestino può portare a infiammazione sistemica e peggioramento comportamentale indiretto.",
          "timingRationale":
              "EVITARE: La salute intestinale a lungo termine è fondamentale per prestazioni focalizzate.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Può alterare il microbioma intestinale (asse intestino-cervello)",
            "Potenziale impatto sulla sensibilità all'insulina",
            "Si trova spesso in integratori Focus 'senza zucchero'",
            "Effetti a lungo termine sulla funzione cognitiva ancora in fase di studio"
          ],
          "tldr":
              "Dolcificante artificiale che può disturbare l'asse intestino-cervello; evitare per una salute digestiva e cognitiva ottimale."
        },
        "es": {
          "name": "Sucralosa",
          "description":
              "Edulcorante artificial que puede alterar el microbioma intestinal y potencialmente desencadenar respuestas neuroinflamatorias.",
          "mechanismOfAction":
              "Se ha demostrado que la sucralosa altera significativamente el microbioma intestinal y puede aumentar la permeabilidad intestinal. Dado que el eje intestino-cerebro es fundamental para el control de Focus, la alteración intestinal crónica puede provocar inflamación sistémica y un empeoramiento indirecto del comportamiento.",
          "timingRationale":
              "EVITAR: La salud intestinal a largo plazo es fundamental para un rendimiento concentrado.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Puede alterar el microbioma intestinal (eje intestino-cerebro)",
            "Impacto potencial en la sensibilidad a la insulina",
            "A menudo se encuentra en suplementos 'sin azúcar'",
            "Efectos a largo plazo en la función cognitiva aún en estudio"
          ],
          "tldr":
              "Edulcorante artificial que puede alterar el eje intestino-cerebro; evitar para una salud digestiva y cognitiva óptima."
        }
      },
    },
    {
      "id": "msg",
      "name": "Monosodium Glutamate (MSG / E621)",
      "category": "Flavor Enhancer",
      "description":
          "Flavor enhancer that acts as an excitotoxin in sensitive individuals, potentially overstimulating neuronal pathways.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "MSG provides highly concentrated glutamate, the brain's primary excitatory neurotransmitter. In sensitive Focus individuals, this can lead to neuronal 'hyperexcitability,' manifesting as increased restlessness, anxiety, and difficulty controlling motor impulses.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: May cause acute behavioral flares in sensitive people.",
      "scientificEvidenceRank": 52,
      "studyLinks": {
        "MSG and behavioral hyperactivity":
            "https://pubmed.ncbi.nlm.nih.gov/15531024/",
        "Excitotoxicity in sensitive populations":
            "https://pubmed.ncbi.nlm.nih.gov/22331014/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Excitotoxin that can trigger 'brain jitters' and headaches",
        "Significantly exacerbates restlessness in susceptible individuals",
        "Listed as MSG, Monosodium Glutamate, or E621",
        "Found in fast food, many chips, and savory processed snacks"
      ],
      "tldr":
          "Flavor enhancer that can overstimulate the brain and worsen motor restlessness; eliminate from diet.",
      "translations": {
        "it": {
          "name": "Glutammato Monosodico (MSG / E621)",
          "description":
              "Esaltatore di sapidità che agisce come eccitotossina in individui sensibili, potenzialmente sovrastimolando i percorsi neuronali.",
          "mechanismOfAction":
              "L'MSG fornisce glutammato altamente concentrato, il principale neurotrasmettitore eccitatorio del cervello. Negli individui Focus sensibili, questo può portare a 'ipereccitabilità' neuronale, manifestandosi come aumento dell'irrequietezza, ansia e difficoltà nel controllo degli impulsi motori.",
          "timingRationale":
              "EVITARE: Può causare riacutizzazioni comportamentali acute nelle persone sensibili.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Eccitotossina che può sovrastimolare i neuroni",
            "Può causare mal di testa e annebbiamento mentale in individui sensibili",
            "Altera l'equilibrio glutammato/GABA",
            "Nascosto sotto nomi come 'estratto di lievito' o 'proteine idrolizzate'"
          ],
          "tldr":
              "Esaltatore di sapidità che può sovrastimolare il cervello e peggiorare l'irrequietezza motoria; eliminare dalla dieta."
        },
        "es": {
          "name": "Glutamato Monosódico (GMS / E621)",
          "description":
              "Potenciador del sabor que actúa como una excitotoxina en personas sensibles, sobreestimulando potencialmente las vías neuronales.",
          "mechanismOfAction":
              "El GMS proporciona glutamato altamente concentrado, el principal neurotransmisor excitatorio del cerebro. En personas sensibles con Focus, esto puede conducir a una 'hiperexcitabilidad' neuronal, que se manifiesta como un aumento de la inquietud, ansiedad y dificultad para controlar los impulsos motores.",
          "timingRationale":
              "EVITAR: Puede causar brotes de comportamiento agudos en personas sensibles.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Excitotoxina que puede sobreestimular las neuronas",
            "Puede causar dolores de cabeza y niebla mental en personas sensibles",
            "Altera el equilibrio glutamato/GABA",
            "Oculto bajo nombres como 'extracto de levadura' o 'proteína hidrolizada'"
          ],
          "tldr":
              "Potenciador del sabor que puede sobreestimular el cerebro y empeorar la inquietud motora; eliminar de la dieta."
        }
      },
    },
    {
      "id": "bht",
      "name": "Butylated Hydroxytoluene (BHT / E321)",
      "category": "Preservative",
      "description":
          "Synthetic preservative linked to oxidative stress and potential behavioral disruption in animal studies.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "BHT can induce oxidative stress markers in the brain and has been linked to behavioral toxicity at high levels. It may interfere with the neuroprotective effects of antioxidants and lipids like omega-3.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Preservative with recognized neuro-inflammatory potential.",
      "scientificEvidenceRank": 60,
      "studyLinks": {
        "BHT and neuro-inflammatory markers":
            "https://pubmed.ncbi.nlm.nih.gov/15531024/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Synthetic preservative with high oxidative potential",
        "Linked to behavioral toxicity in sensitive animal models",
        "Check labels for BHT or E321 in dry goods",
        "Common in cereals, snack packaging, and chewing gum"
      ],
      "tldr":
          "Preservative with potential neurotoxic effects; avoid for overall cognitive maintenance.",
      "translations": {
        "it": {
          "name": "Butilidrossitoluene (BHT / E321)",
          "description":
              "Conservante sintetico collegato a stress ossidativo e potenziale disturbo comportamentale in studi su animali.",
          "mechanismOfAction":
              "Il BHT può indurre marcatori di stress ossidativo nel cervello ed è stato collegato a tossicità comportamentale ad alti livelli. Può interferire con gli effetti neuroprotettivi degli antiossidanti e dei lipidi come gli omega-3.",
          "timingRationale":
              "EVITARE: Conservante con riconosciuto potenziale neuro-infiammatorio.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Conservante sintetico con alto potenziale ossidativo",
            "Collegato alla tossicità comportamentale in modelli animali sensibili",
            "Controllare le etichette per BHT o E321 nei prodotti secchi",
            "Comune in cereali, confezioni di snack e chewing gum"
          ],
          "tldr":
              "Conservante con potenziali effetti neurotossici; evitare per il mantenimento cognitivo generale."
        },
        "es": {
          "name": "Butilhidroxitolueno (BHT / E321)",
          "description":
              "Conservante sintético vinculado al estrés oxidativo y la posible alteración del comportamiento en estudios con animales.",
          "mechanismOfAction":
              "El BHT puede inducir marcadores de estrés oxidativo en el cerebro y se ha relacionado con la toxicidad conductual en niveles altos. Puede interferir con los efectos neuroprotectores de los antioxidantes y lípidos como el omega-3.",
          "timingRationale":
              "EVITAR: Conservante con reconocido potencial neuroinflamatorio.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Conservante sintético con alto potencial oxidativo",
            "Vinculado a la toxicidad conductual en modelos animales sensibles",
            "Revise las etiquetas para BHT o E321 en productos secos",
            "Común en cereales, envases de snacks y chicles"
          ],
          "tldr":
              "Conservante con posibles efectos neurotóxicos; evitar para el mantenimiento cognitivo general."
        }
      },
    },
    {
      "id": "potassium-benzoate",
      "name": "Potassium Benzoate (E212)",
      "category": "Preservative",
      "description":
          "Preservative similar to sodium benzoate that amplifies hyperactivity, especially when paired with dyes.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Like sodium benzoate, it can increase motor hyperactivity and may contribute to systemic inflammation and mitochondrial stress, particularly when consumed with synthetic dyes.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Consumption is linked to behavioral disruption.",
      "scientificEvidenceRank": 66,
      "studyLinks": {
        "Sodium benzoate and behavior (Southampton)":
            "https://pubmed.ncbi.nlm.nih.gov/17825405/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Shares hyperactive-inducing potential with sodium benzoate",
        "Most problematic when paired with synthetic food dyes",
        "Listed as Potassium Benzoate or E212",
        "Common in soft drinks, fruit juices, and dressings"
      ],
      "tldr":
          "Preservative that amplifies hyperactivity effects; eliminate from diet to reduce restlessness.",
      "translations": {
        "it": {
          "name": "Benzoato di Potassio (E212)",
          "description":
              "Conservante simile al benzoato di sodio che amplifica l'iperattività, specialmente se accoppiato con coloranti.",
          "mechanismOfAction":
              "Come il benzoato di sodio, può aumentare l'iperattività motoria e può contribuire all'infiammazione sistemica e allo stress mitocondriale, in particolare se consumato con coloranti sintetici.",
          "timingRationale":
              "EVITARE: Il consumo è collegato a disturbi comportamentali.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare dalla dieta",
          "dosageWarnings": [
            "Può formare benzene (un cancerogeno) se combinato con la Vitamina C",
            "Associato a iperattività e irrequietezza in alcuni studi sui bambini",
            "Comune nelle bibite gassate e nei succhi confezionati",
            "Elencato come Benzoato di Potassio o E212"
          ],
          "tldr":
              "Conservante che amplifica gli effetti dell'iperattività; eliminare dalla dieta per ridurre l'irrequietezza."
        },
        "es": {
          "name": "Benzoato de Potasio (E212)",
          "description":
              "Conservante similar al benzoato de sodio que amplifica la hiperactividad, especialmente cuando se combina con colorantes.",
          "mechanismOfAction":
              "Al igual que el benzoato de sodio, puede aumentar la hiperactividad motora y puede contribuir a la inflamación sistémica y al estrés mitocondrial, particularmente cuando se consume con colorantes sintéticos.",
          "timingRationale":
              "EVITAR: El consumo está relacionado con la alteración del comportamiento.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar de la dieta",
          "dosageWarnings": [
            "Puede formar benceno (un carcinógeno) cuando se combina con Vitamina C",
            "Asociado con hiperactividad e inquietud en estudios infantiles",
            "Común en refrescos y jugos envasados",
            "Listado como Benzoato de Potasio o E212"
          ],
          "tldr":
              "Conservante que amplifica los efectos de la hiperactividad; eliminar de la dieta para reducir la inquietud."
        }
      },
    },
    {
      "id": "refined-sugar",
      "name": "Refined Sugar (High Intake)",
      "category": "Dietary Factor",
      "description":
          "Chronic excessive intake of refined sugars that destabilizes blood glucose and downregulates dopamine signaling.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Frequent intake of refined sugar causes rapid glucose spikes followed by insulin-driven crashes. This glycemic instability leads to dopamine receptor downregulation over time and causes acute brain fog, irritability, and attention deficits during sugar 'crashes.'",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Glycemic stability is critical for Focus management.",
      "scientificEvidenceRank": 63,
      "studyLinks": {
        "Refined sugar and Focus behaviors":
            "https://pubmed.ncbi.nlm.nih.gov/21129940/",
        "Dopamine receptor downregulation":
            "https://pubmed.ncbi.nlm.nih.gov/16507461/"
      },
      "dosageByWeight": {
        "40-60": "0g (AVOID)",
        "60-80": "0g (AVOID)",
        "80-100": "0g (AVOID)",
        "100-120": "0g (AVOID)"
      },
      "dosageFrequency": "Eliminate processed sugars; use low-glycemic foods",
      "dosageWarnings": [
        "Causes rapid spikes and subsequent brain fog crashes",
        "Long-term excess can reduce the density of dopamine receptors",
        "Check for 'hidden' sugars in savory processed foods",
        "Directly worsens hyperactivity and mood volatility"
      ],
      "tldr":
          "Sugar destabilizes dopamine signaling and causes focus-killing crashes; eliminate to maintain steady attention.",
      "translations": {
        "it": {
          "name": "Zucchero Raffinato (Alto Consumo)",
          "description":
              "Assunzione eccessiva cronica di zuccheri raffinati che destabilizza il glucosio nel sangue e riduce la segnalazione della dopamina.",
          "mechanismOfAction":
              "L'assunzione frequente di zucchero raffinato provoca rapidi picchi di glucosio seguiti da crolli guidati dall'insulina. Questa instabilità glicemica porta alla down-regulation dei recettori della dopamina nel tempo e causa nebbia cerebrale acuta, irritabilità e deficit di attenzione durante i 'crolli' di zucchero.",
          "timingRationale":
              "EVITARE: La stabilità glicemica è fondamentale per la gestione del Focus.",
          "detailedBenefits": [],
          "dosageFrequency": "Ridurre drasticamente o eliminare",
          "dosageWarnings": [
            "Causa picchi di glucosio seguiti da cali che rovinano il focus",
            "Alimenta l'infiammazione sistemica",
            "Può peggiorare l'iperattività e la disregolazione emotiva",
            "Crea dipendenza e altera i circuiti della ricompensa della dopamina"
          ],
          "tldr":
              "Lo zucchero destabilizza la segnalazione della dopamina e causa crolli che uccidono la concentrazione; eliminare per mantenere un'attenzione costante."
        },
        "es": {
          "name": "Azúcar Refinado (Alto Consumo)",
          "description":
              "Ingesta excesiva crónica de azúcares refinados que desestabiliza la glucosa en sangre y regula a la baja la señalización de dopamina.",
          "mechanismOfAction":
              "La ingesta frecuente de azúcar refinada provoca picos rápidos de glucosa seguidos de caídas impulsadas por la insulina. Esta inestabilidad glucémica conduce a la regulación a la baja de los receptores de dopamina con el tiempo y causa niebla cerebral aguda, irritabilidad y déficit de atención durante las 'caídas' de azúcar.",
          "timingRationale":
              "EVITAR: La estabilidad glucémica es fundamental para el control de Focus.",
          "detailedBenefits": [],
          "dosageFrequency": "Reducir drásticamente o eliminar",
          "dosageWarnings": [
            "Causa picos de glucosa seguidos de caídas que arruinan el enfoque",
            "Alimenta la inflamación sistémica",
            "Puede empeorar la hiperactividad y la desregulación emocional",
            "Crea adicción y altera los circuitos de recompensa de la dopamina"
          ],
          "tldr":
              "El azúcar desestabiliza la señalización de la dopamina y provoca caídas que acaban con la concentración; eliminar para mantener una atención constante."
        }
      },
    },
    {
      "id": "trans-fats",
      "name": "Trans Fats (Partially Hydrogenated Oils)",
      "category": "Dietary Fat",
      "description":
          "Harmful synthetic fats that incorporate into brain membranes and interfere with essential fatty acid function.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Trans fats can physically incorporate into neuronal cell membranes, reducing their fluidity. This interference blunts the function of critical proteins like the dopamine transporter and neurotransmitter receptors, directly impairing cognitive processing and signal transduction.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Interferes with the foundation of neuronal signaling.",
      "scientificEvidenceRank": 76,
      "studyLinks": {
        "Trans fats and neuronal membrane fluidity":
            "https://pubmed.ncbi.nlm.nih.gov/21129940/"
      },
      "dosageByWeight": {
        "40-60": "0g (AVOID)",
        "60-80": "0g (AVOID)",
        "80-100": "0g (AVOID)",
        "100-120": "0g (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Directly interferes with the neuroprotective benefits of Omega-3",
        "Pro-inflammatory and disrupts neuronal membrane integrity",
        "Listed as 'partially hydrogenated oils' on many labels",
        "Found in fried foods, some margarines, and processed baked goods"
      ],
      "tldr":
          "Synthetic fats that harden brain cell membranes and block dopamine signaling; avoid completely.",
      "translations": {
        "it": {
          "name": "Grassi Trans (Oli Parzialmente Idrogenati)",
          "description":
              "Grassi sintetici dannosi che si incorporano nelle membrane cerebrali e interferiscono con la funzione degli acidi grassi essenziali.",
          "mechanismOfAction":
              "I grassi trans possono incorporarsi fisicamente nelle membrane delle cellule neuronali, riducendo la loro fluidità. Questa interferenza attenua la funzione di proteine critiche come il trasportatore della dopamina e i recettori dei neurotrasmettitori, compromettendo direttamente l'elaborazione cognitiva e la trasduzione del segnale.",
          "timingRationale":
              "EVITARE: Interferisce con le fondamenta della segnalazione neuronale.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminare completamente",
          "dosageWarnings": [
            "Interferisce direttamente con i benefici neuroprotettivi degli Omega-3",
            "Pro-infiammatorio e distrugge l'integrità della membrana neuronale",
            "Elencato come 'oli parzialmente idrogenati' su molte etichette",
            "Si trova in cibi fritti, margarine e prodotti da forno processati"
          ],
          "tldr":
              "Grassi sintetici che induriscono le membrane delle cellule cerebrali e bloccano la segnalazione della dopamina; evitare completamente."
        },
        "es": {
          "name": "Grasas Trans (Aceites Parcialmente Hidrogenados)",
          "description":
              "Grasas sintéticas dañinas que se incorporan a las membranas cerebrales e interfieren con la función de los ácidos grasos esenciales.",
          "mechanismOfAction":
              "Las grasas trans pueden incorporarse físicamente a las membranas de las células neuronales, reduciendo su fluidez. Esta interferencia atenúa la función de proteínas críticas como el transportador de dopamina y los receptores de neurotransmisores, lo que afecta directamente el procesamiento cognitivo y la transducción de señales.",
          "timingRationale":
              "EVITAR: Interfiere con la base de la señalización neuronal.",
          "detailedBenefits": [],
          "dosageFrequency": "Eliminar completamente",
          "dosageWarnings": [
            "Interfiere directamente con los beneficios neuroprotectores del Omega-3",
            "Proinflamatorio y altera la integridad de la membrana neuronal",
            "Listado como 'aceites parcialmente hidrogenados' en muchas etiquetas",
            "Se encuentra en alimentos fritos, margarinas y productos horneados procesados"
          ],
          "tldr":
              "Grasas sintéticas que endurecen las membranas de las células cerebrales y bloquean la señalización de la dopamina; evitar por completo."
        }
      },
    },
    {
      "id": "alcohol",
      "name": "Alcohol",
      "category": "Substance",
      "description":
          "CNS depressant that disrupts dopamine regulation, depletes essential brain nutrients, and ruins sleep quality.",
      "status": "avoid",
      "focusLevel": 1,
      "mechanismOfAction":
          "Alcohol disrupts the fine-tuning of the dopamine system and causes rebound anxiety. It significantly impairs the prefrontal cortex (executive function) and depletes B-vitamins and magnesium, which are essential cofactors for neurotransmitter synthesis. It also ruins REM sleep architecture, vital for cognitive recovery.",
      "detailedBenefits": <String>[],
      "timingRationale":
          "AVOID: Consumption disrupts neurodevelopment and cognitive recovery.",
      "scientificEvidenceRank": 80,
      "studyLinks": {
        "Alcohol and dopamine dysregulation":
            "https://pubmed.ncbi.nlm.nih.gov/28198205/"
      },
      "dosageByWeight": {
        "40-60": "0mg (AVOID)",
        "60-80": "0mg (AVOID)",
        "80-100": "0mg (AVOID)",
        "100-120": "0mg (AVOID)"
      },
      "dosageFrequency": "Eliminate from diet",
      "dosageWarnings": [
        "Depletes B-vitamins and Magnesium critical for Focus focus",
        "Severely disrupts sleep architecture (no recovery focus)",
        "May significantly interact with Focus routine items",
        "Reduces executive function for 24-48 hours after consumption"
      ],
      "tldr":
          "Depletes vitamins and ruins sleep/dopamine balance; check liquid supplements for alcohol content.",
      "translations": {
        "it": {
          "name": "Alcol",
          "description":
              "Depressivo del SNC che disturba la regolazione della dopamina, esaurisce i nutrienti cerebrali essenziali e rovina la qualità del sonno.",
          "mechanismOfAction":
              "L'alcol disturba la regolazione fine del sistema dopaminergico e causa ansia da rimbalzo. Compromette significativamente la corteccia prefrontale (funzione esecutiva) ed esaurisce le vitamine B e il magnesio, che sono cofattori essenziali per la sintesi dei neurotrasmettitori. Rovina anche l'architettura del sonno REM, vitale per il recupero cognitivo.",
          "timingRationale":
              "EVITARE: Il consumo disturba lo sviluppo neurologico e il recupero cognitivo.",
          "detailedBenefits": [],
          "dosageFrequency": "Evitare o limitare rigorosamente",
          "dosageWarnings": [
            "Esaurisce le vitamine B e il magnesio, critici per il focus",
            "Danneggia gravemente l'architettura del sonno (niente recupero)",
            "Può interagire significativamente con i componenti della routine Focus",
            "Riduce la funzione esecutiva per 24-48 ore dopo il consumo"
          ],
          "tldr":
              "Esaurisce le vitamine e rovina l'equilibrio sonno/dopamina; controllare gli integratori liquidi per il contenuto di alcol."
        },
        "es": {
          "name": "Alcohol",
          "description":
              "Depresor del SNC que altera la regulación de la dopamina, agota los nutrientes cerebrales esenciales y arruina la calidad del sueño.",
          "mechanismOfAction":
              "El alcohol altera el ajuste fino del sistema de dopamina y causa ansiedad de rebote. Perjudica significativamente la corteza prefrontal (función ejecutiva) y agota las vitaminas B y el magnesio, que son cofactores esenciales para la síntesis de neurotransmisores. También arruina la arquitectura del sueño REM, vital para la recuperación cognitiva.",
          "timingRationale":
              "EVITAR: El consumo altera el neurodesarrollo y la recuperación cognitiva.",
          "detailedBenefits": [],
          "dosageFrequency": "Evitar o limitar estrictamente",
          "dosageWarnings": [
            "Agota las vitaminas B y el magnesio, críticos para el enfoque",
            "Altera gravemente la arquitectura del sueño (sin recuperación)",
            "Puede interactuar significativamente con los elementos de la rutina Focus",
            "Reduce la función ejecutiva durante 24-48 horas después del consumo"
          ],
          "tldr":
              "Agota las vitaminas y arruina el equilibrio sueño/dopamina; verifique el contenido de alcohol en los suplementos líquidos."
        }
      },
    }
  ];

  Future<void> seedSupplements() async {
    try {
      final supplements = defaultSupplements;
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
      UserCredential credential;
      try {
        credential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        // User likely already exists, sign in instead
        credential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      final uid = credential.user!.uid;
      // Create/Update user document in Firestore
      await _firestore.collection('users').doc(uid).set({
        'id': uid,
        'email': email,
        'displayName': 'Test User',
        'createdAt': DateTime.now().toIso8601String(),
        'hasCompletedOnboarding': true,
        'goals': <String>['Better Sleep', 'Mental Clarity'],
        'unlockedAchievements': <String>[],
      });
      AppLogger.i('Test user configured successfully: $email');
    } catch (e) {
      AppLogger.e('Failed to configure test user', e);
    }
  }
}
