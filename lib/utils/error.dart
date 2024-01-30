// Flutter imports:
import 'package:Saksham/config/app_config.dart';
import 'package:flutter/material.dart';

// Project imports:


class ErrorPage extends StatefulWidget {
  final String? message;

  const ErrorPage({Key? key, this.message,}) : super(key: key);
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppConfig.loginBackground),
                    fit: BoxFit.fill,
                  )),
              child: Center(
                child: Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppConfig.appLogo),
                      )),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      '${widget.message ?? 'Invalid Purchase. Please activate from your server.'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.pinkAccent, fontSize: 24.0),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
