  import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
  
void launchExternalUrl(String url) async {

  Uri _url = Uri.parse(url);

  if (!await launchUrl(_url)){
    toast('Could not launch that url. Please confirm that the format is correct');
  }

}

  int get timeIndex {
    
  int weekDay=DateTime.now().weekday;
  int hourOfDay = DateTime.now().hour;

  return (weekDay*10000)+(hourOfDay*100);

}



String timeLeft(String time,String day){
  int startTime;
  int endTime;
  try {
    endTime=int.parse(time.substring(5,9));
  } catch (e) {
    endTime = 0;
  }
  try {
    List val = time.split(" ");
    startTime=int.parse(val[0]);
  } catch (e) {
    startTime = 0;
  }
  DateTime now = DateTime.now();
  int recordDay = dayIndex(day);

if(recordDay-now.weekday==0&&(now.hour*100)>=startTime&&(now.hour*100)<endTime){
    return 'Ongoing';
  }
if(recordDay-now.weekday==0&&startTime-(now.hour*100)==1){
    return 'in ${60-now.minute} minutes';
  }
if(recordDay-now.weekday==0&&startTime-(now.hour*100)>100){
      return 'In ${(startTime-now.hour)/100} hours';
}
if(recordDay-now.weekday==1){
    return 'Tomorrow';
  }
if(recordDay-now.weekday==0&&endTime<(now.hour*100)){
    return 'done';
  }

return 'on $day';
}


int dayIndex(String day) {

  switch (day) {
    case 'MONDAY':
      return 1;
    case 'TUESDAY':
      return 2;
    case 'WEDNESDAY':
      return 3;
    case 'THURSDAY':
      return 4;
    case 'FRIDAY':
      return 5;
    case 'SATURDAY':
      return 6;
    default:
      return 0;
  }
}


String convertDay(String day) {
  switch (day) {
    case 'MONDAY':
      return 'MON';
    case 'TUESDAY':
      return 'TUE';
    case 'WEDNESDAY':
      return 'WED';
    case 'THURSDAY':
      return 'THUR';
    case 'FRIDAY':
      return 'FRI';
    case 'SATURDAY':
      return 'SAT';
    default:
      return '';
  }
}
  String dayFromWeekday(int weekDay) {
    switch (weekDay) {
      case 1:
        return 'MONDAY';
      case 2:
        return 'TUESDAY';
      case 3:
        return 'WEDNESDAY';
      case 4:
        return 'THURSDAY';
      case 5:
        return 'FRIDAY';
      case 6:
        return 'SATURDAY';
      default:
        return '';
    }
  }