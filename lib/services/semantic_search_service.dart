class SemanticSearchService {
  // In a production app, this would query a Vector Database (like Chroma or Pinecone)
  // that contains the indexed transcripts of the podcasts.
  
  Future<List<SearchResult>> searchContent(String query) async {
    // Mocking semantic results
    await Future.delayed(const Duration(seconds: 1));
    
    if (query.contains('Flutter') || query.contains('渲染')) {
      return [
        SearchResult(
          episodeTitle: '深入浅出 Flutter 渲染原理',
          podcastTitle: '技术大咖谈',
          timestamp: '15:42',
          snippet: '...关于 Flutter 的三棵树渲染逻辑，其实核心在于 LayerTree 的构建和合成...',
        ),
        SearchResult(
          episodeTitle: '跨端开发的未来趋势',
          podcastTitle: '代码重构',
          timestamp: '08:10',
          snippet: '...我们看到 Flutter 在 3.0 版本后对 CanvasKit 的优化非常明显，尤其是...',
        ),
      ];
    }
    
    return [];
  }
}

class SearchResult {
  final String episodeTitle;
  final String podcastTitle;
  final String timestamp;
  final String snippet;

  SearchResult({
    required this.episodeTitle,
    required this.podcastTitle,
    required this.timestamp,
    required this.snippet,
  });
}
