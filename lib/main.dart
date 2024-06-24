import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:login1/login.dart';
import 'package:login1/pages/notif.dart';
import 'package:login1/pages/notifclss.dart';

//import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:login1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  await FirebaseNotification().initNotifications();
  runApp(MyApp(showHome: showHome));
}

//import 'homepage.dart';

class MyApp extends StatelessWidget {
  final bool showHome;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(32, 63, 129, 1.0),
        )),
        debugShowCheckedModeBanner: false,
        home: showHome ? const Login() : OnboardingPage(),
        routes: {'/notification_screen':(context) =>  Notifi()},
      );

//   @override
//   State<MyApp> createState() => _MyAppState();
//   //
}

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildPage(
          {required Color color,
          required String urlImage,
          required String title,
          required String subtitle}) =>
      Container(
          color: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                urlImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.teal.shade700,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child:
                    Text(subtitle, style: const TextStyle(color: Colors.black)),
              )
            ],
          ));

  @override
  Widget build(BuildContext context) => Scaffold(
        // Définir la couleur de fond pour la page d'introduction
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Container(
            padding: const EdgeInsets.only(bottom: 80),
            child: PageView(
                controller: controller,
                onPageChanged: (index) =>
                    setState(() => isLastPage = index == 2),
                children: [
                  buildPage(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      urlImage: "assets/img/iscae.jpg",
                      title: 'Présentation',
                      subtitle:
                          'Crée en 2009, par décret N° 2009-161 du 29 avril 2009,l’ISCAE est un établissement public d’enseignement supérieur et de recherche, placé sous la tutelle du Ministère en charge de l’Enseignement Supérieur.'),
                  buildPage(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      urlImage: "assets/img/iscae.jpg",
                      title: 'Missions',
                      subtitle:
                          'Il a pour mission de développer et d’offrir des formations initiales et continues, dans les domaines de la finance et comptabilité, des techniques modernes de gestion et de l’informatique,…'),
                  buildPage(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      urlImage: "assets/img/iscae.jpg",
                      title: 'Condition',
                      subtitle:
                          'this app is created to reduce the pression on administration of iscae and let students to registre online.'),
                ])),
        bottomSheet: isLastPage
            ? TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.teal.shade700,
                    minimumSize: const Size.fromHeight(80)),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showHome', true);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => controller.jumpTo(2),
                        child: const Text("Skip",
                            style: TextStyle(
                                color: Color.fromARGB(255, 14, 119, 7)))),
                    Center(
                        child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.black,
                        activeDotColor: Colors.teal.shade700,
                      ),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInOut),
                    )),
                    TextButton(
                        onPressed: () => controller.nextPage(
                            duration: const Duration(microseconds: 500),
                            curve: Curves.easeInOut),
                        child: const Text("Next",
                            style: TextStyle(
                                color: Color.fromARGB(255, 14, 119, 7)))),
                  ],
                ),
              ),
      );
}

