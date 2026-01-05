import 'package:flashcards/presentation/model_view/mv_card_action.dart';
import 'package:flashcards/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flashcards/data/models/model_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageCardBulking extends HookWidget {
  const PageCardBulking({super.key, required this.idDeck});
  final String idDeck;

  @override
  Widget build(BuildContext context) {
    final cards = useState<List<ModelCard>>([ModelCard.toNew(front: '', back: '')]);

    void addCard() {
      cards.value = [...cards.value, ModelCard.toNew(front: '', back: '')];
    }

    void removeCard(int index) {
      final newList = [...cards.value]..removeAt(index);
      cards.value = newList;
    }

    void updateCard(int index, ModelCard newValue) {
      final newList = [...cards.value];
      newList[index] = newValue;
      cards.value = newList;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Card Bulking'),
        actions: [IconButton(onPressed: addCard, icon: Icon(Icons.add))],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: cards.value.length,
                itemBuilder: (context, index) {
                  final card = cards.value[index];
                  return CardBulkingInput(
                    key: ValueKey(index),
                    onRemove: () => removeCard(index),
                    index: index,
                    onChanged: (value) => updateCard(index, value),
                    card: card,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 16),
              ),
            ),
            HookConsumer(
              builder: (context, ref, child) {
                final loading = useState(false);
                return FilledButton(
                  onPressed: loading.value
                      ? null
                      : () async {
                          try {
                            loading.value = true;
                            // SimpleLogger().info(cards);
                            await ref.read(cardActionProvider).bulking(idDeck: idDeck, list: cards.value);
                            if (context.mounted) Navigator.pop(context);
                            return;
                          } catch (e) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(title: Text('Oops'), content: Text('$e')),
                              );
                            }
                            return;
                          } finally {
                            loading.value = false;
                          }
                        },
                  child: loading.value ? WidgetLoading() : Text('Save'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CardBulkingInput extends StatefulHookWidget {
  final VoidCallback onRemove;
  final ValueChanged<ModelCard> onChanged;
  final int index;
  final ModelCard card;

  const CardBulkingInput({super.key, required this.onRemove, required this.onChanged, required this.index, required this.card});

  @override
  State<CardBulkingInput> createState() => _CardBulkingInputState();
}

class _CardBulkingInputState extends State<CardBulkingInput> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final question = useTextEditingController(text: widget.card.front);
    final answer = useTextEditingController(text: widget.card.back);
    final focus1 = useFocusNode();
    final focus2 = useFocusNode();
    useEffect(() {
      question.text = widget.card.front;
      answer.text = widget.card.back;
      return null;
    }, [widget.card.front, widget.card.back]);

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text('Card ${widget.index + 1}'),
              TextField(
                focusNode: focus1,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(label: Text('Question')),
                onChanged: (value) => widget.onChanged(widget.card.copyWith(front: value)),
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(focus2);
                },
              ),
              TextField(
                focusNode: focus2,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(label: Text('Answer')),
                onChanged: (value) => widget.onChanged(widget.card.copyWith(back: value)),
              ),
            ],
          ),
        ),
        IconButton(icon: const Icon(Icons.remove), onPressed: widget.onRemove),
      ],
    );
  }
}
