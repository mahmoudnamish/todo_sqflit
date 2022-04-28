import 'package:flutter/material.dart';

Widget defultButtom({
  double width = double.infinity,
  Color bachground = Colors.blue,
  bool isUpperCase = true,
  @required Function function,
  @required String text,
}) =>
    Container(
      width: width,
      color: bachground,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defultFormFiled({
  @required TextEditingController  controller,
  @required  TextInputType type,
  @required  Function  validate,
  @required  text,
  Function  onSubmitted,
  Function  onChanged,
  Function  ontap,
  @required IconData  prefux,
  IconData  sufex,

}) => TextFormField(

      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      validator: validate,
      onTap:ontap,
      decoration: InputDecoration(
        labelText: text,
        prefixIcon: Icon(
          prefux,
        ),
        suffixIcon: sufex != null ? Icon(sufex) : null,
        border: OutlineInputBorder(),
      ),
    );

Widget DefultCircle (Map model)=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      CircleAvatar(radius: 40,child: Text(model['time'])),
      SizedBox(width: 15,),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model['title'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40)),
          SizedBox(width: 15,),
          Text(model['date'],style: TextStyle(fontSize: 20,color: Colors.grey))
        ],)


    ],
  ),
);

List<Map> tasks=[];


