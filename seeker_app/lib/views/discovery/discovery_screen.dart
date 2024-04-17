import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_app/models/discovery.dart';
import 'package:seeker_app/providers/user_data_provider.dart';
import 'package:seeker_app/services/discovery/discovery.dart';
import 'package:seeker_app/views/discovery/detail_discovery_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  @override
  Widget build(BuildContext context) {
    final userId =
        Provider.of<UserProvider>(context, listen: false).userProfile.uid;

    return Scaffold(
      body: StreamBuilder<List<Discovery>>(
        stream: fetchDiscoveriesStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Erreur de chargement : ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("Aucune découverte trouvée"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Discovery discovery = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(discovery.title ?? 'Titre inconnu'),
                    subtitle:
                        Text(discovery.description ?? 'Pas de description'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DiscoveryDetailScreen(discovery: discovery),
                      ));
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Aucune découverte trouvée"));
          }
        },
      ),
    );
  }
}
