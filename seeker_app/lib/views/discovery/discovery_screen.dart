import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_app/constants/colors.dart';
import 'package:seeker_app/constants/size.dart';
import 'package:seeker_app/models/discovery.dart';
import 'package:seeker_app/providers/user_data_provider.dart';
import 'package:seeker_app/services/discovery/discovery.dart';
import 'package:seeker_app/views/discovery/detail_discovery_screen.dart';
import 'package:seeker_app/widgets/custom_search_bar.dart';
import 'package:seeker_app/widgets/custom_text.dart';
import 'package:seeker_app/widgets/custom_textfield.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Discovery> _allDiscoveries = [];
  List<Discovery> _filteredDiscoveries = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    filterDiscoveries();
  }

  void filterDiscoveries() {
    List<Discovery> _results = [];
    if (_searchController.text.isEmpty) {
      _results = _allDiscoveries;
    } else {
      _results = _allDiscoveries
          .where((discovery) => (discovery.title?.toLowerCase() ?? '')
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredDiscoveries = _results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        Provider.of<UserProvider>(context, listen: false).userProfile.uid;

    return Scaffold(
      backgroundColor: ColorSelect.grey200,
      appBar: AppBar(
        elevation: 0,
        title: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: CustomSearchBar(
            controller: _searchController,
            hintText: 'Rechercher...',
          ),
        ),
        actions: [
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: SizeConfig.customMargin()),
              width: SizeConfig.screenWidth * 0.12,
              height: SizeConfig.screenHeight * 0.07,
              decoration: BoxDecoration(
                color: ColorSelect.mainColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: ColorSelect.secondaryColor,
                size: SizeConfig.screenWidth * 0.07,
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder<List<Discovery>>(
        stream: fetchDiscoveriesStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Erreur de chargement : ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (!_isInitialized) {
              Future.delayed(Duration.zero, () {
                setState(() {
                  _allDiscoveries = snapshot.data!;
                  filterDiscoveries();
                  _isInitialized = true;
                });
              });
            }
            return Column(
              children: [
                Expanded(
                  child: _filteredDiscoveries.isEmpty
                      ? const Center(child: Text("Aucune découverte trouvée"))
                      : ListView.builder(
                          itemCount: _filteredDiscoveries.length,
                          itemBuilder: (context, index) {
                            Discovery discovery = _filteredDiscoveries[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.customPadding(),
                                left: SizeConfig.customPadding(),
                                right: SizeConfig.customPadding(),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DiscoveryDetailScreen(
                                        discovery: discovery),
                                  ));
                                },
                                child: Container(
                                  height: SizeConfig.screenHeight * 0.21,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorSelect.grey400,
                                        offset: const Offset(1.0, 1.0),
                                        blurRadius: 5.0,
                                        spreadRadius: 1.0,
                                      ),
                                    ],
                                    color: ColorSelect.grey200,
                                  ),
                                  margin: EdgeInsets.only(
                                      bottom: SizeConfig.customMargin()),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                discovery.imgMain!),
                                            fit: BoxFit.cover,
                                          ),
                                          color: ColorSelect.accentColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        height: SizeConfig.screenHeight * 0.15,
                                        width: double.infinity,
                                      ),
                                      SizedBox(
                                        height: SizeConfig.screenHeight * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CustomTitle(
                                            title: "${discovery.title}",
                                            fontsize:
                                                SizeConfig.screenWidth * 0.04,
                                            color: ColorSelect.lastColor,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.screenWidth * 0.4,
                                          ),
                                          Text("${discovery.date}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Aucune découverte trouvée"));
          }
        },
      ),
    );
  }
}
