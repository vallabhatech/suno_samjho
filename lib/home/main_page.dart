import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../profile/profile_page.dart';
import '../chatbot/chatbot_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.userName = 'Name'});
  final String userName;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Target health percent (0.0 - 1.0)
  final double _targetHealth = 0.72;
  // Example total time spent string
  final String _totalTime = '12h 30m';
  // theme state for light / dark toggle
  bool _isDark = false;

  ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4A90E2),
    scaffoldBackgroundColor: const Color(0xFFF7FAFF),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF4A90E2),
    ),
  );

  ThemeData get _darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1E88E5),
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(secondary: const Color(0xFF1E88E5)),
  );

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 600;
    final horizontalPadding = isSmall ? 16.0 : 32.0;
    final textScale = isSmall ? 1.0 : 1.1;

    final theme = _isDark ? _darkTheme : _lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        // soft gradient background for comfortable UX
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _isDark
                  ? [Color(0xFF0D1117), Color(0xFF071019)]
                  : [Color(0xFFF7FAFF), Color(0xFFFFFFFF)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: greeting + small subtitle + avatar
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good day 👋',
                              style: TextStyle(
                                color:
                                    theme.textTheme.bodySmall?.color ??
                                    Colors.grey[600],
                                fontSize: 14 * textScale,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  'Hi, ',
                                  style: TextStyle(
                                    fontSize: 18 * textScale,
                                    color:
                                        theme.textTheme.bodyMedium?.color ??
                                        Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  widget.userName,
                                  style: TextStyle(
                                    fontSize: 20 * textScale,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        theme.textTheme.bodyLarge?.color ??
                                        Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Light / Dark toggle placed left of the avatar
                      IconButton(
                        tooltip: _isDark ? 'Switch to light' : 'Switch to dark',
                        icon: Icon(
                          _isDark
                              ? Icons.wb_sunny_outlined
                              : Icons.nightlight_round,
                        ),
                        color: theme.primaryColor,
                        onPressed: () => setState(() => _isDark = !_isDark),
                      ),
                      const SizedBox(width: 6),
                      // Avatar with border (keeps navigation)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(isSmall ? 4 : 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF4A90E2),
                              width: isSmall ? 3 : 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF4A90E2).withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: isSmall ? 26 : 32,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: _buildProfileImage(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Cards row: health, sessions, time
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildStatCard(
                        context,
                        'Health',
                        '${(_targetHealth * 100).toStringAsFixed(0)}%',
                        Icons.favorite,
                        Colors.pinkAccent,
                        isSmall,
                      ),
                      _buildStatCard(
                        context,
                        'Sessions',
                        '24',
                        Icons.schedule,
                        Colors.orangeAccent,
                        isSmall,
                      ),
                      _buildStatCard(
                        context,
                        'Avg Time',
                        '30m',
                        Icons.timer,
                        Colors.teal,
                        isSmall,
                      ),
                      _buildStatCard(
                        context,
                        'Total Time',
                        _totalTime,
                        Icons.history,
                        Colors.indigo,
                        isSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Large card with a visual progress and CTA
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isSmall ? 14 : 18),
                    decoration: BoxDecoration(
                      color: _isDark ? const Color(0xFF0F1720) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: _isDark
                              ? Colors.black.withOpacity(0.6)
                              : Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Progress',
                          style: TextStyle(
                            fontSize: 16 * textScale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: _targetHealth),
                          duration: const Duration(milliseconds: 900),
                          builder: (context, value, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: value,
                                  minHeight: isSmall ? 10 : 14,
                                  backgroundColor: Colors.grey[200],
                                  color: Colors.greenAccent.shade700,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${(value * 100).toStringAsFixed(0)}% of goal',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.primaryColor,
                                      ),
                                      child: const Text(
                                        'Continue',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // CTA at bottom
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ChatbotPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isSmall ? 14 : 16,
                        ),
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'TALK TO SAMJHO',
                        style: TextStyle(
                          fontSize: isSmall ? 16 : 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // helper to build profile image; change to SvgPicture.asset(...) if using svg
  Widget _buildProfileImage() {
    // prefer SVG if you have assets/profile.svg
    try {
      return SvgPicture.asset('assets/profile.svg', fit: BoxFit.cover);
    } catch (_) {
      // fallback to network/avatar
      return Image.network('https://placehold.co/200x200', fit: BoxFit.cover);
    }
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    bool isSmall,
  ) {
    final width =
        (MediaQuery.of(context).size.width - (isSmall ? 32 : 64) - 12) /
        (isSmall ? 2 : 4);
    final theme = Theme.of(context);
    final cardColor = _isDark ? const Color(0xFF0F1720) : theme.cardColor;
    final shadowColor = _isDark
        ? Colors.black.withOpacity(0.45)
        : Colors.black.withOpacity(0.03);
    final titleColor = _isDark
        ? Colors.white70
        : (theme.textTheme.bodySmall?.color ?? Colors.grey[700]);
    final valueColor = _isDark
        ? Colors.white
        : (theme.textTheme.bodyLarge?.color ?? Colors.black87);
    final iconBg = _isDark ? color.withOpacity(0.22) : color.withOpacity(0.12);

    return Container(
      width: isSmall ? width : 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmall ? 12 : 13,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmall ? 14 : 16,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
