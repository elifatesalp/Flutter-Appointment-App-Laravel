import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/appointment_card.dart';
import 'package:flutter_application_1/components/beautycenter_card.dart';
import 'package:flutter_application_1/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/auth_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> beautycenter = {};
  List<dynamic> favList = [];
  List<Map<String, dynamic>> beautycenterCat = [
    {
      "icon": FontAwesomeIcons.scissors,
      "category": "Hair Design",
    },
    {
      "icon": FontAwesomeIcons.brush,
      "category": "Makeup",
    },
    {
      "icon": FontAwesomeIcons.earDeaf,
      "category": "Piercing & Tattoo",
    },
    {
      "icon": FontAwesomeIcons.hospital,
      "category": "Aesthetic",
    },
    {
      "icon": FontAwesomeIcons.handSparkles,
      "category": "Nail Art",
    },
    {
      "icon": FontAwesomeIcons.eyeDropper,
      "category": "Skin Care",
    },
    {
      "icon": FontAwesomeIcons.burst,
      "category": "Laser",
    },
    {
      "icon": FontAwesomeIcons.spa,
      "category": "Spa",
    },
    {
      "icon": FontAwesomeIcons.mars,
      "category": "Barber(for men)",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    beautycenter =
        Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;
    //print('user data is: $user');
    //print('favorite list is: $favList');

    return Scaffold(
      //if user is empty, then return progress indicator
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            user['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/phoebe.png'),
                            ),
                          ),
                        ],
                      ),
                      Config.spaceSmall,
                      //category listing
                      const Text(
                        'Category',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Config.spaceSmall,
                      //build category list
                      SizedBox(
                        height: Config.heightSize * 0.05,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List<Widget>.generate(
                              beautycenterCat.length, (index) {
                            return Card(
                              margin: const EdgeInsets.only(right: 20),
                              color: Config.primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FaIcon(
                                      beautycenterCat[index]['icon'],
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      beautycenterCat[index]['category'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Config.spaceSmall,
                      const Text(
                        'Appointment Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      beautycenter.isNotEmpty
                          ? AppointmentCard(
                              beautycenter: beautycenter,
                              color: Config.primaryColor,
                            )
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                  child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text('No Appointment Today',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ))))), //pass appointment details into here
                      Config.spaceSmall,
                      const Text(
                        'Top Beauty Center',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //list of beauty center
                      //display appointment card here
                      Config.spaceSmall,
                      Column(
                        children: List.generate(
                          user['beautycenter'].length,
                          (index) {
                            return BeautyCenterCard(
                              //route:'bc_details', //beautycenter_details de olabilir videoda doc_details
                              beautycenter: user['beautycenter'][index],
                              //if lates fav list contains particular beautycenter id, then show fav icon
                              isFav: favList.contains(
                                      user['beautycenter'][index]['bc_id'])
                                  ? true
                                  : false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
