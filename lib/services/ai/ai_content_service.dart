import 'package:openai_dart/openai_dart.dart';

class AIContentService {
  final String apiKey;
  late final OpenAIClient _client;

  AIContentService({required this.apiKey}) {
    _client = OpenAIClient(apiKey: apiKey);
  }

  // Generate a summary for the episode
  Future<String> getEpisodeSummary(String title, String description) async {
    if (apiKey.isEmpty) {
      return "这是来自 EchoPod AI 的模拟摘要：本期节目深入探讨了中文播客市场的现状，重点分析了用户听众的增长趋势以及内容创作者面临的挑战。主播们认为，垂直领域的深度内容将是未来的爆发点。";
    }

    try {
      final response = await _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            ChatCompletionMessage.system(
              content: '你是一个专业的播客文案助手。请根据提供的播客标题和描述，生成一份简洁、抓人眼球的中文摘要（150字以内）。',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.parts([
                ChatCompletionMessageContentPart.text(text: '标题: $title\n描述: $description'),
              ]),
            ),
          ],
        ),
      );
      return response.choices.first.message.content ?? "暂无摘要";
    } catch (e) {
      return "摘要生成失败: $e";
    }
  }

  // Answer questions about the episode (Mocked with context for now)
  Future<String> askEpisodeQuestion(String question, String context) async {
    if (apiKey.isEmpty) {
      return "这是一个模拟回答：关于您提到的‘$question’，播客中提到这通常是由于市场准入门槛降低导致的，建议关注具体的合规性要求。";
    }

    try {
      final response = await _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            ChatCompletionMessage.system(
              content: '你是一个播客智能助手。用户正在听一期播客，请根据播客的背景信息回答他们的问题。如果信息不足，请委婉说明。',
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.parts([
                ChatCompletionMessageContentPart.text(text: '播客背景: $context\n用户问题: $question'),
              ]),
            ),
          ],
        ),
      );
      return response.choices.first.message.content ?? "AI 暂时无法回答这个问题";
    } catch (e) {
      return "AI 响应异常: $e";
    }
  }
}
