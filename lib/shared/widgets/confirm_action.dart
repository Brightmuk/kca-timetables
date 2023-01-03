import 'package:flutter/material.dart';

class ConfirmAction extends StatelessWidget {
  final String text;

  const ConfirmAction({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async{
        return false;
      }),
      child: Container(
        margin: EdgeInsets.all(20),
        height: 150,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
               text,
               textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(),
                  MaterialButton(
                     padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context,true);
                    },
                    child: const Text('Yes'),
                    color: Colors.redAccent,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context,false);
                    },
                    child: const Text('No'),
                    color: const Color.fromARGB(255, 201, 174, 20),
                  ),
                  const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}