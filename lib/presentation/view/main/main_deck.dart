import 'package:flashcards/data/models/model_deck.dart';
import 'package:flashcards/presentation/model_view/mv_deck_action.dart';
import 'package:flashcards/presentation/model_view/mv_deck_pagination.dart';
import 'package:flashcards/router.dart';
import 'package:flashcards/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MainDeck extends ConsumerWidget {
  const MainDeck({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deckStateNotifierProvider);
    final vm = ref.read(deckStateNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text('Decks'), automaticallyImplyLeading: false),
      body: RefreshIndicator(
        child: PagedListView.separated(
          padding: EdgeInsets.all(16).copyWith(top: 0, bottom: 84),
          state: state,
          fetchNextPage: () => vm.fetchNextPage(),
          builderDelegate: PagedChildBuilderDelegate<ModelDeck>(
            itemBuilder: (context, item, index) => Card(
              child: ListTile(
                contentPadding: EdgeInsets.only(right: 8, left: 16),
                onLongPress: () async => ref.read(deckActionProvider).delete(item.id ?? ''),
                title: Text(item.title),
                onTap: () => DeckDetailScreenRoute(id: item.id ?? '', name: item.title).push(context),
                trailing: InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.play_arrow),
                          title: Text('Study'),
                          onTap: () {
                            Navigator.pop(context);
                            StudyScreenRoute(idDeck: item.id ?? '', title: item.title).push(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                          onTap: () {
                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: HookBuilder(
                                  builder: (context) {
                                    final textController = useTextEditingController(text: item.title);
                                    final loading = useState(false);
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Edit decks name'),
                                        SizedBox(height: 20),
                                        TextField(controller: textController, textCapitalization: TextCapitalization.words),
                                        SizedBox(height: 20),
                                        FilledButton(
                                          onPressed: loading.value
                                              ? null
                                              : () async {
                                                  try {
                                                    loading.value = true;
                                                    await ref.read(deckActionProvider).update(item.id ?? '', textController.text);
                                                    if (context.mounted) Navigator.pop(context);
                                                  } catch (e) {
                                                    if (context.mounted) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(title: Text('Oops'), content: Text('$e')),
                                                      );
                                                    }
                                                  } finally {
                                                    loading.value = false;
                                                  }
                                                },
                                          child: loading.value ? WidgetLoading() : Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Deck'),
                                content: Text('Are you sure you want to delete this deck? This action cannot be undone.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ref.read(deckActionProvider).delete(item.id ?? '');
                                    },
                                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  child: Icon(Icons.more_vert),
                ),
              ),
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(),
        ),
        onRefresh: () => vm.refresh(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: HookBuilder(
                builder: (context) {
                  final textController = useTextEditingController();
                  final loading = useState(false);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Input decks name'),
                      SizedBox(height: 20),
                      TextField(controller: textController, textCapitalization: TextCapitalization.words),
                      SizedBox(height: 20),
                      FilledButton(
                        onPressed: loading.value
                            ? null
                            : () async {
                                try {
                                  loading.value = true;
                                  await ref.read(deckActionProvider).create(textController.text);
                                  if (context.mounted) Navigator.pop(context);
                                } catch (e) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(title: Text('Oops'), content: Text('$e')),
                                    );
                                  }
                                } finally {
                                  loading.value = false;
                                }
                              },
                        child: loading.value ? WidgetLoading() : Text('Save'),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
