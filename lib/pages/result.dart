import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:login1/share/snackbar.dart';

class PDFDocument {
  final String name;
  final String url;

  PDFDocument({required this.name, required this.url});
}

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late List<PDFDocument?> pdfDocuments;

  bool isLoading = true;
  bool isError = false;
  String? filier;

  @override
  void initState() {
    super.initState();
    pdfDocuments = [];
    fetchPdfUrls();
  }

  void fetchPdfUrls() async {
    await getDataFromFirestore();
    getPdfUrlsFromFirestore().then((documents) {
      setState(() {
        pdfDocuments = documents;
        isLoading = false;
        isError = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    });
  }

  List<Map<String, dynamic>> studentsData = [];

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
              filier = studentDoc['filiére'] ?? '';
print(filier);
              // _fullNameController.text = studentDoc['full_name'] ?? '';
              // _nniController.text = studentDoc['NNI'] ?? '';
              // _phoneNumberController.text = studentDoc['tel'] ?? '';
              // _emailController.text = studentDoc['Email'] ?? '';
            });
          }
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
    }
  }

  Future<List<PDFDocument?>> getPdfUrlsFromFirestore() async {
    List<PDFDocument?> pdfDocuments = [];
    try {
      CollectionReference pdfCollection =
          FirebaseFirestore.instance.collection('resultats');

      CollectionReference studentSubCollection =
          pdfCollection.doc(filier).collection('resultats');
      QuerySnapshot subCollectionSnapshot = await studentSubCollection.get();
      if (subCollectionSnapshot.docs.isNotEmpty) {
        subCollectionSnapshot.docs.forEach((doc) {
          String pdfUrl = doc['URL'];
          String name = doc['nom'];
          pdfDocuments.add(PDFDocument(name: name, url: pdfUrl));
        
        });
      } else {
        showSnackBar(context, "resultats indisponible");
      }
    } catch (e) {
      print('Erreur lors de la récupération des URLs des PDF: $e');
      throw e; // Rejette l'erreur pour la capturer dans catchError
    }
    return pdfDocuments;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (isError) {
      return Center(
        child: Text('Erreur lors du chargement des PDF.'),
      );
    } else {
      return GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 1,
        mainAxisSpacing: 5.0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(pdfDocuments.length, (index) {
          return GestureDetector(
            onTap: () {
              String pdfUrl = pdfDocuments[index]!.url;
              String pdfnom = pdfDocuments[index]!.name;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewerPage(
                    url: pdfUrl,
                    nom: pdfnom,
                  ),
                ),
              );
            },
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.lightBlue.withOpacity(0.1),
                title: Text(
                  pdfDocuments[index]!.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Image.asset(
                    "assets/img/RESULTATS_1.jpg",
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          );
        }),
      );
    }
  }
}

class PDFViewerPage extends StatelessWidget {
  final String url;
  final String nom;
  PDFViewerPage({required this.url, required this.nom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nom),
      ),
      body: PDF().fromUrl(
        url,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
