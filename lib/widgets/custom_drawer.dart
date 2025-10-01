import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/translations.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  final String lang; // ✅ added for translations

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.onLogout,
    required this.lang, // ✅ required
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          // ✅ Header with green color
          Container(
            width: double.infinity,
            color: Colors.green.shade400, // matches login page
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${getTranslatedText("Welcome", lang)}, $userName!",
                    style: GoogleFonts.roboto(
                      color: const Color(0xFFFFFDD0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // ✅ Menu items with translations
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.black87),
                  title: Text(getTranslatedText("Profile", lang),
                      style: const TextStyle(color: Colors.black87)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.black87),
                  title: Text(getTranslatedText("Home", lang),
                      style: const TextStyle(color: Colors.black87)),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.school, color: Colors.black87),
                  title: Text(getTranslatedText("Training", lang),
                      style: const TextStyle(color: Colors.black87)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.black87),
                  title: Text(getTranslatedText("Settings", lang),
                      style: const TextStyle(color: Colors.black87)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.black87),
                  title: Text(getTranslatedText("Help", lang),
                      style: const TextStyle(color: Colors.black87)),
                  onTap: () {},
                ),
              ],
            ),
          ),

          // ✅ Logout at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(getTranslatedText("Logout", lang),
                  style: const TextStyle(color: Colors.red)),
              onTap: onLogout,
            ),
          ),
        ],
      ),
    );
  }
}