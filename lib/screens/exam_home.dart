import 'package:flutter/material.dart';


class ExamsView extends StatefulWidget {
  const ExamsView({ Key? key }) : super(key: key);

  @override
  _ExamsViewState createState() => _ExamsViewState();
}

class _ExamsViewState extends State<ExamsView> {
  List<Map<String, dynamic>> exams = [
    {'name':'Maths','date':1},
    {'name':'Science','date':2},
    {'name':'English','date':2},
    {'name':'Kiswa','date':3},
    {'name':'Biology','date':4},
    {'name':'Physics','date':4},
    {'name':'Computer','date':6},
    {'name':'Business','date':6},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.separated(
          itemCount: 8,
          itemBuilder: (context, index){
            return Column(
              children: [
                index==0?Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(' ${exams[index]['date']} AUG '),
                const  Divider(height: 10,),
               ],
             ):Container(),
                ListTile(title: Text(exams[index]['name']),),
              ],
            );
          },
         separatorBuilder: ((context, index) {
           if(exams[index]['date']!=exams[index+1]['date']){
             return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(' ${exams[index+1]['date']} AUG '),
                const  Divider(height: 10,),
               ],
             );
           }else{
             return Container();
           }
         }), ),
      ),
    );
  }
}


