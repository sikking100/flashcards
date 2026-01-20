import 'package:flashcards/data/models/model_review.dart';
import 'package:flashcards/presentation/model_view/mv_study.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageReview extends HookConsumerWidget {
  final List<ModelReview> list;
  const PageReview({super.key, required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState(0);
    final controller = CardSwiperController();
    return Scaffold(
      appBar: AppBar(title: Text('Study Today')),
      body: Column(
        children: [
          Flexible(
            child: CardSwiper(
              onEnd: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Congratulations'),
                    content: Text('You already learnt all the cards'),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
                  ),
                );
                if (context.mounted) Navigator.pop(context, true);
                return;
              },
              controller: controller,
              initialIndex: index.value,
              cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
                index = index;
                return Container(alignment: Alignment.center, color: Colors.purple, child: Text(list[index].front));
              },
              cardsCount: list.length,
              isLoop: false,
              onSwipe: (previousIndex, currentIndex, direction) async {
                try {
                  index.value = currentIndex ?? previousIndex;
                  final card = list[previousIndex];
                  await ref.read(mvStudyProvider).swipe(id: card.id, direction: direction.name);
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
          FilledButton.icon(
            onPressed: () async {
              try {
                final card = list[index.value];
                await ref.read(mvStudyProvider).notknow(id: card.id);
                index.value += 1;
                controller.moveTo(index.value);
                return;
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
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
