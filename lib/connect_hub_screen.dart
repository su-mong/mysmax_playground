import 'package:flutter/material.dart';
import 'package:mysmax_playground/app_text_styles.dart';
import 'package:mysmax_playground/colors.dart';
import 'package:mysmax_playground/core/app_widgets.dart';

class ConnectHubScreen extends StatefulWidget {
  final bool isFirst;
  const ConnectHubScreen({Key? key, this.isFirst = true}) : super(key: key);

  @override
  State<ConnectHubScreen> createState() => _ConnectHubScreenState();
}

class _ConnectHubScreenState extends State<ConnectHubScreen> {
  @override
  Widget build(BuildContext context) {
    return AppWidgets.scaffold(
      backgroundColor: const Color(0xffF8F9FD),
      body: Column(
        children: [
          const Spacer(),
          Text(
            '허브 연결',
            style: AppTextStyles.size27Bold.singleLine,
          ),
          const SizedBox(height: 15),
          Image.asset('assets/images/hub_image.png'),
          const SizedBox(height: 95),
          TextButton(
            onPressed: () {},
            child: Text('검색하기'),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.blue,
              textStyle: AppTextStyles.size16Medium,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.deactivateColor,
              disabledForegroundColor: AppColors.deactivateTextColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              textStyle: AppTextStyles.size14Regular.singleLine.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
            child: const Text(
              '직접 연결하기',
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
