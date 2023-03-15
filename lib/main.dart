import 'package:flutter/material.dart';
import 'package:obhavo/network/network_api.dart';

import 'models/weather.dart';

void main() {
  runApp(MaterialApp(
    home: WeatherPage(),
  ));
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  TextEditingController txtController = TextEditingController();
  late Future<Weather> obHavo;

  @override
  void initState() {
    obHavo = NetworkApi().getWeather("Fergana");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ob havo"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/nature.jpeg",),fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: txtController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Shahar nomini kiriting...",
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white),
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  obHavo = NetworkApi().getWeather(txtController.value.text);
                });
              },
              child: Text("GET"),
              color: Colors.blue,
            ),
            SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder(
                  future: obHavo,
                  builder: (BuildContext context, AsyncSnapshot<Weather> obHavo) {
                    if (obHavo.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Image.network(
                                    "https:${obHavo.data!.current!.condition!.icon}"),
                                Text(
                                  obHavo.data!.current!.tempC.toString() + " °C",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            height: 140,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    obHavo.data!.forecast!.forecastday!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.all(15),
                                    width: 100,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent[200],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.network(
                                            "https:${obHavo.data!.forecast!.forecastday![index].day!.condition!.icon}"),
                                        Text(
                                          obHavo
                                                  .data!
                                                  .forecast!
                                                  .forecastday![index]
                                                  .day!
                                                  .avgtempC
                                                  .toString() +
                                              " °C",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(height: 3,),
                                        Text(obHavo
                                            .data!
                                            .forecast!
                                            .forecastday![index]
                                            .date!.toString())
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
