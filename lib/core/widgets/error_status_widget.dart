import 'package:flutter/material.dart';

class ErrorStatusWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorStatusWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.error,
              // Add semantic label specifically for error icon
              semanticLabel: 'Error icon',
            ),
            const SizedBox(height: 16),
            Text(
              '出错了',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            // Use builder concept for friendly message transformation
            Builder(
              builder: (context) {
                final displayMessage = _friendlyErrorMessage(message);
                return Text(
                  displayMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                );
              },
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded),
                    SizedBox(width: 8),
                    Text('重试'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _friendlyErrorMessage(String error) {
    if (error.contains('SocketException') ||
        error.contains('Failed host lookup') ||
        error.contains('Connection refused') ||
        error.contains('connection error')) {
      return '网络连接似乎出现了问题，请检查您的网络设置。';
    }
    if (error.contains('TimeoutException')) {
      return '连接超时，请稍后重试。';
    }
    // Return original error if no friendly mapping found, but maybe truncate if too long
    if (error.length > 200) {
      return '${error.substring(0, 200)}...';
    }
    return error;
  }
}
