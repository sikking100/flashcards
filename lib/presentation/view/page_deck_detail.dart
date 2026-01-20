import 'dart:io';

import 'package:flashcards/data/models/model_card.dart';
import 'package:flashcards/presentation/model_view/mv_card_action.dart';
import 'package:flashcards/presentation/model_view/mv_cards_pagination.dart';
import 'package:flashcards/presentation/view/page_candidates.dart';
import 'package:flashcards/presentation/view/page_test.dart';
import 'package:flashcards/router.dart';
import 'package:flashcards/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PageDeckDetail extends ConsumerWidget {
  final String id;
  final String name;
  const PageDeckDetail({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cardStateNotifierProvider(id));
    final vm = ref.read(cardStateNotifierProvider(id).notifier);
    return Scaffold(
      appBar: AppBar(title: Text(name)),

      body: RefreshIndicator(
        child: PagedListView.separated(
          padding: EdgeInsets.all(16).copyWith(top: 0, bottom: 84),
          state: state,
          fetchNextPage: () => vm.fetchNextPage(),
          builderDelegate: PagedChildBuilderDelegate<ModelCard>(
            itemBuilder: (context, item, index) => Card(
              child: ListTile(
                title: Text(item.front),
                trailing: InkWell(
                  child: Icon(Icons.more_vert),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                          onTap: () {
                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: HookBuilder(
                                    builder: (context) {
                                      final front = useTextEditingController(text: item.front);
                                      final back = useTextEditingController(text: item.back);
                                      final loading = useState(false);
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Edit card'),
                                          SizedBox(height: 20),
                                          TextField(
                                            controller: front,
                                            textCapitalization: TextCapitalization.words,
                                            decoration: InputDecoration(label: Text('Front')),
                                          ),
                                          TextField(
                                            controller: back,
                                            textCapitalization: TextCapitalization.words,
                                            decoration: InputDecoration(label: Text('Back')),
                                          ),
                                          SizedBox(height: 20),
                                          FilledButton(
                                            onPressed: loading.value
                                                ? null
                                                : () async {
                                                    try {
                                                      loading.value = true;
                                                      await ref
                                                          .read(cardActionProvider)
                                                          .update(idDeck: id, id: item.id ?? '', front: front.text, back: back.text);
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
                                );
                              },
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
                                title: Text('Are you sure?'),
                                content: Text('This action cannot be undone.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        Navigator.pop(context);
                                        await ref.read(cardActionProvider).delete(idDeck: id, id: item.id ?? '');
                                      } catch (e) {
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(title: Text('Oops'), content: Text('$e')),
                                          );
                                        }
                                      }
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Input method'),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text('Manual'),
                    leading: Icon(Icons.edit),
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: HookBuilder(
                              builder: (context) {
                                final question = useTextEditingController();
                                final answer = useTextEditingController();
                                final loading = useState(false);
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Input cards'),
                                    SizedBox(height: 20),
                                    TextField(
                                      controller: question,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: InputDecoration(label: Text('Front')),
                                    ),
                                    TextField(
                                      controller: answer,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: InputDecoration(label: Text('Back')),
                                    ),
                                    SizedBox(height: 20),
                                    FilledButton(
                                      onPressed: loading.value
                                          ? null
                                          : () async {
                                              try {
                                                loading.value = true;
                                                await ref.read(cardActionProvider).create(idDeck: id, front: question.text, back: answer.text);
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
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Kamera'),
                    leading: Icon(Icons.camera),
                    onTap: () async {
                      try {
                        // final result = await ImagePicker().pickImage(source: ImageSource.camera);
                        // if (result != null && context.mounted) {
                        //   await CandidateScreenRoute($extra: File(result.path)).push(context);
                        //   vm.refresh();
                        // }
                        await TestScreenRoute().push(context);
                        if (context.mounted) Navigator.pop(context);
                        return;
                      } catch (e) {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(title: Text('Error'), content: Text('$e')),
                          );
                        }
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Bulk'),
                    leading: Icon(Icons.folder_copy),
                    onTap: () {
                      Navigator.pop(context);
                      CardBulkScreenRoute(idDeck: id).push(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
