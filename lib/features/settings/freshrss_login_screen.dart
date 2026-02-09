import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';

class FreshRssLoginScreen extends ConsumerStatefulWidget {
  const FreshRssLoginScreen({super.key});

  @override
  ConsumerState<FreshRssLoginScreen> createState() => _FreshRssLoginScreenState();
}

class _FreshRssLoginScreenState extends ConsumerState<FreshRssLoginScreen> {
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final storage = ref.read(storageServiceProvider);
    final config = await storage.getFreshRssConfig();
    setState(() {
      _urlController.text = config['url'] ?? '';
      _userController.text = config['user'] ?? '';
      _passController.text = config['pass'] ?? '';
    });
  }

  Future<void> _handleLogin() async {
    final url = _urlController.text.trim();
    final user = _userController.text.trim();
    final pass = _passController.text.trim();

    if (url.isEmpty || user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写完整信息')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(freshrssServiceProvider);
      service.configure(url, user, pass);
      final success = await service.login();

      if (success) {
        await ref.read(storageServiceProvider).saveFreshRssConfig(url, user, pass);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('登录成功！')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('登录失败，请检查配置')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FreshRSS 登录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'FreshRSS 地址',
                hintText: 'https://freshrss.example.com',
              ),
              keyboardType: TextInputType.url,
            ),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: '用户名'),
            ),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'API 密码'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('连接并同步'),
                  ),
          ],
        ),
      ),
    );
  }
}
