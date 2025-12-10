import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 12),
          Text('Loading...', style: TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}
