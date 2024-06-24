import 'package:flutter/material.dart';

class ReclmNovld extends StatefulWidget {
  const ReclmNovld({super.key});

  @override
  State<ReclmNovld> createState() => _VRecState();
}

class _VRecState extends State<ReclmNovld> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Reclamation'),
        centerTitle: true,),
          body: Container(
                child: Center(
          child: Text(style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..color = Colors.black),'reclamation no disponible '),
                ),
              ),
        ));
  }
}
