// import 'package:custom_scroll_view/routes/routes.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Column(
            spacing: 20,
            children: [profileSection(), settingsSection(context)],
          ),
        ));
  }

  Widget profileSection() {
    Widget profile() {
      return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
        child: Text(
          'net'.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      );
    }

    Widget userInfo({String? name, String? phoneNumber}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name ?? 'John Doe',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            phoneNumber ?? '0987654334',
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        spacing: 10,
        children: [profile(), userInfo()],
      ),
    );
  }

  Widget settingsSection(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.receipt,
                size: 26,
              ),
              title: Text(
                'My Orders',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                size: 26,
              ),
              title: Text(
                'Change Language',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {},
            )
          ],
        ),
        Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.info,
                size: 26,
              ),
              title: Text(
                'About',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,
                size: 26,
              ),
              title: Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {},
            ),
          ],
        ),
        ListTile(
          leading: Icon(
            Icons.logout,
            size: 26,
          ),
          title: Text('Log out', style: TextStyle(fontSize: 20)),
          onTap: () async {
            // Perform logout action
            // final pref = await SharedPreferences.getInstance();
            // pref.setBool('isLogin', false);
            // Navigator.pushReplacementNamed(context, Routes.authentication);
          },
        ),
      ],
    );
  }
}
