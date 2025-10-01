import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/translations.dart';
import 'login_page.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';

class PoultryDashboardPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  final String userName;
  final String farmSizeWithUnit;

  const PoultryDashboardPage({
    super.key,
    required this.onLocaleChange,
    required this.userName,
    required this.farmSizeWithUnit,
  });

  @override
  State<PoultryDashboardPage> createState() => _PoultryDashboardPageState();
}

class _PoultryDashboardPageState extends State<PoultryDashboardPage> {
  late String _currentLang;

  final Map<String, String> _languages = {
    "en": "English",
    "hi": "हिंदी",
    "pa": "ਪੰਜਾਬੀ",
    "ta": "தமிழ்",
    "as": "অসমীয়া",
    "bn": "বাংলা",
    "mr": "मराठी",
    "te": "తెలుగు",
    "kn": "ಕನ್ನಡ",
    "ur": "اردو",
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLang = Localizations.localeOf(context).languageCode;
  }

  void _changeLanguage(String langCode) {
    widget.onLocaleChange(Locale(langCode));
    setState(() => _currentLang = langCode);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(onLocaleChange: widget.onLocaleChange),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tiles = [
      {
        "title": getTranslatedText("Risk", _currentLang),
        "icon": Icons.verified_user,
        "colors": [Colors.deepPurple.shade200, Colors.deepPurple.shade400],
      },
      {
        "title": getTranslatedText("Guidelines", _currentLang),
        "icon": Icons.menu_book,
        "colors": [Colors.indigo.shade200, Colors.indigo.shade400],
      },
      {
        "title": getTranslatedText("Compliance", _currentLang),
        "icon": Icons.fact_check,
        "colors": [Colors.teal.shade200, Colors.teal.shade400],
      },
      {
        "title": getTranslatedText("Alerts", _currentLang),
        "icon": Icons.notifications_active,
        "colors": [Colors.purple.shade200, Colors.purple.shade400],
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        languageDropdown: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _currentLang,
            icon: const Icon(Icons.language, color: Colors.blueGrey, size: 28),
            dropdownColor: Colors.white,
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
            items: _languages.entries
                .map((entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) _changeLanguage(value);
            },
          ),
        ),
      ),
      drawer: CustomDrawer(
        userName: widget.userName,
        onLogout: _logout, lang: '',
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFA5D6A7),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // ✅ Translatable Farm Health Summary
                FarmHealthSummaryCard(
                  farmType: "Poultry",
                  biosecurityScore: 90,
                  animalCount: 1200,
                  alerts: 1,
                  lastChecked: "1 day ago",
                  lang: _currentLang,
                ),
                const SizedBox(height: 20),

                // ✅ Grid Dashboard Tiles
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: tiles.length,
                  itemBuilder: (context, index) {
                    final tile = tiles[index];
                    return DashboardTile(
                      title: tile["title"] as String,
                      gradientColors: tile["colors"] as List<Color>,
                      icon: tile["icon"] as IconData,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;

  const DashboardTile({
    required this.title,
    required this.icon,
    required this.gradientColors,
    super.key,
  });

  @override
  State<DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<DashboardTile> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.title} clicked')),
        );
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          shadowColor: widget.gradientColors.last.withOpacity(0.4),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: widget.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 80, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    widget.title.replaceAll(" ", "\n"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black26,
                        )
                      ],
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
}

class FarmHealthSummaryCard extends StatelessWidget {
  final String farmType;
  final int biosecurityScore;
  final int animalCount;
  final int alerts;
  final String lastChecked;
  final String lang;

  const FarmHealthSummaryCard({
    super.key,
    required this.farmType,
    required this.biosecurityScore,
    required this.animalCount,
    required this.alerts,
    required this.lastChecked,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    Color scoreColor = biosecurityScore >= 80
        ? Colors.green
        : biosecurityScore >= 50
            ? Colors.orange
            : Colors.red;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${farmType} ${getTranslatedText("Farm Health Summary", lang)}",
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1, height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${getTranslatedText("Farm Type", lang)}: $farmType Farm",
                    style: GoogleFonts.roboto(fontSize: 16)),
                const Icon(Icons.egg, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getTranslatedText("Biosecurity Score", lang),
                    style: GoogleFonts.roboto(fontSize: 16)),
                Text("$biosecurityScore%",
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: scoreColor)),
              ],
            ),
            const SizedBox(height: 8),
            Text("${getTranslatedText("Animals", lang)}: $animalCount",
                style: GoogleFonts.roboto(fontSize: 16)),
            const SizedBox(height: 8),
            Text("${getTranslatedText("Alerts Label", lang)}: $alerts",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.red)),
            const SizedBox(height: 8),
            Text("${getTranslatedText("Last Checked", lang)}: $lastChecked",
                style: GoogleFonts.roboto(
                    fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}