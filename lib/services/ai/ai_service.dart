import 'package:openai_dart/openai_dart.dart';

class AIService {
  final String? apiKey;
  
  AIService({this.apiKey});

  Future<String> summarizeEpisode(String title, String description) async {
    if (apiKey == null || apiKey == '' || apiKey == 'YOUR_OPENAI_API_KEY') {
      // Mock implementation
      await Future.delayed(const Duration(seconds: 2));
      return "这是对播客《$title》的 AI 生成总结：\n\n本期节目主要探讨了如何利用人工智能技术提升生活效率。嘉宾分享了他们在开发 EchoPod 过程中的心得体会，并展望了未来音频内容的消费趋势。关键词：AI, 播客, 效率, 创新。\n\n(注意：这是模拟生成的总结，因为未检测到有效的 OpenAI API Key)";
    }

    final client = OpenAIClient(apiKey: apiKey!);
    try {
      final res = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o-mini'),
          messages: [
            ChatCompletionMessage.system(
              content: '你是一个专业的播客内容总结助手。请根据提供的播客标题和描述，生成一段精炼、吸引人的中文总结。',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.parts([
                ChatCompletionMessageContentPart.text(text: '标题: $title\n描述: $description'),
              ]),
            ),
          ],
        ),
      );
      return res.choices.first.message.content ?? '无法生成总结。';
    } catch (e) {
      return '生成 AI 总结时出错: $e';
    }
  }
}
