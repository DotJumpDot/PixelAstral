import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../store/novel.dart';
import '../type/collection_type.dart';
import '../type/collection_status.dart';
import '../component/retro_app_bar.dart';
import '../component/input_field.dart';
import '../component/status_dropdown.dart';

class AddEditScreen extends StatefulWidget {
  const AddEditScreen({super.key});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _chapterController = TextEditingController(text: '0');
  final _pageController = TextEditingController(text: '0');

  CollectionType _type = CollectionType.novel;
  CollectionStatus _status = CollectionStatus.planToRead;
  String? _novelId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = GoRouterState.of(context).extra;
    if (args is String) {
      _novelId = args;
      _loadNovel();
    } else if (args is CollectionType) {
      _type = args;
    }
  }

  Future<void> _loadNovel() async {
    if (_novelId == null) return;
    final novelProvider = context.read<NovelProvider>();
    final novels = novelProvider.novels;
    final novelIndex = novels.indexWhere((n) => n.id == _novelId);

    if (novelIndex != -1) {
      final novel = novels[novelIndex];
      setState(() {
        _titleController.text = novel.title;
        _urlController.text = novel.url;
        _chapterController.text = novel.chapter.toString();
        _pageController.text = novel.page.toString();
        _type = novel.type;
        _status = novel.status;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _chapterController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final novelProvider = context.read<NovelProvider>();

    try {
      if (_novelId != null) {
        await novelProvider.updateNovel(
          id: _novelId!,
          title: _titleController.text.trim(),
          url: _urlController.text.trim(),
          chapter: int.tryParse(_chapterController.text) ?? 0,
          page: int.tryParse(_pageController.text) ?? 0,
          status: _status,
          type: _type,
        );
      } else {
        await novelProvider.addNovel(
          title: _titleController.text.trim(),
          url: _urlController.text.trim(),
          chapter: int.tryParse(_chapterController.text) ?? 0,
          page: int.tryParse(_pageController.text) ?? 0,
          status: _status,
          type: _type,
        );
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _novelId != null;

    return Scaffold(
      appBar: RetroAppBar(title: isEditing ? 'Edit Item' : 'Add New Item'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Collection Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SegmentedButton<CollectionType>(
                segments: CollectionType.values.map((type) {
                  return ButtonSegment(
                    value: type,
                    label: Text(type.displayName),
                  );
                }).toList(),
                selected: {_type},
                onSelectionChanged: (Set<CollectionType> newSelection) {
                  setState(() {
                    _type = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),
              InputField(
                label: 'Title',
                hintText: 'Enter title',
                controller: _titleController,
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InputField(
                label: 'URL',
                hintText: 'Enter URL to read',
                controller: _urlController,
                keyboardType: TextInputType.url,
                icon: Icons.link,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: 'Chapter',
                      hintText: '0',
                      controller: _chapterController,
                      keyboardType: TextInputType.number,
                      icon: Icons.menu_book,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InputField(
                      label: 'Page',
                      hintText: '0',
                      controller: _pageController,
                      keyboardType: TextInputType.number,
                      icon: Icons.description,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StatusDropdown(
                value: _status,
                onChanged: (status) {
                  setState(() {
                    _status = status ?? CollectionStatus.planToRead;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEditing ? 'Update' : 'Add to Collection'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
