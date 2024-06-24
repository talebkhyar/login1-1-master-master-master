import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login1/login.dart';
import 'package:login1/pages/about.dart';
import 'package:login1/pages/profil.dart';
import 'package:login1/pages/reclemation.dart';
import 'package:login1/pages/vreclamation.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
    
  }

  bool? valid;
  List<QueryDocumentSnapshot> vdata = [];
Future<void> getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ouvertur_reclemation')
        .get();
    vdata = querySnapshot.docs; // Remplacer addAll par l'assignation directe
    setState(() {
      valid = vdata[0]['etat'];
    });
    print(valid);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          onTap: () {
            print('profile');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Profile()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Reclemation'),
          onTap: () async {
            await getData();
            if (valid == false) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ReclmNovld();
                  },
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Rectlmation();
                  },
                ),
              );
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About Institut'),
          onTap: () {
            // print('Logout');

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const About()));
          },
        ),
        const AboutListTile(
          icon: Icon(Icons.info),
          //applicationIcon: FlutterLogo(),
          applicationName: "Us",
          applicationVersion: 'version 2.0.1',
          // applicationLegalese:
          //     'Copyright © 2024 | ISCAE Tous droits réservés .',
          aboutBoxChildren: const [
            Column(
              children: [
                Text(
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    'This Application Developped By : '),
                Text(
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    'Mohamed Yenj'),
                Text(
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    'Sidi Mohamed'),
                Text(
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    'Taleb Khaiyar'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                'Copyright © 2024 | ISCAE Tous droits réservés .'),
          ],
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () async {
            // print('Logout');

            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()));
          },
        ),
      ],
    );
  }
}
