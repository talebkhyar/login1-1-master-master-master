// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:login1/pages/afficheReclemation.dart';
import 'package:login1/pages/vreclamation.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Rectlmation extends StatefulWidget {
  const Rectlmation({super.key});

  @override
  State<Rectlmation> createState() => _RectlmationState();
}

class _RectlmationState extends State<Rectlmation> {
  
  final List<String> S1_RT1 = [
    'Reseaux 1',
    'Algorithmique',
    'MTU',
    'MS Office',
    'Electronique',
    'Supports',
    'Analyse',
    'Logique',
    'Anglais',
    'Architecture'
  ];

  String? _selectedName;

  final List<String> S2_RT1 = [
    'Reseaux 2',
    'Reseaux cellulaire',
    'Programmation C ',
    'Systeme d\' exploitation',
    'Programmation web',
    'Programmation python',
  ];

  String? _selectedNameS2;

  final List<String> S1_DI1 = [
    'Architecture',

    'MTU',
    'MS Office',
    'Anglais technique 1',
    'Analyse',
    'Introdution a la Programmation web',
  ];
  String? _selectedDIS1;

  final List<String> S2_DI1 = [
    'Langage C',
    'Anglais technique 2',
    'Algebre lineaire',
    'Systeme d\' exploitation',
    'Programmation web 2',
    'Programmation python',
    'Modelisation Merise',
    'Analyse 2',
  ];
  String? _selectedDIS2;

  final matiereController = TextEditingController();
  final noteController = TextEditingController();
  final descripController = TextEditingController();
  File? _selectedImage;
  String? _semester;

  String? urlImage;
  bool? valide;
  List<Map<String, dynamic>> studentsData = [];
  String? nom;
  String? nomDMat;
  String? emailUser;
  String? fillier;
  String? reclemationExamen = 'Non';
  String? etat;
  List<String> vide = [];
  String? details;

  @override
  void initState() {
    getDataFromFirestore();
    getData();
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
    etat = 'Envoyée';
    details = '';
    nomDMat = '';
    final now = DateTime.now();
    valide = false;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Reclamation'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AfficheReclemation()));
              },
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          children: [
            const Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Selectionnez le Semester',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text('Semestre 1'),
                    value: "Semestre 1",
                    groupValue: _semester,
                    onChanged: (value) {
                      setState(() {
                        _semester = value;
                      });
                      print(value);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('Semestre 2'),
                    value: "Semestre 2",
                    groupValue: _semester,
                    onChanged: (value) {
                      setState(() {
                        _semester = value;
                      });
                      print(value);
                    },
                  ),
                ),
              ],
            ),
            const Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Reclamation Devoir",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: TextField(
            //     controller: matiereController,
            //     decoration: InputDecoration(
            //         hintText: "Nom de Matiere",
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(15))),
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Text(
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..color = Colors.black),
                'Nom de Matiere'),
            //Réseaux informatiques et Télécommunications L1

            fillier == "Réseaux informatiques et Télécommunications"
                ? _semester == "Semestre 1"
                    ? Padding(
                        padding: EdgeInsets.all(10.0),
                        child: DropdownButton(
                          hint: Text('Sélectionnez une matière'),
                              isExpanded: true,
                          value: _selectedName,
                          items: S1_RT1.map((String item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item));
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedName = value!;
                            });
                            print(_selectedName);
                          },
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: 40,
                          ),
                        ),
                      )
                    : _semester == "Semestre 2"
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButton(
                              hint: Text('Sélectionnez une matière'),
                              isExpanded: true,
                              value: _selectedNameS2,
                              items: S2_RT1.map((String item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item));
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedNameS2 = value!;
                                });
                                print(_selectedNameS2);
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                              ),
                            ),
                          )
                        : Text('Appuyer un Semester')

                //Développement Informatique L1
                : fillier == "Développement Informatique"
                    ? _semester == "Semestre 1"
                        ? Padding(
                            padding: EdgeInsets.all(10.0),
                            child: DropdownButton(
                              hint: Text('Sélectionnez une matière'),
                              isExpanded: true,
                              value: _selectedDIS1,
                              items: S1_DI1.map((String item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item));
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedDIS1 = value!;
                                });
                                print(_selectedDIS1);
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 40,
                              ),
                            ),
                          )
                        : _semester == "Semestre 2"
                            ? Padding(
                              
                                padding: const EdgeInsets.all(10.0),
                                child: DropdownButton(
                                  value: _selectedDIS2,
                                  hint: Text('Sélectionnez une matière'),
                                  isExpanded: true,
                                  items: S2_DI1.map((String item) {
                                    return DropdownMenuItem(
                                        value: item, child: Text(item));
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedDIS2 = value!;
                                    });
                                    print(_selectedDIS2);
                                  },
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 40,
                                  ),
                                ),
                              )
                            : Text('Appuyer un Semester')
                    : Text(''),

            // if (_devoirOuExamen == "Devoir")
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: noteController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: InputDecoration(
                    hintText: "Note exacte",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            // if (_devoirOuExamen == "Devoir")
            const Text(
              'Selectionnez la copie du note',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            //if (_devoirOuExamen == "Devoir")
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                    child: Container(
                        height: 50,
                        child: Image.asset('assets/img/gallery.png')),
                  ),
                  //if (_devoirOuExamen == "Devoir")
                  MaterialButton(
                      onPressed: () {
                        _pickImageFromCamera();
                      },
                      child: Container(
                          height: 50,
                          child: Image.asset('assets/img/camera.png'))),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text(
                    "Tu as une Reclemation Sur L'Examen ?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile(
                    title: Text('Oui'),
                    value: "Oui",
                    groupValue: reclemationExamen,
                    onChanged: (value) {
                      setState(() {
                        reclemationExamen = value;
                      });
                      print(value);
                    },
                  ),
                  RadioListTile(
                    title: Text('Non'),
                    value: "Non",
                    groupValue: reclemationExamen,
                    onChanged: (value) {
                      setState(() {
                        reclemationExamen = value;
                      });
                      print(value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            //1234567843s6fr7gt
            // _selectedImage != null
            //     ? Image.file(_selectedImage!)
            //     : const Text('please get image'),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: descripController,
                decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    showCupertinoDialog<void>(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                              title: const Icon(
                                Icons.warning,
                                color: Colors.red,
                              ),
                              content: const Text(
                                  'vous voullez envoie la reclemation ?'),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  child: Text('No'),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text('Yes'),
                                  isDefaultAction: true,
                                  onPressed: () async {
                                    //Réseaux informatiques et Télécommunications
                                    if (fillier ==
                                        "Réseaux informatiques et Télécommunications") {
                                      if (_semester == "Semestre 1") {
                                        var nomMat = _selectedName;
                                        nomDMat = nomMat;
                                      } else if (_semester == "Semestre 2") {
                                        var nomMat = _selectedNameS2;
                                        nomDMat = nomMat;
                                      }
                                    } else if (fillier ==
                                        "Développement Informatique") {
                                      // fillier == "Développement Informatique"?
                                      if (_semester == "Semestre 1") {
                                        var nomMat = _selectedDIS1;
                                        nomDMat = nomMat;
                                      } else if (_semester == "Semestre 2") {
                                        var nomMat = _selectedDIS2;
                                        nomDMat = nomMat;
                                      }
                                    }
                                    await saveImage();

                                    addDataToSave(
                                        _semester.toString().trim(),
                                        reclemationExamen.toString(),
                                        nomDMat,
                                        noteController.text.trim(),
                                        descripController.text.trim(),
                                        valide,
                                        now,
                                        etat,
                                        details);

                                    Navigator.pop(context);
                                    setState(() {
                                      _semester = "";
                                      reclemationExamen = 'Non';
                                      nomDMat = null;
                                      noteController.text = "";
                                      noteController.text = "";
                                      descripController.text = "";
                                      _selectedImage = null;
                                      urlImage = null;
                                    });
                                  },
                                )
                              ],
                            ));
                  },
                  child: Text(
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..color = Colors.black),
                      'Envoié ')),
            ),
          ],
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  final credential = FirebaseAuth.instance.currentUser;
  Future addDataToSave(String semester, reclemationExamen, nomDMat, String note,
      String descrp, valide, now, etat, details) async {
    await FirebaseFirestore.instance.collection('reclemations').add({
      'semester': semester,
      'reclemationDeExamen': reclemationExamen,
      'nomMatiere': nomDMat,
      'noteExact': note,
      'descrip': descrp,
      'valide': valide,
      'urlImage': urlImage,
      'full_name': nom,
      'email': emailUser,
      'filiére': fillier,
      'dateEnvoie': now.toString(),
      'etat': etat,
      'details': details,
      //'examen'
    });
  }

  Future saveImage() async {
    if (_selectedImage != null) {
      var ImageName = basename(_selectedImage!.path);
      var refStorage = FirebaseStorage.instance.ref('reclemations/$ImageName');
      await refStorage.putFile(_selectedImage!);

      urlImage = await refStorage.getDownloadURL();
    } else {
      urlImage = null;
    }
  }

  Future<void> getDataFromFirestore() async {
    try {
      final credential = FirebaseAuth.instance.currentUser;
      if (credential == null) {
        print("User is not logged in");
        return;
      }

      // Récupérer la référence de la collection principale
      CollectionReference etudiantsCollection =
          FirebaseFirestore.instance.collection('etudiants');

      // Récupérer tous les documents de la collection principale
      QuerySnapshot querySnapshot = await etudiantsCollection.get();

      // Parcourir tous les documents
      // Parcourir tous les documents
      for (var doc in querySnapshot.docs) {
        // Récupérer la sous-collection avec l'UID de l'étudiant
        CollectionReference studentSubCollection =
            etudiantsCollection.doc(doc.id).collection(credential.uid);

        // Vérifier si la sous-collection contient des documents
        QuerySnapshot subCollectionSnapshot = await studentSubCollection.get();
        if (subCollectionSnapshot.docs.isNotEmpty) {
          // Si la sous-collection contient des documents, récupérer les données
          DocumentSnapshot studentDoc =
              await studentSubCollection.doc(credential.uid).get();
          if (studentDoc.exists) {
            setState(() {
              studentsData.add(studentDoc.data() as Map<String, dynamic>);
              nom = studentDoc['full_name'] ?? '';
              emailUser = studentDoc['Email'] ?? '';
              fillier = studentDoc['filiére'] ?? '';
              // _fullNameController.text = studentDoc['full_name'] ?? '';
              // _phoneNumberController.text = studentDoc['tel'] ?? '';
            });
            print("Data fetched successfully");
          }
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
    }
  }
}
