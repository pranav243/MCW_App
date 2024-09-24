import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String studyID = '';
  int age = 0;
  String sex = 'Male';
  int durationOfSymptoms = 0;
  bool priorSurgery = false;
  String dateOfSurgery = '';

  // Comorbidities
  Map<String, bool> comorbidities = {
    'Chiari malformation': false,
    'Multiple sclerosis': false,
    'Peripheral neuropathy': false,
    'Diabetes': false,
    'Stroke': false,
    'B12 deficiency': false,
    'Prior lumbar spine surgery': false,
    'Arthritis of the hand': false,
    'Prior hand surgery': false,
    'Other neurological condition': false,
  };
  String otherNeurologicalCondition = 'None';

  // History
  Map<String, bool> history = {
    'Gait instability and/or falls': false,
    'Clumsiness': false,
    'Neck pain': false,
    'Numbness in fingers and/or toes': false,
    'Weakness in arms and/or legs': false,
    'Urinary urgency/frequency': false,
  };

  // Physical Exam
  Map<String, bool> physicalExam = {
    'Increased tone in upper or lower limbs': false,
    'Muscular weakness': false,
    'Decreased sensation to light touch or vibration in upper or lower limbs':
        false,
    'Hyperreflexia in upper limbs (biceps, brachioradialis or triceps)': false,
    'Hyperreflexia in lower limbs (patellar or ankle)': false,
    'Pathological reflexes (Hoffman’s sign, inverted supinator sign, positive Babinski reflex)':
        false,
    'Ankle clonus': false,
    'Inability to tandem walk': false,
    'Positive Romberg sign': false,
  };

  // MRI Features
  String mriDate = '';
  String compressionLevel = '';
  double da = 0.0;
  double db = 0.0;
  double di = 0.0;
  String mscc = "";
  double sagDiam = 0.0;
  double transvDiam = 0.0;
  double compressionRatio = 0.0;
  double compressedArea = 0.0;
  bool HI = false;
  bool type1 = false;
  bool type2 = false;

  // Helper for Comorbidities Checkboxes
  List<Widget> buildComorbidityCheckboxes() {
    return comorbidities.keys.map((String key) {
      return CheckboxListTile(
        title: Text(key),
        value: comorbidities[key],
        onChanged: (bool? value) {
          setState(() {
            comorbidities[key] = value!;
          });
        },
      );
    }).toList();
  }

  // Form UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Study Info'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Study ID'),
              onChanged: (value) {
                setState(() {
                  studyID = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  age = int.parse(value);
                });
              },
            ),

            DropdownButtonFormField<String>(
              value: sex,
              decoration: const InputDecoration(labelText: 'Sex'),
              items: ['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => setState(() {
                sex = value!;
              }),
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Duration of Symptoms (in months)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => durationOfSymptoms = int.parse(value),
            ),
            SwitchListTile(
              title: const Text('Prior Cervical Spine Surgery'),
              value: priorSurgery,
              onChanged: (value) => setState(() {
                priorSurgery = value;
              }),
            ),
            if (priorSurgery)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Date of Surgery'),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          // Format the date as needed (e.g., YYYY-MM-DD)
                          dateOfSurgery =
                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                        });
                      }
                    },
                    child: Text(
                      dateOfSurgery.isEmpty ? 'Select Date' : dateOfSurgery,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),
            const Text('Comorbidities',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...buildComorbidityCheckboxes(),
            if (comorbidities['Other neurological condition'] == true)
              TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Other Neurological Condition'),
                  onChanged: (value) => setState(() {
                        otherNeurologicalCondition = value;
                      })),
            const SizedBox(height: 20),
            const Text('History',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...history.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: history[key],
                onChanged: (bool? value) {
                  setState(() {
                    history[key] = value!;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text('Physical Exam',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...physicalExam.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: physicalExam[key],
                onChanged: (bool? value) {
                  setState(() {
                    physicalExam[key] = value!;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text('MRI Features',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    // Format the date as YYYY-MM-DD
                    mriDate =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  });
                }
              },
              child: Text(
                mriDate.isEmpty ? 'Select Date' : mriDate,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Compression Level'),
              onChanged: (value) {
                setState(() {
                  compressionLevel = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'da (mm)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  da = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'db (mm)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  db = double.tryParse(value) ?? 0.0;
                });
              },
            ),

// Display AVG (da + db) / 2
            // Text(
            //   'AVG (da + db) / 2: ${((da + db) / 2).toStringAsFixed(2)} mm',
            //   style: const TextStyle(fontWeight: FontWeight.bold),
            // ),

// di (mm)
            TextFormField(
              decoration: const InputDecoration(labelText: 'di (mm)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  di = double.tryParse(value) ?? 0.0;
                });
              },
            ),

// MSCC
            TextFormField(
              decoration: const InputDecoration(labelText: 'MSCC'),
              onChanged: (value) {
                setState(() {
                  mscc = value;
                });
              },
            ),

// Sag Diam (mm)
            TextFormField(
              decoration: const InputDecoration(labelText: 'Sag Diam (mm)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  sagDiam = double.tryParse(value) ?? 0.0;
                });
              },
            ),

// Transv Diam (mm)
            TextFormField(
              decoration: const InputDecoration(labelText: 'Transv Diam (mm)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  transvDiam = double.tryParse(value) ?? 0.0;
                });
              },
            ),

// Compression Ratio (CR)
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Compression Ratio (CR)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  // Assuming CR is a direct input
                  compressionRatio = double.tryParse(value) ?? 0.0;
                });
              },
            ),

// Compressed Area (mm^2)
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Compressed Area (mm^2)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  compressedArea = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            // HI (Y/N) - using Checkbox
            CheckboxListTile(
              title: const Text('HI'),
              value: HI,
              onChanged: (bool? value) {
                setState(() {
                  HI = value ?? false;
                });
              },
            ),

// Type 1 (Y/N) - using Checkbox
            CheckboxListTile(
              title: const Text('Type 1'),
              value: type1,
              onChanged: (bool? value) {
                setState(() {
                  type1 = value ?? false;
                });
              },
            ),

// Type 2 (Y/N) - using Checkbox
            CheckboxListTile(
              title: const Text('Type 2'),
              value: type2,
              onChanged: (bool? value) {
                setState(() {
                  type2 = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await generatePdf();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Patient Information',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              // Study ID and basic details
              pw.Text('Study ID: $studyID'),
              pw.Text('Age: $age'),
              pw.Text('Sex: $sex'),
              pw.Text('Duration of Symptoms: $durationOfSymptoms days'),
              pw.Text('Prior Cervical Surgery: $priorSurgery'),
              if (priorSurgery) pw.Text('Date of Surgery: $dateOfSurgery'),
              pw.SizedBox(height: 20),

              // Comorbidities Section
              pw.Text(
                  'Chiari Malformation: ${comorbidities['Chiari malformation'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Multiple Sclerosis: ${comorbidities['Multiple sclerosis'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Peripheral Neuropathy: ${comorbidities['Peripheral neuropathy'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Diabetes: ${comorbidities['Diabetes'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Stroke: ${comorbidities['Stroke'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'B12 Deficiency: ${comorbidities['B12 deficiency'] == true ? "Yes" : "No"}'),

              pw.Text(
                  'Prior Lumbar Spine Surgery: ${comorbidities['Prior lumbar spine surgery'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Arthritis of the Hand: ${comorbidities['Arthritis of the hand'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Prior Hand Surgery: ${comorbidities['Prior hand surgery'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Other Neurological Condition: $otherNeurologicalCondition'),

              pw.SizedBox(height: 20),

              // History Section
              pw.Text('History',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                  'Gait Instability and/or Falls: ${history['Gait instability and/or falls'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Clumsiness: ${history['Clumsiness'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Neck Pain: ${history['Neck pain'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Numbness in Fingers and/or Toes: ${history['Numbness in fingers and/or toes'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Weakness in Arms and/or Legs: ${history['Weakness in arms and/or legs'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Urinary Urgency/Frequency: ${history['Urinary urgency/frequency'] == true ? "Yes" : "No"}'),
              pw.SizedBox(height: 20),

              // Physical Exam Section
              pw.Text('Physical Exam',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                  'Increased Tone in Limbs: ${physicalExam['Increased tone in upper or lower limbs'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Muscular Weakness: ${physicalExam['Muscular weakness'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Decreased Sensation: ${physicalExam['Decreased sensation to light touch or vibration'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Hyperreflexia in Upper Limbs: ${physicalExam['Hyperreflexia in upper limbs'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Hyperreflexia in Lower Limbs: ${physicalExam['Hyperreflexia in lower limbs'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Pathological Reflexes: ${physicalExam['Pathological reflexes'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Ankle Clonus: ${physicalExam['Ankle clonus'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Inability to Tandem Walk: ${physicalExam['Inability to tandem walk'] == true ? "Yes" : "No"}'),
              pw.Text(
                  'Positive Romberg Sign: ${physicalExam['Positive Romberg sign'] == true ? "Yes" : "No"}'),

              pw.SizedBox(height: 20),

              // MRI Features Section
              pw.Text('MRI Features',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text('MRI Date: $mriDate'),
              pw.Text('Compression Level: $compressionLevel'),
              pw.Text('da (mm): $da'),
              pw.Text('db (mm): $db'),
              pw.Text('AVG (da + db) / 2: ${(da + db) / 2} mm'),
              pw.Text('di (mm): $di'),
              pw.Text('MSCC: $mscc'),
              pw.Text('Sag Diam (mm): $sagDiam'),
              pw.Text('Transv Diam (mm): $transvDiam'),
              pw.Text('Compression Ratio: $compressionRatio'),
              pw.Text('Compressed Area (mm^2): $compressedArea'),
              pw.Text('HI: ${HI ? "Yes" : "No"}'),
              pw.Text('Type 1: ${type1 ? "Yes" : "No"}'),
              pw.Text('Type 2: ${type2 ? "Yes" : "No"}'),
            ],
          );
        },
      ),
    );

    // Save the PDF to the device's documents directory
    // final directory = await getApplicationDocumentsDirectory();
    final String directory = (await getExternalStorageDirectory())!.path;
    final file = File('$directory/patient_info_$studyID.pdf');
    await file.writeAsBytes(await pdf.save());
    print(file.path);

    // Show a message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved: ${file.path}')),
    );
  }
}
