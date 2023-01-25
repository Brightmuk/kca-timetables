import 'package:excel_reader/services/notification_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsRing=false;
    final Uri _playStoreUrl =
      Uri.parse('market://details?id=com.brightdesigns.kcatimetables');
  final Uri _donateUrl = Uri.parse(
      "https://www.paypal.com/donate/?hosted_button_id=Q2HUSVA4CCTTN");
  final Uri _privacyUrl = Uri.parse('http://brightdesigns.space/privacy.html');
  final Uri _helpUrl = Uri.parse('http://brightdesigns.space/#contact');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height*0.1,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              color: Color.fromARGB(255, 3, 4, 75),
            ),
            height: MediaQuery.of(context).size.height*0.15,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[

                IconButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Text('Settings',
                    style: headerTextStyle),
                IconButton(
                  padding: const EdgeInsets.all(20),
                  onPressed: () {
                    
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.transparent,
                  ),
                ),

              ],
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(255, 3, 4, 75),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
          leading: IconButton(
            padding: const EdgeInsets.all(20),
            onPressed: ()async {

              Navigator.pop(context);

            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Color.fromRGBO(3, 4, 94, 1),
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(children: [
              // SizedBox(height: 30,),
              // ListTile(
              //   title: Text('NOTIFICATIONS',style: tileTitleTextStyle.copyWith(color: secondaryThemeColor),),

              // ) ,
              // Divider(height: 10,),
              // SwitchListTile(
              //   activeTrackColor: secondaryThemeColor.withOpacity(0.5),
              //   activeColor: secondaryThemeColor,
              //   title: Text('Ring',style: tileTitleTextStyle,),
              //   value: notificationsRing,
              //   onChanged: (val){
              //     setState(() {
              //       notificationsRing=val;
              //     });
              //   },
              // ),
              
              SizedBox(height: 30,),
              ListTile(
                title: Text('INFO',style: tileTitleTextStyle.copyWith(color: secondaryThemeColor),),

              ) ,
              Divider(height: 10,),

              ListTile(
                onTap: (){
                 showDialog(
                   barrierDismissible: false,
                   context: context, builder: (_)=>const AboutUs()
                   );
                },
                title: Text('About',style: tileTitleTextStyle,),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),

              ),
              ListTile(
                onTap: (){
                  launchUrl(_helpUrl);
                },
                title: Text('Help',style: tileTitleTextStyle,),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              ListTile(
                onTap: (){
                  launchUrl(_privacyUrl);
                },
                title: Text('Terms / Privacy',style: tileTitleTextStyle,),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              ListTile(
                onTap: (){
                 launchUrl(_playStoreUrl);
                },
                title: Text('Rate App',style: tileTitleTextStyle,),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),

              ),
             ListTile(
                onTap: (){
                  // NotificationService().showTimeoutNotification(3000);
                 launchUrl(_donateUrl);
                },
                title: Text('Drop a gift',style: tileTitleTextStyle,),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),

              ),

            ],),
            Positioned(
                bottom: 50,
                child:  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String version = snapshot.data!.version;
                        return Text(
                          'VERSION $version',
                          style: TextStyle(color: Color.fromARGB(255, 116, 116, 116), fontSize: 13,fontWeight: FontWeight.w400),
                        );
                      } else {
                        return Container();
                      }
                    })
            )
          ],
        )
    );
  }
    void _launchUrl(Uri url) async {
    if (!await launchUrl(url,mode: LaunchMode.externalApplication)) throw 'Could not launch $url';
  }
}


class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: EdgeInsets.zero,
      title: Container(
          decoration: const BoxDecoration(
            color: primaryThemeColor,
            borderRadius:BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
          height: 100.sp,
          
          child: const Center(
              child: Text('About KCA Timetables',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)))),
      content: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
            "KCA Timetables is a mobile app that gives a neat and simplified view of the KCA university timetables(Class timetables and exam timetables).It's specifically tailored for KCA university timetables only and allows the students to scan the excel timetable documents to obtain data concerning their respective courses and period."),
      ),
      actions: [
        MaterialButton(
          child: const Text('CLOSE',style: TextStyle(color: secondaryThemeColor),),
          onPressed: () {
          Navigator.pop(context);
        })
      ],
    );
  }
}