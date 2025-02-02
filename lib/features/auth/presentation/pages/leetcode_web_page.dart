import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/utils/app_constants.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:codersgym/features/common/widgets/app_webview.dart';

@RoutePage()
class LeetcodeWebPage extends StatelessWidget {
  const LeetcodeWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWebview(
      url: LeetcodeConstants.leetcodeLoginUrl,
      appBarTitle: Text("Leetcode Login"),
      redirectUrl: LeetcodeConstants.leetcodePostLoginUrl,
      onUrlRedirection: () async {
        final cookieManager = CookieManager.instance();
        final leetcodeCookies = await cookieManager.getCookies(
            url: WebUri(LeetcodeConstants.leetcodeUrl));
        final cookiesMap = {
          for (var element in leetcodeCookies) element.name: element.value
        };
        final expiryDate = leetcodeCookies
            .firstWhereOrNull(
              (element) => element.name == "LEETCODE_SESSION",
            )
            ?.expiresDate;
        if (expiryDate != null) cookiesMap['expiry'] = expiryDate;
        if (context.mounted) {
          AutoRouter.of(context).maybePop(cookiesMap);
        }
      },
    );
  }
}
