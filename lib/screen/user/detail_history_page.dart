import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/model_tracking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailHistory extends StatefulWidget {
  final String alamat;

  const DetailHistory(this.alamat, {Key? key}) : super(key: key);

  @override
  _DetailHistoryState createState() => _DetailHistoryState();
}

class _DetailHistoryState extends State<DetailHistory> {
  int _currentStep = 0;
  List<Tracking> _trackingData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load your tracking data here if needed
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: Text("Alamat Toko"),
        subtitle: Text("cengkareng , jakarta"),
        content: Container(),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text("Alamat Rumah"),
        subtitle: Text(widget.alamat),
        content: Container(),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      // Add more steps here if you have more tracking data
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                SizedBox(
                  width: 90,
                ),
                Text(
                  "Detail Tracking",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Stepper(
                      controlsBuilder:
                          (BuildContext context, ControlsDetails controls) {
                        return Container();
                      },
                      currentStep: _currentStep,
                      onStepTapped: (step) {
                        setState(() {
                          _currentStep = step;
                        });
                      },
                      steps: _buildSteps(),
                      type: StepperType.vertical,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Mark as Done',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
