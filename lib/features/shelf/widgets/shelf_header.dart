import 'package:flutter/material.dart';

class ShelfHeader extends StatelessWidget {
  final String title;
  final String moreText;
  final VoidCallback? onMorePressed;

  const ShelfHeader({
    super.key,
    required this.title,
    this.moreText = '查看更多',
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onMorePressed != null)
              TextButton.icon(
                onPressed: onMorePressed,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: Text(moreText),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
