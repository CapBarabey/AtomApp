import 'package:atom_login_page/home-page/home_page.dart';
import 'package:atom_login_page/login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatelessWidget {
  final String email;
  const SideMenu({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/OtrarBackground.jpg")
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                const SizedBox(height: 60),
                Text(
                    email,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: (){
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => const HomePage()
                )
              );
            },
          ),
          ListTile(
            leading:  const Icon(Icons.airplane_ticket),
            title: const Text('Air tickets'),
            onTap: (){},
          ),
          ListTile(
            leading:  const Icon(Icons.train),
            title: const Text('Train tickets'),
            onTap: (){},
          ),
          ListTile(
            leading:  const Icon(Icons.hotel),
            title: const Text('Hotels'),
            onTap: (){},
          ),
          ListTile(
            leading:  const Icon(Icons.local_offer),
            title: const Text('Offers'),
            onTap: (){},
          ),
          ListTile(
            leading:  const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: (){
              removeUserData();
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => const LoginPage()
                )
              );
            },
          ),
        ],
      )
    );
  }

  Future<void> removeUserData() async {
    final storage = await SharedPreferences.getInstance();
    await storage.remove('data',);
  }

}
