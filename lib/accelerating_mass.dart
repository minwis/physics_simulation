import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class AcceleratingMass extends StatefulWidget {
  AcceleratingMass({Key? key}) : super(key: key);

  @override
  AcceleratingMassState createState() => AcceleratingMassState();
}

double blockWidth = 50;

class AcceleratingMassState extends State<AcceleratingMass> 
  with TickerProviderStateMixin {
  double xPos = 0;
double velocity = 0;
double acceleration = 0.1;
late Ticker ticker;

  @override
  void initState() {
    super.initState();
    ticker = createTicker((Duration elapsed) {
      setState(() {
        double width = MediaQuery.sizeOf(context).width;
        if ( xPos < width - blockWidth ) {
          velocity += acceleration; // increase speed
          xPos += velocity;         // update position
        }
        else {
          velocity = 0;
          acceleration = 0;
        }
      });
    });
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: xPos,
            child: Container(width: blockWidth, height: 50, color: Colors.blue),
          ),
        ],
      ),
    );
  }
  
}
