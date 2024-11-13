import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class LanguagesScreen extends StatefulWidget {
  int languageIndex;

  LanguagesScreen ({ Key key, selectedLanguage }): super(key: key) {
    languageIndex = selectedLanguage == 'English' ? 0 : (selectedLanguage == 'Spanish' ? 1 : (selectedLanguage == 'Chinese' ? 2 : 3));
  }

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState(languageIndex);
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex;

  _LanguagesScreenState(this.languageIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Languages')),
      body: SettingsList(
        backgroundColor: Color(0xFF141221),
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: "English",
              trailing: trailingWidget(0),
              onPressed: (BuildContext context) {
                changeLanguage(0);
                Navigator.pop(context, 'English');
              },
            ),
            SettingsTile(
              title: "Spanish",
              trailing: trailingWidget(1),
              onPressed: (BuildContext context) {
                changeLanguage(1);
                Navigator.pop(context, 'Spanish');
              },
            ),
            SettingsTile(
              title: "Chinese",
              trailing: trailingWidget(2),
              onPressed: (BuildContext context) {
                changeLanguage(2);
                Navigator.pop(context, 'Chinese');
              },
            ),
            SettingsTile(
              title: "German",
              trailing: trailingWidget(3),
              onPressed: (BuildContext context) {
                changeLanguage(3);
                Navigator.pop(context, 'German');
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void changeLanguage(int index) {
    setState(() {
      languageIndex = index;
    });
  }
}