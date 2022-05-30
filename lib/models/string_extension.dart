extension StringExt on String{
  String capitalise(){
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}