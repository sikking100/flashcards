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
            _ => StudyTyping(cards: data, mode: notifier.mode, idDeck: idDeck),
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

(List<bool>, void Function(int index, bool isLoading)) useMultiLoading(int count) {
  final states = useState<List<bool>>(List.filled(count, false));

  void setLoading(int index, bool isLoading) {
    final newStates = [...states.value];
    newStates[index] = isLoading;
    states.value = newStates;
  }

  return (states.value, setLoading);
}

class StudyMultipleChoice extends HookConsumerWidget {
  final List<ModelCard> cards;
  final StudyMode mode;
  final String idDeck;
  const StudyMultipleChoice({super.key, required this.cards, required this.mode, required this.idDeck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SimpleLogger().info('rebuild');
    final index = useState(0);
    if (cards.isEmpty) return Center(child: Text('No cards to study'));
    final prompt = buildPrompt(cards[index.value], mode, cards);
    return Column(
      children: [
        Text(prompt.question, style: TextStyle(fontSize: 24)),
        SizedBox(height: 24),
        HookBuilder(
          builder: (context) {
            final (loadingStates, setLoading) = useMultiLoading(prompt.choices?.length ?? 0);
            final onTap = useCallback((String choice, int choiceIndex) async {
              final isCorrect = choice == prompt.correctAnswer;
              setLoading(choiceIndex, true);
              await ref.read(mvStudyProvider).swipe(id: cards[index.value].id ?? '', direction: isCorrect ? 'right' : 'left');
              if (context.mounted) {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(isCorrect ? 'Correct' : 'Incorrect'),
                    content: Text('The correct answer is: ${prompt.correctAnswer}'),
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
              setLoading(choiceIndex, false);
              index.value += 1;
            }, []);
            return Column(
              children: [
                ...(prompt.choices ?? []).asMap().entries.map((entry) {
                  final choiceIndex = entry.key;
                  final choice = entry.value;
                  return Padding(
                    key: ValueKey(choice),
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loadingStates[choiceIndex] ? null : () => onTap(choice, choiceIndex),
                        child: loadingStates[choiceIndex] == true ? WidgetLoading() : Text(choice),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
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

class StudyTyping extends HookConsumerWidget {
  final List<ModelCard> cards;
  final StudyMode mode;
  final String idDeck;

  const StudyTyping({super.key, required this.cards, required this.mode, required this.idDeck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState(0);
    if (cards.isEmpty) return Center(child: Text('No cards to study'));
    final prompt = buildPrompt(cards[index.value], mode, cards);
    final textEditingController = useTextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Typing Study Mode'),
          SizedBox(height: 16),
          Text(prompt.question, style: TextStyle(fontSize: 24)),
          SizedBox(height: 24),
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(labelText: 'Your Answer'),
          ),
          SizedBox(height: 16),
          HookBuilder(
            builder: (context) {
              final loading = useState(false);
              return FilledButton(
                onPressed: loading.value
                    ? null
                    : () async {
                        final userAnswer = textEditingController.text.trim();
                        loading.value = true;
                        final isCorrect = userAnswer.toLowerCase() == prompt.correctAnswer.toLowerCase();
                        await ref.read(mvStudyProvider).swipe(id: cards[index.value].id ?? '', direction: isCorrect ? 'right' : 'left');
                        if (context.mounted) {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(isCorrect ? 'Correct' : 'Incorrect'),
                              content: Text('The correct answer is: ${prompt.correctAnswer}'),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
                            ),
                          );
                        }
                        textEditingController.clear();
                        if (index.value == cards.length - 1) {
                          ref.read(studyNotifierProvider(idDeck).notifier).next();
                          index.value = 0;
                        } else {
                          index.value += 1;
                        }
                        loading.value = false;
                      },
                child: loading.value ? WidgetLoading() : Text('Submit'),
              );
            },
          ),
        ],
      ),
    );
  }
}
