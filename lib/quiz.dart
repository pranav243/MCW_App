import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // Import this for File




// Future<Uint8List> loadFont(String path) async {
//   final ByteData bytes = await rootBundle.load(path);
//   return bytes.buffer.asUint8List();
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
final List<Map<String, Object>> _questions = [
    {
      'section': 'Section 1: Pain Intensity',
      'question': 'Please select your current level of pain:',
      'options': [
        'I have no pain at the moment',
        'The pain is very mild at the moment',
        'The pain is moderate at the moment',
        'The pain is fairly severe at the moment',
        'The pain is very severe at the moment',
        'The pain is the worst imaginable at the moment',
      ],
    },
    {
      'section': 'Section 2: Personal Care (Washing, Dressing, etc.)',
      'question': 'How does pain affect your personal care?',
      'options': [
        'I can look after myself normally without causing extra pain',
        'I can look after myself normally but it causes extra pain',
        'It is painful to look after myself and I am slow and careful',
        'I need some help but can manage most of my personal care',
        'I need help every day in most aspects of self-care',
        'I do not get dressed, I wash with difficulty and stay in bed',
      ],
    },
    {
      'section': 'Section 3: Lifting',
      'question': 'How does pain affect your ability to lift objects?',
      'options': [
        'I can lift heavy weights without extra pain',
        'I can lift heavy weights but it gives extra pain',
        'Pain prevents me lifting heavy weights off the floor, but I can manage if they are conveniently placed, for example on a table',
        'Pain prevents me from lifting heavy weights but I can manage light to medium weights if they are conveniently positioned',
        'I can only lift very light weights',
        'I cannot lift or carry anything',
      ],
    },
    {
      'section': 'Section 4: Reading',
      'question': 'How does pain affect your ability to read?',
      'options': [
        'I can read as much as I want to with no pain in my neck',
        'I can read as much as I want to with slight pain in my neck',
        'I can read as much as I want with moderate pain in my neck',
        'I can’t read as much as I want because of moderate pain in my neck',
        'I can hardly read at all because of severe pain in my neck',
        'I cannot read at all',
      ],
    },
    {
      'section': 'Section 5: Headaches',
      'question': 'How often do you experience headaches?',
      'options': [
        'I have no headaches at all',
        'I have slight headaches, which come infrequently',
        'I have moderate headaches, which come infrequently',
        'I have moderate headaches, which come frequently',
        'I have severe headaches, which come frequently',
        'I have headaches almost all the time',
      ],
    },
    {
      'section': 'Section 6: Concentration',
      'question': 'How does pain affect your concentration?',
      'options': [
        'I can concentrate fully when I want to with no difficulty',
        'I can concentrate fully when I want to with slight difficulty',
        'I have a fair degree of difficulty in concentrating when I want to',
        'I have a lot of difficulty in concentrating when I want to',
        'I have a great deal of difficulty in concentrating when I want to',
        'I cannot concentrate at all',
      ],
    },
     {
      'section': 'Section 7: Upper Extremity Motor Dysfunction',
      'question': 'How does pain affect your upper extremity motor function?',
      'options': [
        'I have no difficulty moving my hands',
        'I have difficulty eating with a spoon but can move my hands',
        'I have difficulty buttoning my shirt but can eat with a spoon',
        'I can button my shirt with great difficulty',
        'I can button my shirt with slight difficulty',
        'I have no dysfunction',
      ],
    },
    {
      'section': 'Section 8: Lower Extremity Motor Dysfunction',
      'question': 'How does pain affect your lower extremity motor function?',
      'options': [
        'I have complete loss of motor and sensory function',
        'I have sensory preservation but cannot move my legs',
        'I can move my legs but cannot walk',
        'I can walk on a flat floor with a walking aid (cane or crutch)',
        'I can walk up and/or down stairs with a handrail',
        'I have moderate-to-significant lack of stability but can walk up and/or down stairs without a handrail',
        'I have mild lack of stability but walk with smooth reciprocation unaided',
        'I have no dysfunction',
      ],
    },
    {
      'section': 'Section 9: Sensory Dysfunction of the Upper Extremities',
      'question': 'How does pain affect your sensory function in your upper extremities?',
      'options': [
        'I have complete loss of hand sensation',
        'I have mild sensory loss',
        'I have severe sensory loss or pain',
        'I have no sensory loss',
      ],
    },
    {
      'section': 'Section 10: Sphincter Dysfunction',
      'question': 'How does pain affect your sphincter function?',
      'options': [
        'I am unable to micturiate voluntarily',
        'I have marked difficulty with micturition',
        'I have mild to moderate difficulty with micturition',
        'I have normal micturition',
      ],
    },{
      'section': 'Section 11: Activities',
      'question': 'Vigorous activities, such as running, lifting heavy objects, participating in strenuous sports',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 12: Activities',
      'question': 'Moderate activities, such as moving a table, pushing a vacuum cleaner, bowling, or playing golf',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 13: Activities',
      'question': 'Lifting or carrying groceries',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 14: Activities',
      'question': 'Climbing several flights of stairs',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 15: Activities',
      'question': 'Climbing one flight of stairs',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 16: Activities',
      'question': 'Bending, kneeling, or stooping',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 17: Activities',
      'question': 'Walking more than a mile',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 18: Activities',
      'question': 'Walking several hundred yards',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 19: Activities',
      'question': 'Walking one hundred yards',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 20: Activities',
      'question': 'Bathing or dressing yourself',
      'options': [
        'Yes, limited a lot',
        'Yes, limited a little',
        'No, not limited at all',
      ],
    },
    {
      'section': 'Section 21: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Cut down on the amount of time you spent on work or other activities',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 22: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Accomplished less than you would like',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 23: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Were limited in the kind of work or other activities',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 24: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Had difficulty performing the work or other activities (for example, it took extra effort)',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    
    {
      'section': 'Section 25: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Did you feel full of life?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 26: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Have you been very nervous?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 27: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Have you felt so down in the dumps that nothing could cheer you up?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time', 

      ],
    },
    {
      'section': 'Section 28: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Have you felt calm and peaceful?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 29: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Did you have a lot of energy?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 30: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Have you felt downhearted and depressed?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 31: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Did you feel worn out?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 32: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Have you been happy?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
    {
      'section': 'Section 33: During the past 4 weeks, how much of the time have you had any of the following problems with your work or other regular daily activities as a result of your physical health?',
      'question': 'Did you feel tired?',
      'options': [
        'All of the time',
        'Most of the time',
        'Some of the time',
        'A little of the time',
        'None of the time',
      ],
    },
  ];

  int _currentQuestionIndex = 0;
  List<int?> _selectedOptions;

  _QuizPageState() : _selectedOptions = List.filled(33, null);

  void _nextQuestion() {
    if (_selectedOptions[_currentQuestionIndex] == null) {
      _showUnansweredAlert();
      return;
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _prevQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _submitQuiz() async {
    await _generatePdf(); // Generate PDF with responses
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Quiz Submitted'),
        content: Text('Thank you for completing the quiz! PDF saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
// Future<pw.Font> loadFont(String path) async {
//   final ByteData data = await rootBundle.load(path);
//   final Uint8List fontData = data.buffer.asUint8List();
//   return pw.Font.ttf(fontData as ByteData); // Create Font object from Uint8List
// }
// Future<void> _generatePdf() async {
//   final pdf = pw.Document();

//   // Use the loaded font if necessary, e.g., uncomment if you have loaded the font.
//   // final font = await loadFont('assets/fonts/OpenSans-Regular.ttf'); 

//   // Accumulate all text for a single page
//   List<pw.Widget> questionWidgets = [];

//   for (int i = 0; i < _questions.length; i++) {
//     final question = _questions[i] as Map<String, dynamic>;
//     final selectedOptionIndex = _selectedOptions[i];

//     // Safely access the options
//     final options = question['options'] as List<dynamic>?;

//     // Check if the selected option index is valid
//     String option = selectedOptionIndex != null && options != null && 
//                     selectedOptionIndex >= 0 && 
//                     selectedOptionIndex < options.length
//                     ? options[selectedOptionIndex].toString() 
//                     : 'No answer selected';

//     // Accumulate widgets for each question with left alignment
//     questionWidgets.addAll([
//       pw.Align(
//         alignment: pw.Alignment.centerLeft, // Align text to the left
//         child: pw.Text(question['section'] as String, style: pw.TextStyle(fontSize: 16)),
//       ),
//       pw.Align(
//         alignment: pw.Alignment.centerLeft, // Align text to the left
//         child: pw.Text(question['question'] as String, style: pw.TextStyle(fontSize: 14)),
//       ),
//       pw.Align(
//         alignment: pw.Alignment.centerLeft, // Align text to the left
//         child: pw.Text('Your answer: $option', style: pw.TextStyle(fontSize: 12)),
//       ),
//       pw.SizedBox(height: 20), // Space between questions
//     ]);
//   }

//   // Add a single page with all questions
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) => pw.Column(
//         children: questionWidgets,
//       ),
//     ),
//   );

//   // Save the PDF file
//   final String directory = (await getExternalStorageDirectory())!.path;
//   final file = File('$directory/quiz_response.pdf');
//   await file.writeAsBytes(await pdf.save());
//   print('PDF saved at: ${file.path}');
// }
Future<void> _generatePdf() async {
  final pdf = pw.Document();

  // Accumulate all text for multiple pages
  List<pw.Widget> questionWidgets = [];

  for (int i = 0; i < _questions.length; i++) {
    final question = _questions[i] as Map<String, dynamic>;
    final selectedOptionIndex = _selectedOptions[i];

    // Safely access the options
    final options = question['options'] as List<dynamic>?;

    // Check if the selected option index is valid
    String option = selectedOptionIndex != null &&
            options != null &&
            selectedOptionIndex >= 0 &&
            selectedOptionIndex < options.length
        ? options[selectedOptionIndex].toString()
        : 'No answer selected';

    // Accumulate widgets for each question with left alignment
    questionWidgets.addAll([
      pw.Align(
        alignment: pw.Alignment.centerLeft, // Align text to the left
        child: pw.Text(
          question['section'] as String,
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.SizedBox(height: 5), // Space between section and question

      pw.Align(
        alignment: pw.Alignment.centerLeft, // Align text to the left
        child: pw.Text(
          question['question'] as String,
          style: pw.TextStyle(fontSize: 14),
        ),
      ),
      pw.SizedBox(height: 5), // Space between question and answer

      pw.Align(
        alignment: pw.Alignment.centerLeft, // Align text to the left
        child: pw.Text(
          'Your answer: $option',
          style: pw.TextStyle(fontSize: 12),
        ),
      ),
      pw.SizedBox(height: 20), // Space between questions
    ]);
  }

  // Add content across multiple pages
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return questionWidgets;
      },
    ),
  );

  // Save the PDF file to the device's external storage
  final String directory = (await getExternalStorageDirectory())!.path;
  final file = File('$directory/quiz_response.pdf');
  await file.writeAsBytes(await pdf.save());
  print('PDF saved at: ${file.path}');

  // Notify the user
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('PDF saved: ${file.path}')),
  );
}

  void _showUnansweredAlert() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Incomplete Answer'),
        content: Text('Please answer this question before proceeding.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final section = question['section'] as String;
    final questionText = question['question'] as String;
    final options = question['options'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              section,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              questionText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: options
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CheckboxListTile(
                        title: Text(entry.value),
                        value: _selectedOptions[_currentQuestionIndex] == entry.key,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedOptions[_currentQuestionIndex] = value! ? entry.key : null;
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: _prevQuestion,
                    child: Text('Previous Question'),
                  ),
                if (_currentQuestionIndex < _questions.length - 1)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text('Next Question'),
                  ),
                if (_currentQuestionIndex == _questions.length - 1)
                  ElevatedButton(
                    onPressed: _selectedOptions[_currentQuestionIndex] == null ? null : _submitQuiz,
                    child: Text('Submit'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
