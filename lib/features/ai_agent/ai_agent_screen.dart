import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/episode.dart';
import '../../core/providers/providers.dart';

class AIAgentScreen extends ConsumerStatefulWidget {
  final Episode episode;
  const AIAgentScreen({super.key, required this.episode});

  @override
  ConsumerState<AIAgentScreen> createState() => _AIAgentScreenState();
}

class _AIAgentScreenState extends ConsumerState<AIAgentScreen> {
  final _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add({
      'role': 'ai',
      'text':
          '你好！我是 EchoPod AI 助手。关于这期《${widget.episode.title}》，你想了解什么？你可以问我关键观点、提到的书籍或者嘉宾信息。'
    });
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty || _isLoading) return;

    final question = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'text': question});
      _controller.clear();
      _isLoading = true;
    });

    final aiService = ref.read(aiServiceProvider);
    final response = await aiService.askEpisodeQuestion(
      question,
      widget.episode.description ?? widget.episode.title,
    );

    if (mounted) {
      setState(() {
        _messages.add({'role': 'ai', 'text': response});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 助手'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.indigo : Colors.grey[800],
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isUser
                            ? const Radius.circular(0)
                            : const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(0),
                      ),
                    ),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    child: Text(
                      msg['text']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: '问问 AI 关于这期节目...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.indigoAccent),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
