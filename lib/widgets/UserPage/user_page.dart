import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/reusable/Firestore_methods.dart';
import 'package:one_clock/one_clock.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});
  @override
  State<ClockPage> createState() => _UserPageState();
}

class _UserPageState extends State<ClockPage> {
  var isClockedIn = false;
  var breakCount = 0;
  var isBreak = false;
  var isClockedOut = false;
  final user = FirebaseAuth.instance.currentUser;
  FirestoreMethods firestoreMethods = FirestoreMethods();

  bool isLoading = false;

  bool dayFinished = false;
  bool isLunchOver = false;

  @override
  void initState() {
    super.initState();

    checkDayStatus();
  }

  void checkDayStatus() async {
    try {
      isLoading = true;
      setState(() {});
      final data = await firestoreMethods.getWorkSessions(userId: user!.uid);

      final jsondata = data.data();

      if (jsondata == null) {
        print("jsondata is null, returning");
        return;
      }
      if (jsondata['startTime'] != null && jsondata['Endtime'] != null) {
        print(
            "startTime and endTime are not null, setting dayFinished to true");
        dayFinished = true;
        setState(() {});
        return;
      }

      if (jsondata["startTime"] != null) {
        print("startTime is not null, setting isClockedIn to true");
        isClockedIn = true;

        if (jsondata['breakTimeStart'] != null &&
            jsondata['breakTimeEnd'] != null) {
          print(
              "breakTimeStart and breakTimeEnd are not null, setting isLunchOver to true");
          isLunchOver = true;
        }

        if (jsondata['breakTimeStart'] != null) {
          print("breakTimeStart is not null, setting isBreak to true");
          isBreak = true;
        }
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    final user = await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clock Screen'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: checkDayStatus, icon: Icon(Icons.refresh)),
          IconButton(onPressed: logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                dayFinished
                    ? Center(
                        child: Column(children: [
                        Text('Su dia ha terminado'),
                        Text(
                            'Si se ha equivocado con algo contactar al administrador')
                      ]))
                    : !isClockedIn
                        ? ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return clockInDialog();
                                },
                              );

                              setState(() {});
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
                                return startBreaktDialog();
                              });
                        },
                        child: Text('Take a Break'),
                      )
                    : isLunchOver
                        ? Container()
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
          onPressed: () async {
            await firestoreMethods.StartDay(
                userId: user!.uid, startTime: DateTime.now());
            Navigator.of(context).pop();
            checkDayStatus();
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
          onPressed: () async {
            await firestoreMethods.EndDay(
                userId: user!.uid, Endtime: DateTime.now());
            Navigator.of(context).pop();
            checkDayStatus();
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
          onPressed: () async {
            await firestoreMethods.StartBreak(
                userId: user!.uid, breakTimeStart: DateTime.now());
            Navigator.of(context).pop();
            checkDayStatus();
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
          onPressed: () async {
            await firestoreMethods.EndBreak(
                userId: user!.uid, breakTimeEnd: DateTime.now());
            Navigator.of(context).pop();

            checkDayStatus();
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
