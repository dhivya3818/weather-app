import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void main () => runApp(
  MaterialApp(
    title: "Weather App",
    home: Home(),
  )
);

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState () {
    return HomeState();
  }
}

class HomeState extends State<Home> {

  var current;
  var temp;
  var description;
  var humidity;
  var windSpeed;
  final cityController = TextEditingController();
  var city = "London";

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  Future getWeather() async {
    var str = "http://api.openweathermap.org/data/2.5/weather?q=" + city + "&units=metric&appid=51d36fb1e163ecda8bb3a8c4d2b91246";
    http.Response response = await http.get(str);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.current = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget> [
        Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width, 
          color: Colors.red[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                "What's good dhivs my g", 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 14.0, 
                  fontWeight: FontWeight.w300
                ),
              ),
            ),
            Text(
              "Currently in " + (city), 
              style: TextStyle(
                color: Colors.white, 
                fontSize: 30.0, 
                fontWeight: FontWeight.w600
              )
            ),
            Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Text(
                current, 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 14.0, 
                  fontWeight: FontWeight.w600
                ),
              ),
            )
          ],)
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget> [
                TextFormField(
                  controller: cityController,
                  onFieldSubmitted: (String text) => setState(() {
                    city = text;
                    cityController.clear();
                    this.getWeather();
                  }),
                      decoration: new InputDecoration(
                        labelText: "Enter a City",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "No city was entered"; }
                          else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                ),
                Padding(padding: EdgeInsets.all(5.0)),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerHalf), 
                  title: Text("temperature"),
                  trailing: Text(temp != null ? temp.toString() + "\u00B0" : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud), 
                  title: Text("weather"),
                  trailing: Text(description != null ? description : "Loading"),
                ),ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun), 
                  title: Text("humidity"),
                  trailing: Text(humidity != null ? humidity.toString() : "Loading"),
                ),ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind), 
                  title: Text("wind speed"),
                  trailing: Text(windSpeed != null ? windSpeed.toString() : "Loading"),
                )
              ],
              ),
          ),
          )
      ],)
    );
  }
}