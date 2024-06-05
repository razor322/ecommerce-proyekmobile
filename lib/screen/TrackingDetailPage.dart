import 'package:ecommerce_app/const.dart';
import 'package:ecommerce_app/model/model_tracking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrackingDetailPage extends StatefulWidget {
  const TrackingDetailPage({Key? key}) : super(key: key);

  @override
  _TrackingDetailPageState createState() => _TrackingDetailPageState();
}

class _TrackingDetailPageState extends State<TrackingDetailPage> {
  int _currentStep = 0;
  List<Tracking> _trackingData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrackingData();
  }

  Future<void> _fetchTrackingData() async {
    final response = await http.get(Uri.parse('${url}get_tracking.php'));

    if (response.statusCode == 200) {
      final data = modelTrackingFromJson(response.body);
      setState(() {
        _trackingData = data.tracking;
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Step> _buildSteps() {
    return _trackingData.asMap().entries.map((entry) {
      int index = entry.key;
      Tracking trackingStep = entry.value;
      return Step(
        title: Text(trackingStep.status),
        subtitle: Text('${trackingStep.description}'),
        content: Container(),
        isActive: _currentStep >= index,
        state: _currentStep > index ? StepState.complete : StepState.indexed,
      );
    }).toList();
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
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stepper(
                            controlsBuilder: (BuildContext context,
                                ControlsDetails controls) {
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
