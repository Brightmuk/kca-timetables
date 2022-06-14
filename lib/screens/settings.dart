import 'package:excel_reader/services/notification_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final Uri _privacyUrl = Uri.parse('https://brightdesigns.space/privacy.html');
  final Uri _helpUrl = Uri.parse('https://brightdesigns.space/#contact');


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height*0.1,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                color: Color.fromARGB(255, 3, 4, 75),
              ),
              height: MediaQuery.of(context).size.height*0.1,
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
                  const Text('Settings',
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
              statusBarColor: primaryThemeColor,
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
                  title: const Text('Rate App',style: tileTitleTextStyle,),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),

                ),
               ListTile(
                  onTap: (){
                   launchUrl(_donateUrl);
                  },
                  title: const Text('Drop a gift',style: tileTitleTextStyle,),
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
      ),
    );
  }
    void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }
}