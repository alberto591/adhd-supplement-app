import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../../application/view_models/privacy_view_model.dart';
import '../../config/locator.dart';
import '../../infrastructure/services/url_service.dart';
import '../../config/app_config.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  static Widget withProvider() {
    return ChangeNotifierProvider(
      create: (_) => PrivacyViewModel(),
      child: const PrivacySettingsScreen(),
    );
  }

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryBlue = Color(0xFF2B6CEE);
    const bgLight = Color(0xFFF6F6F8);
    const bgDark = Color(0xFF101622);

    return Scaffold(
      backgroundColor: isDark ? bgDark : bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1C222E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : const Color(0xFF111318),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.privacySecurity,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111318),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? const Color(0xFF2D3648) : const Color(0xFFE5E7EB),
            height: 1,
          ),
        ),
      ),
      body: Consumer<PrivacyViewModel>(builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: primaryBlue));
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildSectionHeader(
                  AppLocalizations.of(context)!.yourActivityData, isDark),
              _buildSettingsContainer(
                context,
                children: [
                  _buildToggleTile(
                    context,
                    title: AppLocalizations.of(context)!.localStorageOnly,
                    subtitle:
                        AppLocalizations.of(context)!.localStorageOnlyDesc,
                    value: viewModel.localStorageOnly,
                    showInfoIcon: true,
                    onChanged: (val) => viewModel.setLocalStorageOnly(val),
                    isFirst: true,
                  ),
                  _buildToggleTile(
                    context,
                    title: AppLocalizations.of(context)!.shareAnalytics,
                    subtitle: AppLocalizations.of(context)!.shareAnalyticsDesc,
                    value: viewModel.analyticsEnabled,
                    onChanged: (val) => viewModel.setAnalyticsEnabled(val),
                  ),
                  _buildToggleTile(
                    context,
                    title: AppLocalizations.of(context)!.crashReporting,
                    subtitle: AppLocalizations.of(context)!.crashReportingDesc,
                    value: viewModel.crashReportingEnabled,
                    onChanged: (val) => viewModel.setCrashReportingEnabled(val),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.download,
                    iconColor: primaryBlue,
                    title: AppLocalizations.of(context)!.downloadMyData,
                    subtitle: AppLocalizations.of(context)!.downloadMyDataDesc,
                    onTap: () async {
                      await viewModel.downloadData();
                      if (!context.mounted) return;
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .dataExportGenerated)));
                    },
                    isLast: true,
                  ),
                ],
              ),

              // Secure Access Section (Hidden for v1.0 - pending local_auth)
              // _buildSectionHeader('Secure Access', isDark),
              // _buildSettingsContainer(
              //   context,
              //   children: [
              //     _buildToggleTile(
              //       context,
              //       title: 'Biometric Lock',
              //       subtitle: 'Require FaceID or TouchID',
              //       value: viewModel.biometricLockEnabled,
              //       onChanged: (val) => viewModel.setBiometricLockEnabled(val),
              //       icon: Icons.fingerprint,
              //       iconColor: primaryBlue,
              //       isFirst: true,
              //       isLast: true,
              //     ),
              //   ],
              // ),

              // Data Control Section
              _buildSectionHeader(
                  AppLocalizations.of(context)!.dataControl, isDark),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C222E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dataControlDesc,
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF616F89),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .clearHistoryTitle),
                                    content: Text(AppLocalizations.of(context)!
                                        .clearHistoryConfirm),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(ctx);
                                          await viewModel.clearAllHealthData();
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(AppLocalizations
                                                          .of(context)!
                                                      .healthHistoryCleared)));
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .clear
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.red)),
                                      ),
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.history_toggle_off,
                            color: Color(0xFFDC2626)),
                        label: Text(
                          AppLocalizations.of(context)!.clearHistory,
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor:
                              const Color(0xFFDC2626).withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .deleteAccount),
                                    content: Text(AppLocalizations.of(context)!
                                        .deleteAccountConfirm),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(ctx);
                                          await viewModel.deleteAccount();
                                          if (!context.mounted) return;
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/login',
                                              (route) => false);
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .deleteAccount
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.red)),
                                      ),
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.delete_forever,
                            color: Color(0xFFDC2626)),
                        label: Text(
                          AppLocalizations.of(context)!.deleteAccount,
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFFFEE2E2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActionTile(
                      context,
                      icon: Icons.alternate_email,
                      iconColor: const Color(0xFFEE8C2B),
                      title: AppLocalizations.of(context)!.requestDataRemoval,
                      subtitle:
                          AppLocalizations.of(context)!.requestDataRemovalDesc,
                      onTap: () => locator<UrlService>()
                          .launchUri(AppConfig.dataDeletionUrl),
                    ),
                  ],
                ),
              ),

              // Footer
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_user, color: primaryBlue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.privacyPriority,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF616F89),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () => _showPrivacyPolicyDialog(context),
                  child: Text.rich(
                    TextSpan(
                      text:
                          '${AppLocalizations.of(context)!.encryptionNotice} ',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF616F89),
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .tapToReadPrivacyPolicy,
                          style: const TextStyle(
                            color: primaryBlue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => locator<UrlService>()
                                .launchUri(AppConfig.privacyPolicyUrl),
                        ),
                        const TextSpan(text: '\n\n'),
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .requestAccountDeletion,
                          style: const TextStyle(
                            color: primaryBlue,
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => locator<UrlService>()
                                .launchUri(AppConfig.dataDeletionUrl),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111318),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(BuildContext context,
      {required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C222E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showInfoIcon = false,
    IconData? icon,
    Color? iconColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF2D3648)
                      : const Color(0xFFF0F2F4),
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor?.withValues(alpha: 0.1) ??
                    Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor ?? Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111318),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (showInfoIcon) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF616F89),
                      ),
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF616F89),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF2B6CEE),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(
                  bottom: BorderSide(
                    color: isDark
                        ? const Color(0xFF2D3648)
                        : const Color(0xFFF0F2F4),
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111318),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF616F89),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF616F89),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.privacyPolicy),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPolicySection(
                    AppLocalizations.of(context)!.policyCollectionTitle,
                    AppLocalizations.of(context)!.policyCollectionContent),
                _buildPolicySection(
                    AppLocalizations.of(context)!.policyUsageTitle,
                    AppLocalizations.of(context)!.policyUsageContent),
                _buildPolicySection(
                    AppLocalizations.of(context)!.policySecurityTitle,
                    AppLocalizations.of(context)!.policySecurityContent),
                _buildPolicySection(
                    AppLocalizations.of(context)!.policyRightsTitle,
                    AppLocalizations.of(context)!.policyRightsContent),
                _buildPolicySection(
                    AppLocalizations.of(context)!.policyUpdatesTitle,
                    AppLocalizations.of(context)!.policyUpdatesContent),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.lastUpdated,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
