import 'package:flutter/material.dart';

class FeatureComingSoonPage extends StatelessWidget {
  const FeatureComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // hoặc theme.backgroundColor
      appBar: AppBar(
        title: const Text('Coming Soon'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon hoặc hình ảnh minh họa
              Icon(
                Icons.construction,
                size: 120,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 24),
              // Tiêu đề
              const Text(
                'Feature Coming Soon!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Mô tả
              const Text(
                'We are working hard to bring this feature to you. Stay tuned!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Button quay lại
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
