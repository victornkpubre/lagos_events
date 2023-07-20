import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lagos_events/domain/models/appuser.dart';
import 'package:lagos_events/domain/models/event.dart';
import 'package:lagos_events/data/repository/repositories/auth_repository.dart';
import 'package:lagos_events/data/repository/repositories/event_repository.dart';
import 'package:lagos_events/app/styles.dart';


class UploadPage extends StatefulWidget {
  final Size size;
  const UploadPage(this.size, {super.key});

  @override
  _UploadPageState createState() => _UploadPageState(size);
  
}

class _UploadPageState extends State<UploadPage> {
  Size size;
  EventRepository eventRepo = EventRepository();
  AuthRepository authRepo = AuthRepository();

  //State Variable
  bool loading = false;

  //Form Variables
  List<int> fees = [];
  List<String> tags = [];
  XFile? selectedImage;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController contactController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  

  _UploadPageState(this.size);


  
  // //***     Upload Functions    ****//
  Future<void> submit() async {
    var user = await authRepo.currentUser();
    if(user != null){
      if(validateForm()){
        Event event = Event(
          uid: user.uid,
          title: titleController.text,
          venue: venueController.text,
          contact: contactController.text,
          tags: tags,
          fees: fees,
          minFee: minFee(fees),
          date: DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute)
        );

        //Show CircleProgressIndicator
        showLoading();

        if(await eventRepo.createEvent(event, File(selectedImage!.path))) {
          showMessageAlertDialog('Event Submited');
          setState(() {
            clearForm();
          });
        }
        else {
          showMessageAlertDialog('Event Upload Error');
        }
        
        closeLoading();
        
      }
    }
    else {
      var user = await Navigator.pushNamed(context, '/auth');
      AppUser? appuser = user as AppUser?;
      if(appuser != null) {
        authRepo.login(user!);
      }
    }
  }
  int minFee(List<int> fees){
    fees.sort();
    return fees[0];
  }
  void showMessageAlertDialog(String message ){
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(message),
              const Divider(color: Colors.transparent),
            ], 
          ),
        );
      }
    );
  }
  bool validateForm(){
    if( fees.isNotEmpty){
      if( tags.isNotEmpty){
        if(titleController.text.isNotEmpty){
          if(venueController.text.isNotEmpty){
            if(contactController.text.isNotEmpty){
                if(selectedDate != null){
                  if(selectedImage != null){
                    if(selectedTime != null){
                      return true;
                    }else{
                      showMessageAlertDialog('Choose a Time');
                      return false;
                    }
                  }else{
                    showMessageAlertDialog('Choose an Image');
                    return false;
                  }
                }else{
                  showMessageAlertDialog('Choose a Date');
                  return false;
                }
            }else{
              showMessageAlertDialog('Enter a Contact Number');
              return false;
            }

          }else{
            showMessageAlertDialog('Enter Event Venue');
            return false;
          }
        }else{
          showMessageAlertDialog('Enter Event Title');
          return false;
        }
      }else{
        showMessageAlertDialog('Enter at least one Tag');  
        return false;
      }
    }else{
      showMessageAlertDialog('Enter at least one Gate Fee');  
      return false;
    }
  }
  void clearForm(){
    titleController.clear();
    venueController.clear();
    contactController.clear();
    feeController.clear();
    tagController.clear();
    fees = [];
    tags = [];
    selectedImage = null;
    selectedTime = null;
    selectedDate = null;
  }
  void showLoading(){
    setState(() {
      loading = true;
    });
  }
  void closeLoading(){
    setState(() {
      loading = false;
    });
  }

  // ***   Form Functions   ***//
  void addGateFee(int? fee){
    if(fee != null){
      setState(() {
        fees.add(fee);
      });
    }
    
  }
  void deleteGateFee(int? fee){
    if(fee != null){
      setState(() {
        fees.remove(fee);
      });
    }
    
  }

  void addTag(String tag){
    setState(() {
      tags.add(tag);
    });
    
  }
  void deleteTag(String tag){
    setState(() {
      tags.remove(tag);
    });
    
  }

  void chooseImage() async{
    var tempImage = await ImagePicker().pickImage(
      source: ImageSource.gallery
    );
    setState(() {
      selectedImage = tempImage;
    });
  }
  Widget listOfFeesWidget(){
    return Container(
      width: size.width*0.8,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: fees.length,
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: (){
              deleteGateFee(fees[index]);
            },
            child: Text(
              'N${fees[index]}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey
              ),
            ),
          );
        },
      ),
    );
  }
  Widget listOfTagsWidget(){
    return Container(
      width: size.width*0.8,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: (){
              deleteTag(tags[index]);
            },
            child: Text(
              '#${tags[index]}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Stack( children: <Widget>[
      Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image:  DecorationImage(
            image: AssetImage('assets/images/Moonlit_Asteroid.jpg'),
            fit: BoxFit.cover
          )
        ),
      ),

      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: purpleTint50, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Upload Event', style: titleStyle),
        ),
        body: 
        Stack(
          children: [
            SingleChildScrollView( child: Center(
              child: Column(
                children: <Widget>[

                  //Event Image
                  Column(
                    children: <Widget>[
                      Container(
                        child: selectedImage == null?
                          InkWell(
                            child: const Icon(Icons.image, size: 150, color: Colors.grey,),
                            onTap: (){
                              chooseImage();
                            },
                          ):
                          SizedBox(
                            width: size.width*0.7,
                            child: Image.file(File(selectedImage!.path)),
                          )
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                        ),
                        onPressed: (){
                          chooseImage();
                        },
                        child: const Text('Choose Event Image', style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1)),),
                      ),
                    ],
                  ),

                  //Title Entry
                  SizedBox(
                    width: size.width*0.8,
                    child: TextField(
                      controller: titleController,
                      style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1),),
                      decoration: const InputDecoration(
                        hintText: 'Event Title',
                        hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),                  
                      ),
                    ), 
                  ),

                  //Venue Entry
                  SizedBox(
                    width: size.width*0.8,
                    child: TextField(
                      controller: venueController,
                      style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1),),
                      decoration: const InputDecoration(
                        hintText: 'Event Venue',
                        hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),
                      ),
                    ), 
                  ),

                  //Tags
                  //List of Tags
                  Container(
                    child : tags.isEmpty?
                    const Divider(color: Colors.transparent):
                    listOfTagsWidget(),
                  ),
                  SizedBox(
                    width: size.width*0.8,
                    child : Row(
                      children: <Widget>[
                        SizedBox(
                          width: size.width*0.4,
                          child: TextField(
                            controller: tagController,
                            style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1)),
                            decoration: const InputDecoration(
                              hintText: 'Enter Tag',
                              hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),
                            ),
                            keyboardType: TextInputType.text,
                          ), 
                        ),

                        SizedBox(
                          width: size.width*0.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                            ),
                            onPressed: (){
                              if(tagController.value.text != ""){
                                setState(() {
                                  addTag(tagController.text.toString());
                                  tagController.clear();
                                });
                              }     
                            },
                            child: const Text('Add Tag', style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1))),
                          ),
                        ),      
                      ],
                    ),
                  ),

                  //Gate Fees
                  //List of Fees
                  Container(
                    child : fees.isEmpty?
                    const Divider(color: Colors.transparent):
                    listOfFeesWidget(),
                  ),
                  SizedBox(
                    width: size.width*0.8,
                    child : Row(
                      children: <Widget>[
                        SizedBox(
                          width: size.width*0.4,
                          child: TextField(
                            controller: feeController,
                            style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1)),
                            decoration: const InputDecoration(
                              hintText: 'Enter Gate Fee',
                              hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),
                            ),
                            keyboardType: TextInputType.number,
                          ), 
                        ),

                        SizedBox(
                          width: size.width*0.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                            ),
                            onPressed: (){
                              if(feeController.value.text != ""){
                                setState(() {
                                  addGateFee(int.tryParse(feeController.text.toString()));
                                  feeController.clear();
                                });
                              }     
                            },
                            child: const Text('Add Gate Fee', style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1))),
                          ),
                        ),      
                      ],
                    ),
                  ),

                  //Contact Number
                  SizedBox(
                    width: size.width*0.8,
                    child: TextField(
                      controller: contactController,
                      style: const TextStyle(color:Color.fromRGBO(207, 195, 226, 1),),
                      decoration: const InputDecoration(
                        hintText: 'Enter Contact Number',
                        hintStyle: TextStyle(color: Color.fromRGBO(207, 195, 226, 1), fontWeight: FontWeight.w200),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:  Color.fromRGBO(207, 195, 226, 1))),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(207, 195, 226, 1))),                  
                      ),
                      keyboardType: TextInputType.number,
                    ), 
                  ),
                  const SizedBox(height: 10),
                  
                  //Date n Time Entry
                  SizedBox(
                    width: size.width*0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: size.width*0.5,
                          child: Text(
                            "Date: ${DateFormat('yyyy/MM/dd').format(selectedDate??DateTime.now())}",
                            style: const TextStyle(fontSize: 18, color: Color.fromRGBO(207, 195, 226, 1)),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          width: size.width*0.5,
                          child: Text(
                            selectedTime==null?"Time: ${DateFormat('hh:mm').format(DateTime.now())}": "Time: ${selectedTime!.format(context)}", 
                            style: const TextStyle(fontSize: 18, color: Color.fromRGBO(207, 195, 226, 1)),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox( width: size.width*0.8, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded( 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                          ),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 1)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            ).then((datetime) {
                              if(datetime != null) {
                                setState(() {
                                  selectedDate = DateTime(datetime.year, datetime.month, datetime.day);
                                });
                              }
                            });
                          },
                          child: const Text('Pick Date', style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1))),
                        )
                      ),
                      Expanded( 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                          ),
                          onPressed: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.white,
                                      surface: duskWood,
                                      onSurface: greenAccent,
                                    ),
                                    buttonTheme: ButtonThemeData(
                                      colorScheme: ColorScheme.light(
                                        primary: greenAccent,
                                      ),
                                    ),
                                    textTheme: const TextTheme(
                                      labelSmall: TextStyle(color: Colors.white),
                                    )
                                  ),
                                  child: child??Container(),
                                );
                              },
                            ).then((time) {
                              if(time != null){
                                setState(() {
                                  selectedTime = time;
                                });
                              }
                            });
                          },
                          child: const Text('Pick Time', style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1))),
                        )
                      ),
                    ],
                  )),

                  const Divider(color: Colors.transparent),

                  SizedBox(
                    width: size.width*0.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: const Color.fromRGBO(72, 92, 99, 1),
                      ),
                      onPressed: (){
                        submit();
                      },
                      child: const Text('Submit Event', style: TextStyle(color: Color.fromRGBO(207, 195, 226, 1))),
                    )
                  ),

                  const Divider(color: Colors.transparent),
                  
                ],
              ),
            )),

            //Loading Screen
            loading? Container(
              height: size.height,
              width: size.width,
              color: Colors.black38,
              child: Center(
                child: SizedBox(
                  width: 35,
                  child: CircularProgressIndicator(color: greenAccent)
                )
              )
            ): Container()
          ],
        )
      )
    ],);
  }
}