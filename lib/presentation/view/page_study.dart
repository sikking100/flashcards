import 'dart:math';
import 'package:flashcards/data/models/model_card.dart';
import 'package:flashcards/presentation/model_view/mv_study.dart';
import 'package:flashcards/widgets/card.dart';
import 'package:flashcards/widgets/loading.dart';
import 'package:flashcards/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_logger/simple_logger.dart';

class PageStudy extends ConsumerWidget {
  final String idDeck;
  final String title;
  const PageStudy({super.key, required this.idDeck, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyNotifierProvider(idDeck));
    final notifier = ref.watch(studyNotifierProvider(idDeck).notifier);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: state.when(
        data: (data) {
          SimpleLogger().info(data.length);
          return switch (notifier.mode) {
            StudyMode.frontToBack => StudySwipe(cards: data, mode: notifier.mode, idDeck: idDeck),
            StudyMode.backToFront => StudySwipe(cards: data, mode: notifier.mode, idDeck: idDeck),
            StudyMode.multipleChoice => StudyMultipleChoice(cards: data, mode: notifier.mode, idDeck: idDeck),
            _ => Center(child: Text('Unknown Study Mode')),
          };
        },
        error: (error, stackTrace) => Center(child: Text('$error')),
        loading: () => Center(child: WidgetLoading()),
      ),
    );
  }
}

class StudySwipe extends StatefulHookConsumerWidget {
  final List<ModelCard> cards;
  final StudyMode mode;
  final String idDeck;
  const StudySwipe({super.key, required this.cards, required this.mode, required this.idDeck});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudySwipeState();
}

class _StudySwipeState extends ConsumerState<StudySwipe> {
  late final CardSwiperController controller;

  @override
  void initState() {
    controller = CardSwiperController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = useState(0);
    if (widget.cards.isEmpty) return Center(child: Text('No cards to study'));
    final key = useState(UniqueKey());
    return Column(
      key: key.value,
      children: [
        Flexible(
          child: CardSwiper(
            onEnd: () async {
              // await showDialog(
              //   context: context,
              //   builder: (context) => AlertDialog(
              //     title: Text('Congratulations'),
              //     content: Text('You already learnt all the cards'),
              //     actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
              //   ),
              // );
              // if (context.mounted) Navigator.pop(context, true);
              return;
            },
            controller: controller,
            initialIndex: index.value,
            cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
              final studyPrompt = buildPrompt(widget.cards[index], widget.mode, widget.cards);
              // return Container();
              return Center(
                child: WidgetCard(question: studyPrompt.question, answer: studyPrompt.correctAnswer),
              );
            },
            cardsCount: widget.cards.length,
            isLoop: false,
            onSwipe: (previousIndex, currentIndex, direction) async {
              try {
                index.value = currentIndex ?? previousIndex;
                final card = widget.cards[previousIndex];
                await ref.read(mvStudyProvider).swipe(id: card.id ?? '', direction: direction.name);
                return true;
              } catch (e) {
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(title: Text('Oops'), content: Text('$e')),
                  );
                }
                return false;
              }
            },
          ),
        ),
        SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: () async {
                try {
                  final card = widget.cards[index.value];
                  await ref.read(mvStudyProvider).notknow(id: card.id ?? '');
                  if (index.value == widget.cards.length - 1) {
                    return;
                  } else {
                    index.value += 1;
                    controller.moveTo(index.value);
                    return;
                  }
                } catch (e) {
                  if (context.mounted) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(title: Text('Oops'), content: Text('$e')),
                    );
                  }
                  return;
                }
              },
              label: Text('Not Know'),
              icon: Icon(Icons.close),
            ),
            if (index.value == widget.cards.length - 1) ...[
              SizedBox(width: 16),
              FilledButton.icon(
                onPressed: () {
                  index.value = 0;
                  ref.read(studyNotifierProvider(widget.idDeck).notifier).next();
                  key.value = UniqueKey();
                },
                label: Text('Next'),
                icon: Icon(Icons.check),
              ),
            ],
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class StudyMultipleChoice extends HookConsumerWidget {
  final List<ModelCard> cards;
  final StudyMode mode;
  final String idDeck;
  const StudyMultipleChoice({super.key, required this.cards, required this.mode, required this.idDeck});

  void onClick(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> loading,
    String correctAnswer,
    ModelCard card,
    String choice,
    ValueNotifier<int> index,
  ) async {
    loading.value = true;
    final isCorrect = choice == correctAnswer;
    loading.value = true;
    await ref.read(mvStudyProvider).swipe(id: card.id ?? '', direction: isCorrect ? 'right' : 'left');
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(isCorrect ? 'Correct' : 'Incorrect'),
          content: Text('The correct answer is: $correctAnswer'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
        ),
      );
    }
    if (index.value == cards.length - 1) {
      ref.read(studyNotifierProvider(idDeck).notifier).next();
      index.value = 0;
    } else {
      index.value += 1;
    }
    loading.value = false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState(0);
    if (cards.isEmpty) return Center(child: Text('No cards to study'));
    final prompt = buildPrompt(cards[index.value], mode, cards);
    return Column(
      children: [
        Text(prompt.question, style: TextStyle(fontSize: 24)),
        SizedBox(height: 24),
        HookBuilder(
          builder: (context) {
            final loading0 = useState(false);
            final loading1 = useState(false);
            final loading2 = useState(false);
            final loading3 = useState(false);

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading0.value
                        ? null
                        : () => onClick(context, ref, loading0, prompt.correctAnswer, cards[index.value], prompt.choices![0], index),
                    child: loading0.value == true ? WidgetLoading() : Text(prompt.choices![0]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading1.value
                        ? null
                        : () => onClick(context, ref, loading1, prompt.correctAnswer, cards[index.value], prompt.choices![1], index),
                    child: loading1.value == true ? WidgetLoading() : Text(prompt.choices![1]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading2.value
                        ? null
                        : () => onClick(context, ref, loading2, prompt.correctAnswer, cards[index.value], prompt.choices![2], index),
                    child: loading2.value == true ? WidgetLoading() : Text(prompt.choices![2]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading3.value
                        ? null
                        : () => onClick(context, ref, loading3, prompt.correctAnswer, cards[index.value], prompt.choices![3], index),
                    child: loading3.value == true ? WidgetLoading() : Text(prompt.choices![3]),
                  ),
                ),
              ],
            );
          },
        ),
        // ...(prompt.choices ?? []).asMap().entries.map((entry) {
        //   final choiceIndex = entry.key;
        //   final choice = entry.value;
        //   final loading = switch (choiceIndex) {
        //     0 => loading0,
        //     1 => loading1,
        //     2 => loading2,
        //     _ => loading3,
        //   };
        //   return Padding(
        //     key: ValueKey(choice),
        //     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        //     child: SizedBox(
        //       width: double.infinity,
        //       child: ElevatedButton(
        //         onPressed: loading.value
        //             ? null
        //             : () async {
        //                 final isCorrect = choice == prompt.correctAnswer;
        //                 loading.value = true;
        //                 // await ref.read(mvStudyProvider).swipe(id: cards[index.value].id ?? '', direction: isCorrect ? 'right' : 'left');
        //                 // if (context.mounted) {
        //                 //   await showDialog(
        //                 //     context: context,
        //                 //     builder: (context) => AlertDialog(
        //                 //       title: Text(isCorrect ? 'Correct' : 'Incorrect'),
        //                 //       content: Text('The correct answer is: ${prompt.correctAnswer}'),
        //                 //       actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
        //                 //     ),
        //                 //   );
        //                 // }
        //                 // loading.value[choiceIndex] = false;
        //                 // index.value += 1;
        //               },
        //         child: loading.value == true ? WidgetLoading() : Text(choice),
        //       ),
        //     ),
        //   );
        // }),
        if (index.value == cards.length - 1) ...[
          SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              ref.read(studyNotifierProvider(idDeck).notifier).next();
              // key.value = UniqueKey();
            },
            child: Text('Next'),
          ),
        ],
      ],
    );
  }
}
