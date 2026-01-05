import 'dart:io';
import 'dart:math';

import 'package:flashcards/data/repository/repo_candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:simple_logger/simple_logger.dart';

final tesnotifierProvider = NotifierProvider.autoDispose.family<TesNotifier, AsyncValue, File>(TesNotifier.new);

class TesNotifier extends Notifier<AsyncValue> {
  @override
  AsyncValue build() {
    res();
    return AsyncValue.loading();
  }

  final File file;

  TesNotifier(this.file);

  void res() async {
    // generate text dari image
    final InputImage inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    String text = recognizedText.text;
    SimpleLogger().info(text);
    // textRecognizer.close();
    await ref.read(repoCandidateProvider).tes(buildPrompt(text));
  }

  String buildPrompt(String text) {
    return '''
You are an assistant that creates flashcards for swipe-based learning.

Rules:
- One card = one clear question and one clear answer
- Answers must be short (max 20 words)
- No explanations
- No extra context
- Avoid duplicates
- Use the same language as the input
- Output JSON only
- If text is unsuitable, return an empty cards array

Output format:
{
  "cards": [
    { "front": "...", "back": "..." }
  ]
}

Text:
"""
$text
"""
''';
  }
}
