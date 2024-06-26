import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AfficheReclemation extends StatefulWidget {
  const AfficheReclemation({super.key});

  @override
  State<AfficheReclemation> createState() => _AfficheReclemationState();
}

class _AfficheReclemationState extends State<AfficheReclemation> {
  List<Map<String, dynamic>> studentsData = [];
  String? emailUser;
  bool isLoading = true;
  List<QueryDocumentSnapshot> datas = [];

  @override
  void initState() {
    super.initState();
    getDataFromFirestore();
  }

  Future<void> getData() async {
    if (emailUser == null) {
      return;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reclemations')
        .where('email', isEqualTo: emailUser)
        .get();
    print('Number of documents retrieved: ${querySnapshot.docs.length}');

    querySnapshot.docs.forEach((doc) {
      print('Document data: ${doc.data()}');
    });

    setState(() {
      datas.clear();
      datas.addAll(querySnapshot.docs);
      isLoading = false;
    });
  }

  Future<void> getDataFromFirestore() async {
    try {
      final credential = FirebaseAuth.instance.currentUser;
      if (credential == null) {
        print("User is not logged in");
        return;
      }

      CollectionReference etudiantsCollection =
          FirebaseFirestore.instance.collection('etudiants');

      QuerySnapshot querySnapshot = await etudiantsCollection.get();

      for (var doc in querySnapshot.docs) {
        CollectionReference studentSubCollection =
            etudiantsCollection.doc(doc.id).collection(credential.uid);

        QuerySnapshot subCollectionSnapshot = await studentSubCollection.get();
        if (subCollectionSnapshot.docs.isNotEmpty) {
          DocumentSnapshot studentDoc =
              await studentSubCollection.doc(credential.uid).get();
          if (studentDoc.exists) {
            setState(() {
              studentsData.add(studentDoc.data() as Map<String, dynamic>);
              emailUser = studentDoc['Email'] ?? '';
            });
            print("Data fetched successfully");
            await getData(); // Appeler getData après avoir défini emailUser
          }
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Reclamation Envoié'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : datas.isEmpty
              ? const Center(child: Text('Aucune réclamation trouvée'))
              : ListView.builder(
                  itemCount: datas.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 5, right: 10, left: 10),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Détails de la réclamation"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${datas[i]['details']}',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Fermer"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          leading: Text((i + 1).toString()),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(datas[i]['full_name']),
                                  Text('Tu as posté une réclamation'),
                                ],
                              ),
                              Text('Semestre réclamé : ${datas[i]['semester']}'),
                              Text('Nom de la matière : ${datas[i]['nomMatiere']}'),
                              Text('Note exacte : ${datas[i]['noteExact']}'),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Text('Envoyée le : ')),
                                  Expanded(child: Text(datas[i]['dateEnvoie'])),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _getEtatColor(datas[i]['etat']),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Text('La réclamation est : ${datas[i]['etat']}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Color _getEtatColor(String etat) {
    switch (etat) {
      case 'Envoyée':
        return Colors.grey;
      case 'Refusée':
        return Colors.redAccent;
      case 'Acceptée':
        return Color.fromARGB(255, 134, 255, 82);
      case 'Révisée':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}
