import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(''),
        ),
        body: Padding(
          padding: const EdgeInsets.all(38.0),
          child: ListView(
            children: [
              const Text(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  "L\’ISCAE a pour ambition d’assurer à ses étudiants, une formation académique et pratique de qualité et ce, dans des domaines aussi variés tels que: les finances, la comptabilité, la GRH, les statistiques, le marketing, l'informatique et les réseaux & télécoms."),
              const SizedBox(
                height: 20,
              ),
              const Text(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  "La formation est organisée autour de huit filières des licences et deux masters, toutes accréditées par le CNESRS, regroupées au sein des deux départements que compte l’Institut :"),
              const SizedBox(
                height: 30,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/img/MED.png'),
                        //child: Text('MED'),
                      ),
                      Text(
                        'MED',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/img/MQI.png'),
                      ),
                      Text(
                        'MQI',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ]),
              SizedBox(
                height: 25,
              ),
              Text(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  'BP: 6093 – Nouakchott – Mauritanie'),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  //launchUrl('https://www.google.com' as Uri);
                  //launchUrl('tel:+22231124690' as Uri);
                  // ignore: deprecated_member_use
                  launch('tel:+222 45241966');
                },
                child: Text(
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..color = Colors.black),
                    '+222 45 24 19 66'),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    //launchUrl('https://www.google.com' as Uri);
                    //launchUrl('tel:+22231124690' as Uri);
                    // ignore: deprecated_member_use
                    launch('mailto:contact@iscae.mr');
                  },
                  child: Text(
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..color = Colors.black),
                      'contact@iscae.mr')),
            ],
          ),
        ));
  }
}
