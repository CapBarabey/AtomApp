import 'package:atom_login_page/side-menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../air/air-search/search_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String userEmail = '';

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(email: userEmail),
      appBar: AppBar(
        title: const Text("HomePage"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const SingleChildScrollView(
        child: SearchForm(),
      ),
    );
  }

  Future<void> getUserEmail() async {
    final storage = await SharedPreferences.getInstance();
    userEmail = storage.getString('userDataEmail')!;
  }
}
