import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


String Temperature = '';
String Humidity = '';

BuildContext scaffoldContext;

displaySnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(msg),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  );
  Scaffold.of(scaffoldContext).showSnackBar(snackBar);
}

void main() {
  runApp(MaterialApp(
    title: "ESP8266 with DHT11",
    debugShowCheckedModeBanner: false,
    home: Dht_Status(),
  ));
}


class Dht_Status extends StatefulWidget{
  @override
  _Dht_StatusState createState() => _Dht_StatusState();


}

class _Dht_StatusState extends State<Dht_Status> {
  @override
  void initState() {
    super.initState();
    getDhtData();

  }

  String status = '';
  String url = 'http://192.168.1.40:80/'; //your PC IP address which is configured in the  Arduino IDE sketch.
  // the url here is representing the server
  // the 80 represent the http port


  var response;
  bool progressIndicator = true;

  getDhtData() async {
    try {
      //We are going to use await here because we want this to finish before storing it in the response variable
      // the response variable is provided by the http module, and it is going to provide us with the information from
      // the request we made to the URL in our case the pc is acting as the server holding the sensor data
      response = await http.get(url + 'dht', headers: {"Accept": "plain/text"});

      // the body of the response that is  the actual data we get back
      if (response.body == 'sensorError') {
        setState(() {
          status = 'DHT11 Not Connected';
          Temperature= '';
          Humidity = '';
          progressIndicator = false;
          displaySnackBar(context, 'Check DHT11 Connection');
        });
      } else {
        setState(() {
          status = 'DHT11 is Connected';
          progressIndicator = false;
        });

        //we need to use the substring tools, because the body we are getting is a string not
        // an object that can be accessed by the name of the property
        Temperature = response.body.substring(0, 4) + '°C';
        print('Temperature: ' + Temperature);

        Humidity = response.body.substring(5, 11) + '%';
        print('Humidity: ' + Humidity);

      }
    } catch (e) {

      print(e);
      if (this.mounted) {
        setState(() {
          status = 'ESP8266(NodeMCU) Not Connected';
          Temperature= '';

          Humidity= '';
          progressIndicator = false;
          displaySnackBar(context, 'Wi-Fi Connection Problem');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),

              ),
              Padding(
                padding: const EdgeInsets.all(60.0),

              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(
                    spacing:10,
                    runSpacing: 10.0,
                    children: <Widget>[
                      SizedBox(
                        width:190.0,
                        height: 190.0,
                        child: Card(

                          color: Colors.cyan[700],
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child:Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset("assets/Hot.png",width: 80.0,),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Tempretuer",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(Temperature,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                      SizedBox(
                        width:190.0,
                        height: 190.0,
                        child: Card(

                          color: Colors.cyan[700],
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child:Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset("assets/Humidity.png",width: 80.0,),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Humidity",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(Humidity,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                      progressIndicator
                          ? Container(
                        margin: const EdgeInsets.only(bottom: 15.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : Container(),
                      Container(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  progressIndicator = true;
                                });
                                getDhtData();
                              },
                              child: Text('Refresh Sensor data',
                              style: TextStyle(
                                color: Colors.white,)),
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.cyan[700])

                              ),
                            ),
                          ],
                        ),
                      ),
                       Center(
                        child: Text(
                          status,style: TextStyle(
                          color: Colors.white,
                        ),
                          textAlign: TextAlign.center,
                        ),
                      ),


                    ],
                  ),
                ),

              )


            ],

          )
      ),

    );
  }
}