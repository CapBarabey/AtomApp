import 'package:atom_login_page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:atom_login_page/reset_post.dart';

final _resetForm = GlobalKey<FormState>();

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late Color myColor;
  late Size mediaSize;

  TextEditingController emailController = TextEditingController();

  Future<ResetResponse>? _futureResetResponse;
  bool responseErrorState = false;

  static String? validateEmail(String? emailController) {
    RegExp emailRegEx = RegExp(r'^[\w\\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isValid = emailRegEx.hasMatch(emailController ?? '');
    if (!isValid) {
      return 'Enter correct email address';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/BGimage.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(myColor.withOpacity(0.3), BlendMode.dstATop),
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

  Widget _buildBottom() {
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
        Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: _backButton(context)
            ),
            Center(
              child: Text(
                "Password reset",
                style: TextStyle(
                  color: myColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Center(child: _buildGreyText("Please enter your email for reset password")),
        const SizedBox(height: 60),
        Form(
          key: _resetForm,
          child: Column(
            children: [
              _buildGreyText("Email"),
              _buildInputField(emailController),
              const SizedBox(height: 100),
              _buildResetButton(context),
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

  Widget _buildInputField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (String? value) => validateEmail(controller.text),
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.mail),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if(_resetForm.currentState!.validate() == true) {
            _futureResetResponse = resetPassword(emailController.text);

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title:  const Text('Reset info'),
                content: resetResponse(),
                actions: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (responseErrorState) {
                          Navigator.pop(context);
                        } else {
                          Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => const LoginPage()
                            )
                          );
                        }
                      },
                      child: const Text("OK"),
                    ),
                  )
                ],
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          elevation: 5,
          shadowColor: myColor,
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Text("RESET"),
    );
  }
  
  Widget _backButton(BuildContext context) {
    return IconButton(
      // style: widget.style,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  FutureBuilder<ResetResponse> resetResponse() {
    return FutureBuilder(
        future: _futureResetResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.status != "error") {
            responseErrorState = false;
            return Text(snapshot.data!.message);
          } else if (snapshot.hasError) {
            responseErrorState = true;
            return Text('${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data!.status == "error") {
            responseErrorState = true;
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
        }
    );
  }

}

Future<ResetResponse> resetPassword(String email) async {
  Map<String, dynamic> request ={
    'email': email,
  };

  final uri = Uri.parse('https://api.saletoyou.net/auth/reset-password');
  final response = await http.post(uri, body: request);

  return ResetResponse.fromJson(json.decode(response.body) as Map<String, dynamic>);
}