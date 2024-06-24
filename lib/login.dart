import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login1/pages/ForgotPassword.dart';
import 'package:login1/pages/home.dart';

import 'package:login1/share/snackbar.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;

  bool isLoading = false;
  bool code = false;
  bool email = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controllerUsername.text, password: _controllerPassword.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        // Adresse e-mail incorrecte
        showSnackBar(context, "Adresse e-mail incorrecte");
        setState(() {
          code = true;
        });
        if (_formKey.currentState?.validate() ?? true) {}
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Le mot de passe est incorrect.");
        if (_formKey.currentState?.validate() ?? true) {}
        setState(() {
          code = true;
        });
      } else {
        showSnackBar(context, "ERROR :  ${e.code} ");
        print(e.code);
        setState(() {
          code = true;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_boxLogin.get("loginStatus") ?? false) {
    //   return const Home();
    // }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text(
                "Bienvenue ",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Dans",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Isca",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 35, // Taille de la police
                        fontWeight: FontWeight.bold, // Gras
                        color: Colors.blue),
                  ),
                  Text(
                    "E",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 40, // Taille de la police
                        fontWeight: FontWeight.bold, // Gras
                        color: Colors.blue),
                  ),
                  Text(
                    "tudiant",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 40, // Taille de la police
                        fontWeight: FontWeight.bold, // Gras
                        color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Login to your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty || email == true) {
                    return "Email incorect.";
                  }
                  // else if (!_boxAccounts.containsKey(value)) {
                  //   return "Username is not registered.";
                  // }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty || code == true) {
                    return "password ou Email incorect.";
                  }
                  // else if (value !=
                  //     _boxAccounts.get(_controllerUsername.text)) {
                  //   return "Wrong password.";
                  // }

                  return null;
                },
              ),
              // const SizedBox(height: 60),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  child: Text("Forgot password?",
                      style: TextStyle(
                          fontSize: 18, decoration: TextDecoration.underline)),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      signIn();
                      if (mounted) {
                        if (_formKey.currentState?.validate() ?? true) {}
                      }

                      // if (_formKey.currentState?.validate() ?? true) {
                      //   // _boxLogin.put("loginStatus", true);
                      //   // _boxLogin.put("userName", _controllerUsername.text);
                      //   // Navigator.pushNamed(context, '/home');
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) {
                      //         return const Home();
                      //       },
                      //     ),
                      //   );
                      // }
                    },
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Login"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Vous n'avez pas un compte?"),
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Signup();
                              },
                            ),
                          );
                        },
                        child: const Text("Signup"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
