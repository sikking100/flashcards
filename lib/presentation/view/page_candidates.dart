import 'dart:io';

import 'package:flashcards/presentation/model_view/mv_candidates.dart';
import 'package:flashcards/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageCandidates extends ConsumerWidget {
  final File file;
  const PageCandidates({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tes = ref.watch(tesnotifierProvider(file));
    return Scaffold(
      appBar: AppBar(title: Text('Candidates')),
      body: tes.when(data: (data) => Container(), error: (error, stackTrace) => Text('$error'), loading: () => WidgetLoading()),
    );
  }
}
