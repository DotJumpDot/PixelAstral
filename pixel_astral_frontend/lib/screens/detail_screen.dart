import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../store/novel.dart';
import '../type/collection_type.dart';
import '../type/collection_status.dart';
import '../component/retro_app_bar.dart';
import '../component/status_badge.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final novelId = GoRouterState.of(context).pathParameters['id']!;

    return Scaffold(
      appBar: RetroAppBar(
        title: 'Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/edit/$novelId'),
          ),
        ],
      ),
      body: Consumer<NovelProvider>(
        builder: (context, novelProvider, child) {
          final novelIndex = novelProvider.novels.indexWhere(
            (n) => n.id == novelId,
          );

          if (novelIndex == -1) {
            return const Center(child: Text('Item not found'));
          }

          final novel = novelProvider.novels[novelIndex];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            novel.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            novel.type.displayName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(status: novel.status),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                _buildDetailRow(Icons.link, 'URL', novel.url, isUrl: true),
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.menu_book,
                  'Chapter',
                  'Chapter ${novel.chapter}',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.description,
                  'Page',
                  'Page ${novel.page}',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.update,
                  'Status',
                  novel.status.displayName,
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                Text(
                  'Created',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  _formatDate(novel.createdAt),
                  style: const TextStyle(fontSize: 16),
                ),
                if (novel.updatedAt != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Last Updated',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  Text(
                    _formatDate(novel.updatedAt!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl(novel.url),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open in Browser'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/edit/${novel.id}'),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Item'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    bool isUrl = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF00D4FF)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: isUrl ? const Color(0xFF00D4FF) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
