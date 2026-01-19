import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DeveloperHandoffLogicTriggersScreen extends StatelessWidget {
  const DeveloperHandoffLogicTriggersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine theme brightness and colors
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Detailed colors from design
    const Color primaryColor = Color(0xFF135bec);
    const Color bgLight = Color(0xFFf6f6f8);
    const Color bgDark = Color(0xFF101622);
    const Color cardDark = Color(0xFF161d2b);
    const Color cardBorderDark = Color(0xFF232d3f);
    const Color textGray900 = Color(0xFF111827);
    const Color textWhite = Colors.white;
    const Color textGray500 = Color(0xFF6B7280);
    const Color textGray400 = Color(0xFF9CA3AF);

    final Color bgColor = isDark ? bgDark : bgLight;
    final Color cardBgColor = isDark ? cardDark : Colors.white;
    final Color borderColor = isDark ? cardBorderDark : Colors.grey.shade200;
    final Color mainTextColor = isDark ? textWhite : textGray900;
    final Color subTextColor = isDark ? textGray400 : textGray500;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation
            Container(
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.95),
                border: Border(
                    bottom: BorderSide(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavButton(
                      context: context,
                      icon: Icons.arrow_back,
                      isDark: isDark,
                      onTap: () => Navigator.pop(context)),
                  Text(
                    'Logic & Triggers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                    ),
                  ),
                  _buildNavButton(
                      context: context,
                      icon: Icons.ios_share,
                      isDark: isDark,
                      isPrimary: true,
                      onTap: () {}),
                ],
              ),
            ),

            // Header Meta Info
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'BLUEPRINT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'UPDATED 2H AGO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Backend Spec v1.0',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Implementation details for Antigravity core loops.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9da6b9),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flowchart Visual
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: cardDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isDark
                                  ? cardBorderDark
                                  : Colors.grey.shade200),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuB8z57ZseAAzDUxI3rgqpNkomtXy31AB5Chp-fxjKd-TSd9UKoSQqxf4rXBQWcahM5TblJ2fSLhKnKqE5Vsb_u2dbl5DrAaDnosUIDF_ow_FO_t-WJdS1dCQH08Yq0ulQ2M-aQ24sq_uc6DjTjX_FUlF6kiJCv9LPwPOUuiN_MOInK7uuYMO9DeO_dV9SCkwSCeSKcGaux-7uJbJHUV9PGNrKZZJHZfxwdjKu-FW3i4UKcsvn6jp4FSWtJww5VhMaXqv5S1TaxcubA'),
                            fit: BoxFit.cover,
                            opacity: 0.7,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Overlay simulation
                            const Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Color(0xCC101622),
                                      Colors.transparent
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Content overlay
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildNodeIcon(Icons.smartphone),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 12),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Divider(
                                                  color: primaryColor
                                                      .withValues(alpha: 0.5),
                                                  thickness:
                                                      2), // Dashed line simulation
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text('HTTPS',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      _buildNodeIcon(Icons.dns,
                                          isServer: true,
                                          primaryColor: primaryColor),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('System Status: Operational',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                              fontFamily: 'monospace')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Logic Lists Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Text(
                        'CORE STATE TRIGGERS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: subTextColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildLogicCard(
                            isDark: isDark,
                            cardBgColor: cardBgColor,
                            borderColor: borderColor,
                            mainTextColor: mainTextColor,
                            subTextColor: subTextColor,
                            icon: Icons.notifications_active,
                            iconColor: primaryColor,
                            iconBg: primaryColor.withValues(alpha: 0.1),
                            title: 'Nudge Logic',
                            status: 'LIVE',
                            statusColor: Colors.green,
                            code: 'if (user.inactive > 5m)',
                            codeColor: primaryColor,
                            description:
                                'Trigger push notification. Repeat loop every 5m if ignored.',
                          ),
                          const SizedBox(height: 12),
                          _buildLogicCard(
                            isDark: isDark,
                            cardBgColor: cardBgColor,
                            borderColor: borderColor,
                            mainTextColor: mainTextColor,
                            subTextColor: subTextColor,
                            icon: Icons.health_and_safety,
                            iconColor: Colors.pinkAccent,
                            iconBg: Colors.pinkAccent.withValues(alpha: 0.1),
                            title: 'Safety Trigger',
                            status: 'WIP',
                            statusColor: Colors.amber,
                            code: 'await checkInteractions()',
                            codeColor: Colors.pinkAccent,
                            description:
                                'On intake, cross-reference current meds via FDA API.',
                          ),
                          const SizedBox(height: 12),
                          _buildLogicCard(
                            isDark: isDark,
                            cardBgColor: cardBgColor,
                            borderColor: borderColor,
                            mainTextColor: mainTextColor,
                            subTextColor: subTextColor,
                            icon: Icons.military_tech,
                            iconColor: Colors.indigo,
                            iconBg: Colors.indigo.withValues(alpha: 0.1),
                            title: 'XP Logic',
                            status: 'LIVE',
                            statusColor: Colors.green,
                            code: 'user.xp += 10',
                            codeColor: Colors.indigo,
                            description:
                                'Commit +10XP transaction upon verified completion.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Technical Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0c1018) : Colors.grey.shade100,
                border: Border(
                    top: BorderSide(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings_ethernet,
                          color: subTextColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Data Sync Specs',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: mainTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildSpecCard(
                              isDark,
                              cardBgColor,
                              borderColor,
                              subTextColor,
                              mainTextColor,
                              'FREQUENCY',
                              Icons.sync,
                              primaryColor,
                              'Real-time',
                              'via WebSocket')),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildSpecCard(
                              isDark,
                              cardBgColor,
                              borderColor,
                              subTextColor,
                              mainTextColor,
                              'FALLBACK',
                              Icons.timer,
                              Colors.orange,
                              '30s Poll',
                              'REST API')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SHA: 8a2f9c',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: subTextColor)),
                      Text('Env: Production',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: subTextColor)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required bool isDark,
    required Function() onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isPrimary
              ? AppColors.primary
              : (isDark ? Colors.white : Colors.black87),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildNodeIcon(IconData icon,
      {bool isServer = false, Color? primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isServer ? primaryColor!.withValues(alpha: 0.9) : Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
        boxShadow: isServer
            ? [BoxShadow(color: primaryColor!.withValues(alpha: 0.5), blurRadius: 15)]
            : null,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildLogicCard({
    required bool isDark,
    required Color cardBgColor,
    required Color borderColor,
    required Color mainTextColor,
    required Color subTextColor,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String status,
    required Color statusColor,
    required String code,
    required Color codeColor,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: mainTextColor)),
                    Row(
                      children: [
                        Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                                color: statusColor, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text(status,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: subTextColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(code,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: codeColor.withValues(alpha: 0.8))),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                        fontSize: 14, color: subTextColor, height: 1.2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard(
      bool isDark,
      Color cardBg,
      Color borderColor,
      Color subText,
      Color mainText,
      String label,
      IconData icon,
      Color iconColor,
      String value,
      String subValue) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.bold, color: subText)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: mainText)),
            ],
          ),
          const SizedBox(height: 4),
          Text(subValue, style: TextStyle(fontSize: 10, color: subText)),
        ],
      ),
    );
  }
}
