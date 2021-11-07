import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "FitBand",
    home: const HomePage(),
    theme:ThemeData(
          primarySwatch: Colors.green,
        )
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text("FitBand"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:const <Widget>[
              Expanded(flex:1,child:FitBandCard(fitbandParameter: "Body Temperature (celcius)", fitbandParameterValue: "37°"),
             ),
             Expanded(flex:1,child:FitBandCard(fitbandParameter: "Steps Taken", fitbandParameterValue: "259"),
             ),
             Expanded(flex:1,child:FitBandCard(fitbandParameter: "Heart Rate (beats/minute)", fitbandParameterValue: "71"),
             ), ]
          ),
        ),
      ),
    floatingActionButton: FloatingActionButton(onPressed: (){},
    child: const Icon(Icons.connect_without_contact),),
    );
  }
}

class FitBandCard extends StatefulWidget {
  const FitBandCard({Key?key,
  required this.fitbandParameter,
  required this.fitbandParameterValue}): super(key: key);

  final String fitbandParameter;
  final String fitbandParameterValue;

  @override
  _FitBandCardState createState() => _FitBandCardState();
}

class _FitBandCardState extends State<FitBandCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
             Text(widget.fitbandParameter,style:const TextStyle(
                 color: Colors.green,
                 fontWeight: FontWeight.bold,
                 fontSize: 25,
                 overflow: TextOverflow.visible,
             )),
             Text(widget.fitbandParameterValue,style:const TextStyle(
                 color:Colors.black54,
                 fontWeight: FontWeight.bold,
                 fontSize: 80,
                 overflow: TextOverflow.visible,
             ))
          ],
        ),
      ),
    );
  }
}