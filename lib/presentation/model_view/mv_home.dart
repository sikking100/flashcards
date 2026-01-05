import 'package:flashcards/data/models/model_review.dart';
import 'package:flashcards/data/repository/repo_review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_logger/simple_logger.dart';

final todayStudyProvider = FutureProvider.autoDispose<List<ModelReview>>((ref) async {
  SimpleLogger().warning('build home');
  final response = await ref.watch(repoReviewProvider).today();
  return response.docs.map((e) => ModelReview.fromMap(e.data())).toList();
});
