import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class GarageInfoScreen extends StatefulWidget {
  const GarageInfoScreen({super.key});

  @override
  State<GarageInfoScreen> createState() => _GarageInfoScreenState();
}

class _GarageInfoScreenState extends State<GarageInfoScreen> {
  final carModelTextEditingController = TextEditingController();
  final carNumberTextEditingController = TextEditingController();

  List<String> carTypes = ["Car", "CNG", "bike"];
  String? selectedCarType;

  final _formKey = GlobalKey<FormState>();

  _submit(){
    if(_formKey.currentState!.validate()){
      Map driverCarInfoMap = {
        "car_model": carModelTextEditingController.text.trim(),
        "car_number":carNumberTextEditingController.text.trim(),
      };
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child("mechanic");
      userRef.child(currentUser!.uid).child("mechanic_details").set(driverCarInfoMap);
      //Fluttertoast.showToast(msg:"Car details has been saved");
      Navigator.push(context,MaterialPageRoute(builder: (c)=>............))
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },  
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme?),

                SizedBox(height: 20,),
                Text(
                  "Add Car Details",
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400:Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        mainAxisAlignment :MainAxisAlignment.center,
                        crossAxisAligment : CrossAxisAlignment.center,
                        children:[
                          TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            decoration: InputDecoration(
                              hintText: "CarModel",
                              hintStyle: TextStyle(
                                color:Colors.grey,
                              ),
                              filled: true,
                              fillColor: darkTheme? Colors.black45:Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                              ),
                              prefixIcon: Icon(Icons.person,color: darkTheme? Colors.amber.shade400:Colors.grey,)
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (text){
                              if(text == null || text.isEmpty){
                                return 'Name can\'t be empty';
                              }
                              if(text.length<2){
                                return "Please enter a valid name";
                              }

                            },
                            onChanged: (text) =>setState(() {
                              CarModelTextEditingController.text = text;
                            });,
                          )
                          SizedBox(height: 20,),

                          TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            decoration: InputDecoration(
                              hintText: "Car Number",
                              hintStyle: TextStyle(
                                color:Colors.grey,
                              ),
                              filled: true,
                              fillColor: darkTheme? Colors.black45:Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                              ),
                              prefixIcon: Icon(Icons.person,color: darkTheme? Colors.amber.shade400:Colors.grey,)
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (text){
                              if(text == null || text.isEmpty){
                                return 'Name can\'t be empty';
                              }
                              if(text.length<2){
                                return "Please enter a valid name";
                              }

                            },
                            onChanged: (text) =>setState(() {
                              CarNumberTextEditingController.text = text;
                            });,
                          )
                          SizedBox(height: 20,),

                          TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            decoration: InputDecoration(
                              hintText: "Name",
                              hintStyle: TextStyle(
                                color:Colors.grey,
                              ),
                              filled: true,
                              fillColor: darkTheme? Colors.black45:Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                              ),
                              prefixIcon: Icon(Icons.person,color: darkTheme? Colors.amber.shade400:Colors.grey,)
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (text){
                              if(text == null || text.isEmpty){
                                return 'Name can\'t be empty';
                              }
                              if(text.length<2){
                                return "Please enter a valid name";
                              }

                            },
                            onChanged: (text) =>setState(() {
                              CarModelTextEditingController.text = text;
                            });,
                          )
                          SizedBox(height: 20,),

                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              hintText:"Please Choose Car Type",
                              prefixIcon: Icon(Icons.car_crash,color: darkTheme? Colors.amber.shade400:Colors.grey,),
                              filled: true,
                              fillColor: darkTheme? Colors.black45:Colors.grey.shade200,
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )
                              )
                            ),
                            items: carTypes.map((car){
                              return DropdownMenuItem(
                                child: Text(
                                  car,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                value: car,
                              );
                            }).toList(), 
                            onChanged: (newValue){
                              setState(() {
                                selectedCarType = newValue.toString();
                              });
                            })
                            SizedBox(height: 20,),


                            ElevatedButton(onPressed: (){
                              _submit();
                            }, child:Text(
                              "Register"
                              style:TextStyle(
                                fontSize:20,
                              )
                            ))
                        ]
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
