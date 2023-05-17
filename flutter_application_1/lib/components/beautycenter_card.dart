import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/beautycenter_details.dart';
import 'package:flutter_application_1/utils/config.dart';
import 'package:flutter_application_1/main.dart';

//bunu stateless olarak değiştiriyoruz
class BeautyCenterCard extends StatelessWidget {
  const BeautyCenterCard({
    Key? key,
    required this.beautycenter,
    required this.isFav,
  }) : super(key: key);

  final Map<String, dynamic> beautycenter; //receive beautycenter details
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                child: Image.network(
                  "http://127.0.0.1:8000${beautycenter['beautycenter_profile'] ?? ''}", //change this
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "BC ${beautycenter['beautycenter_name'] ?? ''}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${beautycenter['category'] ?? ''}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const <Widget>[
                          Icon(
                            Icons.star_border,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Text('4.5'),
                          Spacer(
                            flex: 1,
                          ),
                          Text('Reviews'),
                          Spacer(
                            flex: 1,
                          ),
                          Text('(20)'),
                          Spacer(
                            flex: 7,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          //direkt beauty center details sayfasına gönderecek
          //Navigator.of(context).pushNamed(route, arguments: beautycenter);
          MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (_) => BeautyCenterDetails(
                    beautycenter: beautycenter,
                    isFav: isFav,
                  )));
        },
      ), //redirect to beauty center details
    );
  }
}
