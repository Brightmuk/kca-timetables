  int get timeIndex {
    
  int weekDay=DateTime.now().weekday;
  int hourOfDay = DateTime.now().hour;

  return (weekDay*10000)+(hourOfDay*100);
}



String timeLeft(String time,String day){
  int timeValue;
  try {
    List val = time.split(" ");
    timeValue=int.parse(time.substring(val[0].length-4,val[0].length));
  } catch (e) {
    timeValue = 0;
  }
  DateTime now = DateTime.now();
  int recordDay = dayIndex(day);

  if(recordDay-now.weekday>1){
    return 'In ${now.weekday-recordDay} days ';
  }else if(recordDay-now.weekday==1){
    return 'Tomorrow';
  }else if(recordDay-now.weekday<1&&timeValue>(now.hour*100)){
    return 'In ${timeValue-(now.hour*100)} hours';
  }else if(recordDay-now.weekday<1&&timeValue-(now.hour*100)<0){
    return 'done';
  }else if(recordDay-now.weekday<1&&timeValue-(now.hour*100)<1){
    return 'in minutes';
  }else if(timeValue==(now.hour*100)){
    return 'Ongoing';
  }else{
    return '';
  }
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