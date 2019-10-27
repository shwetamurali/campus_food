import 'package:campus_food/map_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'frame.dart';
import 'place_data.dart';

class FoodOrFriendsCreator extends StatefulWidget {
  Place currentPlace;


  FoodOrFriendsCreator(this.currentPlace);

  @override
  FoodOrFriendsCreatorState createState() => FoodOrFriendsCreatorState(currentPlace);
}

class FoodOrFriendsCreatorState extends State<FoodOrFriendsCreator> {
  NewType type;
  String name;
  Place currentPlace;
  List<bool> isSelectedToggleButton = [false, false];

  FoodOrFriendsCreatorState(this.currentPlace);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create New",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: ToggleButtons(
                                  children: <Widget>[
                                    Text(
                                      'Food',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      'Friends',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                  onPressed: (int i) {
                                    setState(() {
                                      for (int buttonIndex = 0; buttonIndex < isSelectedToggleButton.length; buttonIndex++) {
                                        if (buttonIndex == i) {
                                          isSelectedToggleButton[buttonIndex] = true;
                                        } else {
                                          isSelectedToggleButton[buttonIndex] = false;
                                        }
                                      }
                                      if (isSelectedToggleButton[0] == true) {
                                        type = NewType.FOOD;
                                      } else {
                                        type = NewType.MEAL;
                                      }
                                    });
                                  },
                                  isSelected: isSelectedToggleButton,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: TextField(
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder()),
                                  maxLength: 30,
                                  onChanged: (text) {
                                    name = text;
                                  },
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FrameState().build(context),
              ));
        },
      ),
    );
  }
}

enum NewType { FOOD, MEAL }