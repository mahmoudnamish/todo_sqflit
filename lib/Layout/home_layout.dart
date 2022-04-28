
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_sqflit/modules/Archived_tasks.dart';
import 'package:todo_sqflit/modules/Done_tasks.dart';
import 'package:todo_sqflit/modules/New_tasks.dart';

import '../shared/components/Constance.dart';


class Homelayout extends StatefulWidget {
  @override
  State<Homelayout> createState() => _HomelayoutState();
}

class _HomelayoutState extends State<Homelayout> {

   Database database;

  List<Widget> Screen = [
     Newtasks(),
    Donetasks(),
    Archivedtasks(),
  ];
  List<String> text = ['NewTasks', ' DoneTasks', ' ArchivedTasks'];
  int currentindex = 0;
  var formkey = GlobalKey<FormState>();
  var scafoldkey = GlobalKey<ScaffoldState>();
  var titlecontrole = TextEditingController();
  var timecontroler = TextEditingController();
  var datecontroler = TextEditingController();
  bool showsheet = false;
  IconData iconshow = Icons.edit;


  @override
  void initState() {
    creatDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scafoldkey,
        appBar: AppBar(
          title: Text(text[currentindex],
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (showsheet) {
              if (formkey.currentState.validate()) {
                inserteDatabase(
                    title: titlecontrole.text,
                    time: timecontroler.text,
                    date: datecontroler.text)
                    .then((value) {

                  getdetdatafromDatabase(database).then((value) {

                    Navigator.pop(context);

                    setState(() {
                      tasks=value;

                      showsheet = false;
                      iconshow = Icons.edit;

                    });
                  });

                });
              }
            } else {
              scafoldkey.currentState?.showBottomSheet(

                    (context) => Form(
                  key: formkey,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defultFormFiled(
                            controller: titlecontrole,
                            type: TextInputType.name,
                            ontap: () {
                              print('the title tap');
                            },
                            validate: (value) {
                              if (value.isEmpty) {
                                return "please enter the data";
                              }
                              return null;
                            },
                            text: 'Title',
                            prefux: Icons.title),
                        //////////////////////////////
                        SizedBox(
                          height: 20,
                        ),
                        ///////////////////////////////////////
                        defultFormFiled(
                            controller: timecontroler,
                            type: TextInputType.datetime,
                            ontap: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                                  .then((value) {
                                timecontroler.text = value.format(context);
                              });
                            },
                            validate: (value) {
                              if (value.isEmpty) {
                                return "please enter the time";
                              }
                              return null;
                            },
                            text: 'Time',
                            prefux: Icons.watch_later_outlined),
                        /////////////////////////////////////////
                        SizedBox(
                          height: 20,
                        ),

                        /////////////////////////////////////////////
                        defultFormFiled(
                            controller: datecontroler,
                            type: TextInputType.datetime,
                            ontap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2023-06-08'))
                                  .then((value) {
                                datecontroler.text =
                                    DateFormat.yMMMd().format(value);
                              });
                            },
                            validate: (value) {
                              if (value.isEmpty) {
                                return "please enter the time";
                              }
                              return null;
                            },
                            text: 'Date Tasks',
                            prefux: Icons.watch_later_outlined),
                      ],
                    ),
                  ),
                ),
                elevation: 20.0,
              ).closed.then((value) {
                showsheet = false;
                setState(() {
                  iconshow = Icons.edit;
                });
              });

              setState(() {
                iconshow = Icons.add;
              });
              showsheet = true;
            }
          },
          child: Icon(iconshow),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: "Tasks"),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline), label: "Done"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_outlined,
                ),
                label: "Archived"),
          ],
          currentIndex: currentindex,
          onTap: (indx) {
            setState(() {
              currentindex = indx;
            });
          },
        ),
        body: ConditionalBuilder(condition: tasks.length > 0,
            builder: (context)=>Screen[currentindex],
            fallback: (context)=>Center(child: CircularProgressIndicator()))
    );
  }

  void creatDatabase() async {
    database = await openDatabase('TOdo.db', version: 1,
        onCreate: (database, version) {
          print('creat data base');
          database
              .execute(
              'CREATE TABLE tasks(ID INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT, status TEXT)')
              .then((value) {
            print("creat table");
          }).catchError((error) {
            print('error${error.toString()}');
          });
        },
        onOpen: (database) {

        });
  }

  Future inserteDatabase({
    @required String title,
    @required String time,
   @required String date,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title,time,date,status)VALUES("$title","$time","$date","new") ')
          .then((value) {
        print('${value}creat raw');
      }).catchError((error) {
        print('error${error.toString()}');
      });

      return Future(() => null);
    });
  }

  Future<List<Map>> getdetdatafromDatabase (database)async
  {
    return await database.rawQuery('SELECT * FROM tasks');

  }
}
