import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UpNextCard extends StatelessWidget {
  const UpNextCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Up Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Evening Focus',
                  style: TextStyle(
                    color: AppColors.accentPurple,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 220, // Aspect ratio approx from wireframe
          decoration: BoxDecoration(
            color: AppColors.cardForest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image with Gradient
              Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDDeQAsZknPjXtiKsTY8VWHBbswWWoy9p8P-2sDVv2vDVdiw_IwzwkZsuqJWdu8c3V0OXw-zS8sI7X6IqkKN8g2NSbpAsL5Rov_pBWXTiKHTHI-NJBs-it-RnMc4aq-9iOXOXj9G5msIkcSdri6U7Htbl5WcOfNor4n22tI0hAiK-qI-ZVdvv2-mWa7RHsQwaosBTTyXPDbsoLMUBRNfJf1FvNaPs6pZ3XvwJgPazI4K8XSXqgzTPC4QDEeglh-uXczZBn-VISEvtg',
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(color: AppColors.cardForest),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      AppColors.cardForest.withValues(alpha: 0.9),
                    ],
                    stops: const [0.3, 0.9],
                  ),
                ),
              ),
              
              // Content Overlay
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EVENING STACK',
                      style: TextStyle(
                        color: AppColors.accentPurple,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Night Recovery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.schedule, color: Color(0xFF9DB9A8), size: 14),
                        SizedBox(width: 4),
                        Text(
                          '8:00 PM • 3 Supplements',
                          style: TextStyle(
                            color: Color(0xFF9DB9A8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.done_all, size: 20),
                        label: const Text('Mark all as Taken'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brightGreen,
                          foregroundColor: const Color(0xFF111814),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: AppColors.brightGreen.withValues(alpha: 0.3),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
