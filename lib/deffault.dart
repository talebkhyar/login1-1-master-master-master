import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login1/login.dart';
import 'package:login1/pages/home.dart';
import 'package:login1/share/snackbar.dart';
//import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//import 'homepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //     primaryColor: Colors.teal,
        //     scaffoldBackgroundColor: Colors.white,
        //     textTheme: const TextTheme(
        //         bodyText2: TextStyle(
        //             fontSize: 64, color: Color.fromARGB(255, 136, 189, 137))),
        //     textButtonTheme: TextButtonThemeData(
        //         style: TextButton.styleFrom(
        //      // primary:Colors.teal.shade700,
        //       textStyle: const TextStyle(
        //         fontSize: 18,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ))),
        home: showHome ? StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (snapshot.hasError) {
                return showSnackBar(context, "Something went wrong");
              } else if (snapshot.hasData) {
                // return VerifyEmailPage();
                return const Home(); // home() OR verify email
              } else {
                return const Login();
              }
            },
          )   : OnboardingPage(),
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
        // ignore: avoid_unnecessary_containers
        body: Container(
            padding: const EdgeInsets.only(bottom: 80),
            child: PageView(
                controller: controller,
                onPageChanged: (index) =>
                    setState(() => isLastPage = index == 2),
                children: [
                  buildPage(
                      color: Colors.green.shade100,
                      urlImage: "assets/img/avatar.png",
                      title: 'Présentation',
                      subtitle:
                          'Crée en 2009, par décret N° 2009-161 du 29 avril 2009,l’ISCAE est un établissement public d’enseignement supérieur et de recherche, placé sous la tutelle du Ministère en charge de l’Enseignement Supérieur.'),
                  buildPage(
                      color: Colors.green.shade100,
                      urlImage: "assets/img/avatar.png",
                      title: 'Missions',
                      subtitle:
                          'Il a pour mission de développer et d’offrir des formations initiales et continues, dans les domaines de la finance et comptabilité, des techniques modernes de gestion et de l’informatique,…'),
                  buildPage(
                      color: Colors.green.shade100,
                      urlImage: "assets/img/avatar.png",
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
                        onPressed: () => controller.previousPage(
                              duration: const Duration(microseconds: 500),
                              curve: Curves.easeInOut,
                            ),
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

///////////// home page

// class HomePage extends StatelessWidget {
//   //const HomePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Home Page',
//             style: TextStyle(backgroundColor: Colors.blue),
//           ),
//           backgroundColor: Color.fromARGB(255, 71, 67, 152),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.logout_sharp),
//               onPressed: () async {
//                 final prefs = await SharedPreferences.getInstance();
//                 prefs.setBool('showHome', false);
//                 Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => OnboardingPage()));
//               },
//             ),
//           ],
//         ),
//         body: const Center(
//           child: Text('Home', style: TextStyle(color: Colors.black)),
//         ));
//   }
// }
