import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/button.dart';
import 'package:flutter_application_1/providers/dio_provider.dart';
import 'package:flutter_application_1/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components//custom_appbar.dart';
import '../models/auth_model.dart';

class BeautyCenterDetails extends StatefulWidget {
  const BeautyCenterDetails({
    Key? key,
    required this.beautycenter,
    required this.isFav,
  }) : super(key: key);
  final Map<String, dynamic> beautycenter;
  final bool isFav;

  @override
  State<BeautyCenterDetails> createState() => _BeautyCenterDetailsState();
}

class _BeautyCenterDetailsState extends State<BeautyCenterDetails> {
  Map<String, dynamic> beautycenter = {};
  //for favarite button
  bool isFav = false;

  @override
  void initState() {
    beautycenter = widget.beautycenter;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //get arguments passed from beautycenter card
    //final beautycenter = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        appBar: CustomAppBar(
          appTitle: 'Beauty Center Details',
          icon: const FaIcon(Icons.arrow_back_ios),
          actions: [
            //favorite button
            IconButton(
              //press this button to add/remove favorite beautycenter
              onPressed: () async {
                //get latest favorite list from auth model
                final list =
                    Provider.of<AuthModel>(context, listen: false).getFav;

                //if bc_id is already exist, mean remove the bc_id
                if (list.contains(beautycenter['bc_id'])) {
                  list.removeWhere((id) => id == beautycenter['bc_id']);
                } // else, add new beautycenter to favorite list
                else {
                  list.add(beautycenter['bc_id']);
                }
                //update the list into auth model and notify all widgets
                Provider.of<AuthModel>(context, listen: false).setFavList(list);
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final token = prefs.getString('token') ?? '';

                if (token.isNotEmpty && token != '') {
                  //update the favorite list into database
                  final response = await DioProvider().storeFavBc(token, list);
                  //if insert succesfully, then change the favorite status
                  if (response == 200) {
                    setState(() {
                      isFav = !isFav;
                    });
                  }
                }

                setState(() {
                  isFav = !isFav;
                });
              },
              icon: FaIcon(
                isFav ? Icons.favorite_rounded : Icons.favorite_outline,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              //pass beautycenter details here
              AboutBeautyCenter(
                beautycenter: beautycenter,
              ),
              DetailBody(
                beautycenter: beautycenter,
              ),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Button(
                    width: double.infinity,
                    title: 'Book Appointment',
                    onPressed: () {
                      //navigate to booking page
                      //pass beautycenter id for booking process
                      Navigator.of(context).pushNamed('booking_page',
                          arguments: {
                            "beautycenter_id": beautycenter['bc_id']
                          });
                    },
                    disable: false,
                  )),
              //güzellik salonu avatarı ve bilgileri burada yer alacak
            ],
          ),
        ));
  }
}

class AboutBeautyCenter extends StatelessWidget {
  const AboutBeautyCenter({super.key, required this.beautycenter});

  final Map<dynamic, dynamic> beautycenter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 65.0,
              backgroundImage: NetworkImage(
                  "http://127.0.0.1:8000${beautycenter['beautycenter_profile']}"),
              backgroundColor: Colors.white,
            ),
            Config.spaceMedium,
            Text(
              'BC ${beautycenter['beautycenter_name']}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
            SizedBox(
              width: Config.widthSize * 0.75,
              child: const Text(
                'HAIR CUT, HAIR DESIGN, OMBRE, SOMBRE, HAIR COLORING,KERATIN CARE, HIGHLIGHTS, AFRICAN BRAID, Everything about your hair.',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            Config.spaceSmall,
            const Text(
              'Adres: 6 Libanus Rd, Ebbw Vale NP23 6EJ, USA',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.beautycenter}) : super(key: key);
  final Map<dynamic, dynamic> beautycenter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      //margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.spaceSmall,
          BeautyCenterInfo(
              customers: beautycenter['customers'] ?? 0,
              exp: beautycenter['experience'] ?? 0),
          Config.spaceMedium,
          const Text(
            'About Beauty Center',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Config.spaceSmall,
          Text(
            'BC ${beautycenter['beautycenter_name']} employs award-winning ${beautycenter['category']}. BC ${beautycenter['beautycenter_name']} Founded on May 24, 1980. We are in 40 countries. CHOICE OF THE BEST',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          )
          //beauty center rating patient
        ],
      ),
    );
  }
}

class BeautyCenterInfo extends StatelessWidget {
  const BeautyCenterInfo({Key? key, required this.customers, required this.exp})
      : super(key: key);

  final int customers;
  final int exp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(label: 'Customers', value: '$customers'),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Experience',
          value: '$exp years',
        ),
        const SizedBox(
          width: 15,
        ),
        const InfoCard(
          label: 'Rating',
          value: '4.6',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Config.primaryColor,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 15, //change this size as well
            horizontal: 15,
          ),
          child: Column(children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ])),
    );
  }
}
