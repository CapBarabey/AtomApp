import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _loginForm = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

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
    debugPrint("Validation work!");
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
             _buildLoginButton(),
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
      controller: controller,
      validator: (String? value) => isPassword ? validatePassword(controller.text) : validateEmail(controller.text),
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.password) : Icon(Icons.mail),
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

        TextButton(
          onPressed: (){
            debugPrint("Forgot password");
            debugPrint("$rememberUser");
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: _buildGreyText("Forgot password"),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        _loginForm.currentState!.validate();
        debugPrint("Email: ${emailController.text}");
        debugPrint("Password: ${passwordController.text}");
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

}