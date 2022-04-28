
import 'package:flutter/material.dart';
import 'package:todo_sqflit/shared/components/Constance.dart';

class Newtasks extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context,indx)=>DefultCircle(tasks[indx])
        , separatorBuilder: (context,indx)=>Padding(
          padding: const EdgeInsets.only(left: 30,right: 40),
          child: Container(  width: double.infinity,
          height: 1,color: Colors.black,
          ),
        )
        , itemCount: tasks.length);


  }
}
