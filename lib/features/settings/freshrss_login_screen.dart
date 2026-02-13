import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/providers/providers.dart';
import '../../core/models/episode.dart';
import '../../services/bilibili_parser_service.dart';

/// 订阅管理页面 — 各色大卡片入口
class FreshRssLoginScreen extends ConsumerStatefulWidget {
  const FreshRssLoginScreen({super.key});

  @override
  ConsumerState<FreshRssLoginScreen> createState() =>
      _FreshRssLoginScreenState();
}

class _FreshRssLoginScreenState extends ConsumerState<FreshRssLoginScreen> {
  // ── FreshRSS 表单 ──
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFreshRssConfig();
  }

  Future<void> _loadFreshRssConfig() async {
    final storage = ref.read(storageServiceProvider);
    final config = await storage.getFreshRssConfig();
    setState(() {
      _urlController.text = config['url'] ?? '';
      _userController.text = config['user'] ?? '';
      _passController.text = config['pass'] ?? '';
    });
  }

  // ── 功能实现 ──

  /// 刷新唱片架数据
  void _refreshShelf() {
    ref.invalidate(subscriptionsProvider);
    ref.invalidate(unifiedRecentEpisodesProvider);
    ref.invalidate(freshrssEpisodesProvider);
    ref.invalidate(freshrssSubscriptionsProvider);
    ref.invalidate(recentSubscribedEpisodesProvider);
  }

  /// 手动输入 RSS 地址订阅
  void _showAddRssDialog() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('RSS 订阅',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'RSS / Atom 地址',
                hintText: 'https://example.com/feed.xml',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                final url = controller.text.trim();
                if (url.isEmpty) return;
                Navigator.pop(ctx);
                _handleSubscription(url);
              },
              child: const Text('添加订阅'),
            ),
          ],
        ),
      ),
    );
  }

  /// 神秘链接 — 哔哩哔哩单集地址
  void _showBilibiliDialog() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('🔮 神秘链接',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: '粘贴链接',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                final url = controller.text.trim();
                if (url.isEmpty) return;
                Navigator.pop(ctx);
                if (url.contains('bilibili.com') || url.contains('b23.tv')) {
                  _handleBilibiliPlay(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('无法识别该链接')),
                  );
                }
              },
              child: const Text('解析'),
            ),
          ],
        ),
      ),
    );
  }

  /// 播放B站单集视频
  Future<void> _handleBilibiliPlay(String url) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('正在解析…')));

    try {
      final parser = BilibiliParserService();
      final info = await parser.parse(url);

      if (info.videoUrl == null) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('解析失败，未找到视频流')));
        }
        return;
      }

      final episode = Episode(
        guid: url,
        title: info.title,
        audioUrl: info.videoUrl,
        imageUrl: info.coverUrl,
        podcastTitle: info.author ?? '哔哩哔哩',
        podcastFeedUrl: url,
        description: info.description,
      );

      ref.read(audioHandlerProvider).playEpisode(episode);
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('解析出错: $e')));
      }
    }
  }

  /// 通用订阅处理
  Future<void> _handleSubscription(String url) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('正在解析订阅地址…')));

    final podcastService = ref.read(podcastServiceProvider);
    final storageService = ref.read(storageServiceProvider);
    final podcast = await podcastService.fetchPodcastMetadata(url);

    if (podcast != null) {
      await storageService.subscribe(podcast);
      _refreshShelf();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('订阅成功: ${podcast.title}')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('无法解析该地址，请检查格式是否正确')));
      }
    }
  }

  /// 导出 OPML
  Future<void> _exportOpml() async {
    final storage = ref.read(storageServiceProvider);
    final opmlContent = await storage.exportToOpml();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/echopod_subs.opml');
    await file.writeAsString(opmlContent);
    await Share.shareXFiles([XFile(file.path)], text: '我的 EchoPod 订阅列表 (OPML)');
  }

  /// 导入 OPML — 粘贴 OPML 内容
  void _showImportOpmlDialog() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('导入 OPML',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: '粘贴 OPML 文件内容…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                final content = controller.text.trim();
                if (content.isEmpty) return;
                Navigator.pop(ctx);
                _importOpmlContent(content);
              },
              child: const Text('导入'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importOpmlContent(String content) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('正在导入…')));

    try {
      // 解析 OPML 中的 xmlUrl
      final urlPattern = RegExp(r'xmlUrl="([^"]+)"', caseSensitive: false);
      final matches = urlPattern.allMatches(content);
      final urls = matches.map((m) => m.group(1)!).toList();

      if (urls.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('未在 OPML 中找到订阅源')));
        }
        return;
      }

      final podcastService = ref.read(podcastServiceProvider);
      final storageService = ref.read(storageServiceProvider);
      int success = 0;

      for (final url in urls) {
        try {
          final podcast = await podcastService.fetchPodcastMetadata(url);
          if (podcast != null) {
            await storageService.subscribe(podcast);
            success++;
          }
        } catch (_) {}
      }

      _refreshShelf();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('导入完成: $success/${urls.length} 个订阅')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('导入失败: $e')));
      }
    }
  }

  /// FreshRSS 登录
  Future<void> _handleFreshRssLogin() async {
    final url = _urlController.text.trim();
    final user = _userController.text.trim();
    final pass = _passController.text.trim();

    if (url.isEmpty || user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请填写完整信息')));
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('正在连接…')));

    try {
      final service = ref.read(freshrssServiceProvider);
      service.configure(url, user, pass);
      final success = await service.login();

      if (success) {
        await ref
            .read(storageServiceProvider)
            .saveFreshRssConfig(url, user, pass);
        _refreshShelf();
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('登录成功！')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('登录失败，请检查配置')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('连接出错: $e')));
      }
    }
  }

  void _showFreshRssSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('FreshRSS 连接',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'FreshRSS 地址',
                hintText: 'https://freshrss.example.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(
                labelText: 'API 密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _handleFreshRssLogin();
              },
              child: const Text('连接并同步'),
            ),
            if (_urlController.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _handleClearFreshRssConfig();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('清除登录信息'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleClearFreshRssConfig() async {
    final storage = ref.read(storageServiceProvider);
    await storage.clearFreshRssConfig();
    setState(() {
      _urlController.clear();
      _userController.clear();
      _passController.clear();
    });
    _refreshShelf();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('FreshRSS 登录信息已清除')),
      );
    }
  }

  // ── UI 构建 ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('订阅管理'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // RSS 地址订阅
          _buildCard(
            color: const Color(0xFF4A7C59), // 竹绿
            icon: Icons.rss_feed_rounded,
            title: 'RSS 订阅',
            subtitle: '输入 RSS/Atom 地址直接订阅',
            onTap: _showAddRssDialog,
          ),
          const SizedBox(height: 14),

          // OPML 导入/导出
          Row(
            children: [
              Expanded(
                child: _buildCard(
                  color: const Color(0xFF8A6BBE), // 紫藤
                  icon: Icons.file_download_rounded,
                  title: 'OPML 导入',
                  subtitle: '从其他应用迁移',
                  onTap: _showImportOpmlDialog,
                  compact: true,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildCard(
                  color: const Color(0xFFE35D6A), // 朱红
                  icon: Icons.file_upload_rounded,
                  title: 'OPML 导出',
                  subtitle: '分享订阅列表',
                  onTap: _exportOpml,
                  compact: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // FreshRSS
          _buildCard(
            color: const Color(0xFF2C7BB6), // 蔚蓝
            icon: Icons.cloud_sync_rounded,
            title: 'FreshRSS',
            subtitle: '连接自部署 FreshRSS 服务端同步订阅',
            onTap: _showFreshRssSheet,
          ),
          const SizedBox(height: 14),

          // 神秘链接
          _buildCard(
            color: const Color(0xFF1D1D1F), // 墨黑
            icon: Icons.auto_awesome_rounded,
            title: '神秘链接',
            subtitle: '你知道的…空间地址',
            onTap: _showBilibiliDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool compact = false,
  }) {
    final height = compact ? 130.0 : 100.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
