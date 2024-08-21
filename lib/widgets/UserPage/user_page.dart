import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class ClockPage extends StatefulWidget   {
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return clockOutDialog();
                      },
                    );
                  },
                  child: Text(
                    'Clock Out',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
          SizedBox(height: 30, width: 10),
          //break buttons
          (!isBreak && isClockedIn)
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return clockOutDialog();
                        });
                  },
                  child: Text('Take a Break'),
                )
              : (isClockedIn && isBreak)
                  ? ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return endBreaktDialog();
                            });
                      },
                      child: Text('End Break'),
                    )
                  : Container(),
        ],
      ),
    );
  }

  AlertDialog clockInDialog() {
    return AlertDialog(
      title: const Text('Warning'),
      content: const Text('Are you sure you want to clock in?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isClockedIn = false;
            });
            Navigator.of(context).pop();
          },
          child: const Text(
            'Clock In',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ],
    );
  }

  AlertDialog clockOutDialog() {
    return AlertDialog(
      title: const Text('Warning'),
      content: const Text('Are you sure you want to clock out?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isClockedIn = false;
            });
            Navigator.of(context).pop();
          },
          child: const Text(
            'Clock Out',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ],
    );
  }

  AlertDialog startBreaktDialog() {
    return AlertDialog(
      title: const Text('Warning'),
      content: const Text('Are you sure you want to take a break?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isClockedIn = false;
            });
            Navigator.of(context).pop();
          },
          child: const Text(
            'Start break',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ],
    );
  }

  AlertDialog endBreaktDialog() {
    return AlertDialog(
      title: const Text('Warning'),
      content: const Text('Are you sure you want to end your break?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isClockedIn = false;
            });
            Navigator.of(context).pop();
          },
          child: const Text(
            'End break',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ),
      ],
    );
  } //
}
