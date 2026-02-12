import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../store/novel.dart';
import '../type/collection_type.dart';
import '../component/collection_card.dart';
import '../component/retro_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NovelProvider>().loadNovels();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final type = CollectionType.values[_tabController.index];
    context.read<NovelProvider>().setFilterType(type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A1A2E),
                  const Color(0xFF0D0D1A),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFF00D4FF), size: 32),
                        const SizedBox(width: 12),
                        const Text(
                          'PixelAstral',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Manga'),
                      Tab(text: 'Novel'),
                      Tab(text: 'Manhwa'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _NovelList(type: CollectionType.manga),
                _NovelList(type: CollectionType.novel),
                _NovelList(type: CollectionType.manhwa),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: RetroFab(
        onPressed: () => context.push('/add', extra: CollectionType.values[_tabController.index]),
        icon: Icons.add,
        tooltip: 'Add New',
      ),
    );
  }
}

class _NovelList extends StatelessWidget {
  final CollectionType type;

  const _NovelList({required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer<NovelProvider>(
      builder: (context, novelProvider, child) {
        if (novelProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final novels = novelProvider.novels.where((n) => n.type == type).toList();

        if (novels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.library_books_outlined,
                  size: 64,
                  color: Colors.white24,
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${type.displayName}s yet',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add your first ${type.displayName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: novels.length,
          itemBuilder: (context, index) {
            final novel = novels[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CollectionCard(
                novel: novel,
                onTap: () => context.push('/detail/${novel.id}'),
                onEdit: () => context.push('/edit/${novel.id}'),
                onDelete: () => _showDeleteDialog(context, novel.id, novelProvider),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String id, NovelProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteNovel(id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
