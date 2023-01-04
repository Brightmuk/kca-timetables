  import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
  
void launchExternalUrl(String url) async {

  Uri _url = Uri.parse(url);

  if (!await launchUrl(_url,mode:LaunchMode.externalApplication)){
    toast('Could not launch that url. Please confirm that the format is correct');
  }

}

