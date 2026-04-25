import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? customTitle;
  final Color? appBarColor;
  final Color? appBarTitleColor;

  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.customTitle,
    this.appBarColor,
    this.appBarTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor =
        appBarTitleColor ??
        Theme.of(context).appBarTheme.titleTextStyle?.color ??
        AppTheme.appNameColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            appBarColor ?? Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: SvgPicture.asset(
                'assets/images/easible_logo.svg',
                colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child:
                    customTitle ??
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).appBarTheme.titleTextStyle?.copyWith(color: titleColor),
                    ),
              ),
            ),
          ],
        ),
        actions: actions,
      ),

      // ✅ NO AUTO SCROLL HERE
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
