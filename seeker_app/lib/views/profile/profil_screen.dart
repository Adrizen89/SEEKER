import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_app/providers/user_data_provider.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context).userProfile;

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (userProfile.photoUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(userProfile.photoUrl!),
              radius: 60.0,
            )
          else
            CircleAvatar(
              child: Icon(Icons.person, size: 60),
              radius: 60.0,
            ),
          Container(
            child: Text('Bonjour, ${userProfile.firstName}'),
          ),
          Container(
            child: Text("Née le ${userProfile.dateNaissance}"),
          ),
          Container(
            child: Text(userProfile.biography),
          ),
          Container(
            child: Text("65 découvertes"),
          )
        ],
      ),
    ));
  }
}
