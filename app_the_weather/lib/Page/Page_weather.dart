import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'Main_drawer.dart';

class page_weather extends StatefulWidget {
  const page_weather({Key key,
    @required this.user}) : super(key: key);
  final String user;


  @override
  _page_weatherState createState() => _page_weatherState();
}

class _page_weatherState extends State<page_weather> {
  int current=0;
  bool isSearching = false;
  String searchApiurl='https://www.metaweather.com/api/location/search/?query=';
  String spiUrl='https://www.metaweather.com/api/location/';
  String abbrevation='';
  String weathername='';
  int windspeed;
  int humidity;
  int maxtemp;
  int mintemp;

  var minTemperature=new List(6);
  var maxTemperature=new List(6);
  var abbrevationTemperature=new List(6);
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

  String location;
  int woeid;
  //thoi tiet chi tiet
  int temperature;
  String weather;
  bool isData=false;
  String errorMessage='';

  String dayAddr1='c';
  String dayAddr2='c';
  String dayAddr3='c';
  String dayAddr4='c';



   fethchMath(String input) async{
    try {
      var searchResult = await get(searchApiurl + input);
      var result = json.decode(searchResult.body)[0];

      setState(() {
        location = result['title'];
        woeid = result['woeid'];
        errorMessage='';
      });
    }catch(error)
    {
      setState(() {
        errorMessage='Sorry i done have about the city data. Try anther one';
        removeErrorMessage();
      });
    }
  }



   fetchLocation() async{
    var locationResult = await get (spiUrl+ woeid.toString());
    var result=json.decode(locationResult.body);
   var consolidate_weather= result['consolidated_weather'];
   var data = consolidate_weather[0];

    setState(() {
      temperature= data['the_temp'].round();
      weather=(data['weather_state_name']).replaceAll(' ', '').toLowerCase();
      abbrevation =data['weather_state_abbr'];
      weathername=data['weather_state_name'];
      windspeed=data['wind_speed'].round();
      humidity=data['humidity'].round();
      maxtemp=data['max_temp'].round();
      mintemp=data['min_temp'].round();

    });
  }

   fetchLocationDay() async
  {
      var today = new DateTime.now();
      for (int i = 0; i < 6; i++) {
        var locationResult = await get(spiUrl + woeid.toString()+'/'+ new DateFormat('y/M/d').format(today.add(new Duration(days:i))).toString()+'/');
        var result = json.decode(locationResult.body);
        var data = result[0];
        setState(() {
          minTemperature[i] = data['min_temp'].round();
          maxTemperature[i] = data['max_temp'].round();
           abbrevationTemperature[i] = data['weather_state_abbr'];
        });
      }
      dayAddr1=abbrevationTemperature[1];
      dayAddr2=abbrevationTemperature[2];
      dayAddr3=abbrevationTemperature[3];
      dayAddr4=abbrevationTemperature[4];
  }
  removeErrorMessage() async
  {
    Future.delayed(Duration(seconds: 1),() => errorMessage='');
  }

  Future<void> onTextFielSubmid(String input) async {
    await fethchMath(input);
    await fetchLocationDay();
    await fetchLocation();
  }
  load (String local) async{
     if(temperature != null) {
       setState(() {
         isData=true;
       }
       );
     }else
       {
         onTextFielSubmid(local);
         Future.delayed(Duration(seconds: 1),()=> load(local));
       }

  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      load(place.locality);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState()  {
    super.initState();

    _getCurrentLocation();
  }
  Widget build(BuildContext context) {
    return isData==false? new Center(
      child: new CircularProgressIndicator(),

    ): Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient:LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5)

                      ],
                      stops: [0.1,0.4,0.7,0.9]

                  ),
                image: DecorationImage(
                  image: AssetImage('assets/images/background/$weather.png'),

                  fit: BoxFit.cover,
                )
              ),
            ),

            Container(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      //height: 0 ,
                      width: double.infinity,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          IconButton(
//                            icon: Icon(Icons.person_pin),
//                            color: Colors.white,
//                            onPressed: () => print('menu'),
//                            iconSize: 25,
//                          ),
//                           !isSearching? Text(location,style: TextStyle(
//                                color: Colors.white,
//                                fontFamily: 'OpenSans',
//
//                                fontSize: 20.0
//                            ),):
//                           Container(
//                             width: 285,
//                             child: TextField(
//                               style: TextStyle(color: Colors.white),
//                               onSubmitted: (input){
//                                 onTextFielSubmid(input);
//                                 setState(() {
//                                   this.isSearching=false;
//
//                                 });
//                               },
//                               decoration: InputDecoration(
//                                 icon: Icon(Icons.search,color: Colors.white,),
//                                 focusColor: Colors.white,
//                                 fillColor: Colors.white,
//
//                                 hintText: 'Enter a your city',
//                                 hintStyle: TextStyle(color: Colors.white)
//                               ),
//                             ),
//                           ) ,
//
//                          isSearching? IconButton(
//                            icon: Icon(Icons.cancel),
//                            color: Colors.white,
//                            iconSize: 25,
//                            onPressed: (){
//                              setState(() {
//                                this.isSearching=false;
//                              }
//                              );
//
//                            },
//                          ): IconButton(
//                            icon: Icon(Icons.search),
//                            color: Colors.white,
//                            iconSize: 25,
//                            onPressed: (){
//                              setState(() {
//                                this.isSearching=true;
//                              });
//                            },
//                          ),
//
//                        ],
//                      ),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      title: !isSearching? Center(
                        child: Text(location,style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',

                            fontSize: 20.0
                        ),),
                      ):
                      Center(
                        child: Container(
                          width: 285,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            onSubmitted: (input){
                              onTextFielSubmid(input);
                              setState(() {
                                this.isSearching=false;

                              });
                            },
                            decoration: InputDecoration(
                                icon: Icon(Icons.search,color: Colors.white,),
                                focusColor: Colors.white,
                                fillColor: Colors.white,

                                hintText: 'Enter a your city',
                                hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                        ),
                      ),
                      leading: GestureDetector(
                        onTap: () { _scaffoldKey.currentState.openDrawer(); },
                        child: Icon(
                          Icons.menu,  // add custom icons also
                        ),
                      ),
                      actions: <Widget>[
                        isSearching? IconButton(
                          icon: Icon(Icons.cancel),
                          color: Colors.white,
                          iconSize: 25,
                          onPressed: (){
                            setState(() {
                              this.isSearching=false;
                            }
                            );

                          },
                        ): IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.white,
                          iconSize: 25,
                          onPressed: (){
                            setState(() {
                              this.isSearching=true;
                            });
                          },
                        ),
                      ],
                      ),
                      ),





                    Text(errorMessage,style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15
                    ),),
                    SizedBox(height: 50,),
                    Container(
                      height: 250,
                      child: PageView(
                        controller: PageController (viewportFraction: 0.7),
                        scrollDirection: Axis.horizontal,
                        pageSnapping: true,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 13),
                            width: 230,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(131, 183, 243, 0.8),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text('Today, '+(DateFormat.jm().format(DateTime.now())).toString(),style:TextStyle(
                                      color: Color.fromRGBO(213, 229, 247, 1),
                                    ) ,)
                                ),
                                SizedBox(height: 10,),
                                Image.network('https://www.metaweather.com//static/img/weather/png/$abbrevation.png',height: 90,width: 90,),
                                SizedBox(height: 10,),
                                Text(temperature.toString()+ ' °C',style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25
                                ),),
                                SizedBox(height: 5,),
                                Text(weathername,style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13
                                ),),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Image(image: AssetImage('assets/images/wind.png'),height: 25,width: 25,),
                                          SizedBox(height: 5,),
                                          Text('Wind N $windspeed km/h',style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10
                                          ),)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Image(image: AssetImage('assets/images/temprature.png'),height: 25,width: 25,),
                                          SizedBox(height: 5,),
                                          Text('humidity '+ humidity.toString()+'%',style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10
                                          ),)
                                        ],
                                      ),
                                    )
                                  ],
                                )


                              ],
                            )
                        ),//12 pm
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 13),
                              width: 230,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(131, 183, 243, 0.8),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      child: Text('Today, 16.00pm',style:TextStyle(
                                        color: Color.fromRGBO(213, 229, 247, 1),
                                      ) ,)
                                  ),
                                  SizedBox(height: 10,),
                                  Image( image: AssetImage('assets/images/rain.png'),height: 90,width: 90,),
                                  SizedBox(height: 10,),
                                  Text(temperature.toString()+' °C',style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),),
                                  SizedBox(height: 5,),
                                  Text('Partly Cloudy',style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13
                                  ),),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          children: <Widget>[
                                            Image(image: AssetImage('assets/images/wind.png'),height: 25,width: 25,),
                                            SizedBox(height: 5,),
                                            Text('Wind 5km/h',style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10
                                            ),)
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Column(
                                          children: <Widget>[
                                            Image(image: AssetImage('assets/images/temprature.png'),height: 25,width: 25,),
                                            SizedBox(height: 5,),
                                            Text('Humidity 28%',style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10
                                            ),)
                                          ],
                                        ),
                                      )
                                    ],
                                  )


                                ],
                              )
                          ),//16 pm
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 13),
                              width: 230,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(131, 183, 243, 0.8),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      child: Text('Today, 21.00pm',style:TextStyle(
                                        color: Color.fromRGBO(213, 229, 247, 1),
                                      ) ,)
                                  ),
                                  SizedBox(height: 10,),
                                  Image( image: AssetImage('assets/images/moon.png'),height: 90,width: 90,),
                                  SizedBox(height: 10,),
                                  Text('22 C',style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),),
                                  SizedBox(height: 5,),
                                  Text('Partly Cloudy',style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13
                                  ),),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          children: <Widget>[
                                            Image(image: AssetImage('assets/images/wind.png'),height: 25,width: 25,),
                                            SizedBox(height: 5,),
                                            Text('Wind 10km/h',style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10
                                            ),)
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Column(
                                          children: <Widget>[
                                            Image(image: AssetImage('assets/images/temprature.png'),height: 25,width: 25,),
                                            SizedBox(height: 5,),
                                            Text('Humidity 26%',style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10
                                            ),)
                                          ],
                                        ),
                                      )
                                    ],
                                  )


                                ],
                              )
                          ),//21
                        ],
                      ),
                    ),//thong bao do c
                    SizedBox(height: 70,),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration:BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.cyanAccent,
                                )
                              )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 90,
                                    child: Text('Today',style: TextStyle(
                                        //color: Colors.black,
                                        fontSize: 17
                                    ),),
                                  ),
                                  Image.network('https://www.metaweather.com//static/img/weather/png/$abbrevation.png',height: 25,width: 25,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(maxtemp.toString()+ ' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16

                                      ),),
                                      SizedBox(width: 15,),
                                      Text(mintemp.toString()+ ' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300

                                      ),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),//today
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration:BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: Colors.cyanAccent,
                                    )
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 90,
                                    child: Text('Tomorrow',style: TextStyle(
                                      //color: Colors.black,
                                        fontSize: 17
                                    ),),
                                  ),

                                  Image.network(('https://www.metaweather.com//static/img/weather/png/$dayAddr1.png'),height: 25,width: 25,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(maxTemperature[1].toString()+ ' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16

                                      ),),
                                      SizedBox(width: 15,),
                                      Text(minTemperature[1].toString()+' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300

                                      ),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration:BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: Colors.cyanAccent,
                                    )
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 90,
                                    child: Text(new DateFormat('EEEE').format(DateTime.now().add(new Duration(days:2))).toString(),style: TextStyle(
                                      //color: Colors.black,
                                        fontSize: 17
                                    ),),
                                  ),
                                  Image.network(('https://www.metaweather.com//static/img/weather/png/$dayAddr2.png'),height: 25,width: 25,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(maxTemperature[2].toString()+ ' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16

                                      ),),
                                      SizedBox(width: 15,),
                                      Text(minTemperature[2].toString()+ ' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300

                                      ),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration:BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: Colors.cyanAccent,
                                    )
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 90,
                                    child: Text(new DateFormat('EEEE').format(DateTime.now().add(new Duration(days:3))).toString(),style: TextStyle(
                                      //color: Colors.black,
                                        fontSize: 17
                                    ),),
                                  ),
                                  Image.network(('https://www.metaweather.com//static/img/weather/png/$dayAddr3.png'),height: 25,width: 25,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(maxTemperature[3].toString()+ ' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16

                                      ),),
                                      SizedBox(width: 15,),
                                      Text(minTemperature[3].toString()+ ' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300

                                      ),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration:BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: Colors.cyanAccent,
                                    )
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: 90,
                                    child: Text(new DateFormat('EEEE').format(DateTime.now().add(new Duration(days:4))).toString(),style: TextStyle(
                                      //color: Colors.black,
                                        fontSize: 17
                                    ),),
                                  ),
                                  Image.network(('https://www.metaweather.com//static/img/weather/png/$dayAddr4.png'),height: 25,width: 25,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(maxTemperature[4].toString()+ ' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16

                                      ),),
                                      SizedBox(width: 15,),
                                      Text(minTemperature[4].toString()+ ' °C',style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300

                                      ),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],


                ),
              ),
            ),

          ],
        ),
      ),
      drawer: mainDrawer(),

    );
  }

}
