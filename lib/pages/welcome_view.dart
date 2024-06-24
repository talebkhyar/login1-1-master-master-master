import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFDocument {
  final String name;
  final String url;

  PDFDocument({required this.name, required this.url});
}

class WelcomeView extends StatefulWidget {
  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  late List<PDFDocument?> pdfDocuments;

  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    pdfDocuments = [];
    fetchPdfUrls();
  }

  void fetchPdfUrls() {
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

  Future<List<PDFDocument?>> getPdfUrlsFromFirestore() async {
    List<PDFDocument?> pdfDocuments = [];
    try {
      CollectionReference pdfCollection =
          FirebaseFirestore.instance.collection('avis');
      QuerySnapshot querySnapshot = await pdfCollection.get();
      querySnapshot.docs.forEach((doc) {
        String pdfUrl = doc['URL'];
        String name = doc['nom'];
        pdfDocuments.add(PDFDocument(name: name, url: pdfUrl));
      });
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
                  builder: (context) => PDFViewerPage(url: pdfUrl,nom: pdfnom,),
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
                  "assets/img/avis_0.png",
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
  PDFViewerPage({required this.url,required this.nom});

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
