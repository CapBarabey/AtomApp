import 'dart:convert';
import 'package:atom_login_page/home_page.dart';
import 'package:atom_login_page/login_post.dart';
import 'package:atom_login_page/reset_password_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final _loginForm = GlobalKey<FormState>();

Future<LoginResponse> logIn(String email, String password) async {
  Map<String, dynamic> request ={
    'email': email,
    'password': password,
  };

  final uri = Uri.parse('https://api.saletoyou.net/auth/login');
  final response = await http.post(uri, body: request);

  return LoginResponse.fromJson(json.decode(response.body) as Map<String, dynamic>);
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _userEmail = '';
  late String _userPassword = '';

  @override
  void initState() {
    super.initState();
    loadUserCredentials();
  }

  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;
  bool _isLogin = false;
  Future<LoginResponse>? _futureLoginResponse;

  static String? validateEmail(String? emailController) {
    RegExp emailRegEx = RegExp(r'^[\w\\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isValid = emailRegEx.hasMatch(emailController ?? '');
    if (!isValid) {
      return 'Enter correct email address';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? passwordController) {
    return passwordController!.length < 3 ? "Enter correct password" : null;
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/BGimage.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop)
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 40, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.airlines_rounded,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "Atom",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget  _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Center(
         child: Text(
           "Atom login",
           style: TextStyle(
             color: myColor,
             fontSize: 32,
             fontWeight: FontWeight.w500,
           ),
         ),
       ),
       Center(child: _buildGreyText("Login for start using app")),
       const SizedBox(height: 60),
       Form(
         key: _loginForm,
         child: Column(
           children: [
             _buildGreyText("Email"),
             _buildInputField(emailController),
             const SizedBox(height: 40),
             _buildGreyText("Password"),
             _buildInputField(passwordController, isPassword: true),
             const SizedBox(height: 20),
             _buildRememberCheckBox(),
             const SizedBox(height: 20),
             _buildLoginButton(context),
           ],
         ),
       ),
     ],
   );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller,
  {isPassword = false}) {
    return TextFormField(
      controller: controller..text = isPassword ? _userPassword : _userEmail,
      validator: (String? value) => isPassword ? validatePassword(controller.text) : validateEmail(controller.text),
      decoration: InputDecoration(
        suffixIcon: isPassword ? const Icon(Icons.password) : const Icon(Icons.mail),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildRememberCheckBox() {
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(value: rememberUser, onChanged: (value){
              setState(() {
                rememberUser = value!;
              });
            }),
            _buildGreyText("Remember me"),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: TextButton(
            onPressed: (){
              debugPrint("Forgot password");
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => const ResetPassword()
                ),
              );
            },
            child: _buildGreyText("Forgot password"),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_loginForm.currentState!.validate() == true) {
          _futureLoginResponse = logIn(emailController.text, passwordController.text);
          debugPrint("${_loginForm.currentState!.validate()}");
          debugPrint("Email: ${emailController.text}");
          debugPrint("Password: ${passwordController.text}");
          if (rememberUser == true) {
            saveUserCredentials(emailController.text, passwordController.text, rememberUser);
          } else {
            removeUserCredentials();
          }
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Login Info"),
                content: loginResponse(),
                actions: [
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          if (_isLogin == false) { //remake to true
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context) => const HomePage()
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("OK"),
                    ),
                  )
                ],
              )
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 5,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text("LOGIN"),
    );
  }

  FutureBuilder<LoginResponse> loginResponse() {
    return FutureBuilder<LoginResponse>(
      future: _futureLoginResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.status != "error") {
          _isLogin = true;
          saveUserData(snapshot.data!.data, snapshot.data!.data!['email']);
          return Text(snapshot.data!.message);
        } else if(snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if(snapshot.hasData &&  snapshot.data!.status == "error") {
          return Text(snapshot.data!.message);
        }
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveUserCredentials(String userEmail, String userPassword, bool remember) async {
    final storage = await SharedPreferences.getInstance();
    setState(() {
      storage.setString('email', userEmail);
      storage.setString('password', userPassword);
      storage.setBool('remember', remember);
      debugPrint('saved');
    });
  }

  Future<void> saveUserData(Map<String, dynamic>? userData, String userEmail) async {
    final storage = await SharedPreferences.getInstance();
    setState(() {
      storage.setString('email', userEmail);
      storage.setString('data', userData as String);
    });
  }

  Future<void> loadUserCredentials() async {
    final storage = await SharedPreferences.getInstance();
    setState(() {
      debugPrint('initialize');
      _userEmail = storage.getString('email') ?? '';
      _userPassword = storage.getString('password') ?? '';
      rememberUser = storage.getBool('remember') ?? false;
    });
  }

  Future<void> removeUserCredentials() async {
    final storage = await SharedPreferences.getInstance();
    await storage.remove('email',);
    await storage.remove('password',);
    await storage.remove('remember',);
  }

}