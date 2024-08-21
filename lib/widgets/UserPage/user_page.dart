import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _UserPageState();
}

class _UserPageState extends State<ClockPage> {
  var isClockedIn = false;
  var isBreak = false;
  var isClockedOut = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clock Screen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Center(child: Text('Hello world')),
          Center(
            child: AnalogClock(
              height: 300.0,
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.black),
                  color: Colors.transparent,
                  shape: BoxShape.circle),
              width: 150.0,
              isLive: true,
              hourHandColor: Colors.black,
              minuteHandColor: Colors.black,
              showSecondHand: true,
              secondHandColor: Colors.red,
              numberColor: Colors.black87,
              showNumbers: true,
              showAllNumbers: false,
              textScaleFactor: 1.4,
              showTicks: true,
              showDigitalClock: true,
              datetime: DateTime.now(),
            ),
          ),
          //this text wild show info, like hours worked, break time, etc
          //Text(''),

          //clock buttons
          !isClockedIn
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isClockedIn = true;
                    });
                  },
                  child: Text('Clock In'),
                )
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isClockedIn = false;
                    });
                  },
                  child: Text('Clock Out'),
                ),

          //break buttons
          (!isBreak && isClockedIn)
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isBreak = true;
                    });
                  },
                  child: Text('Take a Break'),
                )
              : (isClockedIn && isBreak)
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isBreak = false;
                        });
                      },
                      child: Text('End Break'),
                    )
                  : Container(),
        ],

      ),
    );
  }
}
