import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/loadOperatorInfo.dart';
import 'package:liveasy/screens/updateDriverScreen.dart';
import 'package:liveasy/screens/updateTruckScreen.dart';
import 'package:liveasy/widgets/HeadingTextWidgetBlue.dart';
import 'package:liveasy/widgets/buttons/sendConsentButton.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/widgets/buttons/updateButtonSendRequest.dart';

//Whatever the user chooses from the previous screen is displayed in this screens
class UpdateBookingDetails extends StatefulWidget {
  String? selectedTruck;
  int? selectedDeviceId;
  String? driverName, mobileNo;
  OngoingCardModel loadAllDataModel;

  UpdateBookingDetails({
    this.selectedTruck,
    this.selectedDeviceId,
    this.driverName,
    this.mobileNo,
    required this.loadAllDataModel,
  });

  @override
  _UpdateBookingDetailsState createState() => _UpdateBookingDetailsState();
}

class _UpdateBookingDetailsState extends State<UpdateBookingDetails> {
  String? transporterId;
  String? mobileno;
  TransporterIdController transporterIdController = TransporterIdController();
  GetStorage tidstorage = GetStorage('TransporterIDStorage');
  String? selectedOperator;
  List<String> operatorOptions = [
    'Airtel',
    'Vodafone',
    'Jio',
  ];
  @override
  void initState() {
    super.initState();
    // Load operator options from the API response or set default options.
    loadOperatorInfo(widget.mobileNo, updateSelectedOperator);
  }

  //This function is used to fetch the operator info select it by default from the dropdown
  void updateSelectedOperator(String newOperator) {
    setState(() {
      selectedOperator = newOperator;
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBar snackBar = SnackBar(content: Text('Hello World'));
    return Scaffold(
      appBar: AppBar(
        title: HeadingTextWidgetBlue('confirmBookingDetails'.tr),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: statusBarColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: space_2),
            child: Column(
              children: [
                SizedBox(
                  height: space_4,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: ((context) {
                      return UpdateTruckScreen(
                        driverName: widget.driverName,
                        driverPhoneNo: widget.mobileNo,
                        loadAllDataModel: widget.loadAllDataModel,
                      );
                    })));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: space_3, horizontal: space_3),
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 0.8,
                          color: black,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  Truck",
                                  style: TextStyle(
                                    fontSize: size_10,
                                    color: darkBlueColor,
                                    fontWeight: mediumBoldWeight,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        left: space_2 - 2,
                                        right: space_1 - 2,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: white,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: black,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 25, top: 15),
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: widgetBackGroundColor,
                                  borderRadius: BorderRadius.circular(13)),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: widget.selectedTruck.toString() == "null"
                                    ? Text(
                                        " ",
                                        style: TextStyle(
                                            color: black, fontSize: size_10),
                                      )
                                    : Text(
                                        widget.selectedTruck.toString(),
                                        style: TextStyle(
                                            color: black, fontSize: size_10),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return UpdateDriverScreen(
                        selectedDeviceId: widget.selectedDeviceId,
                        selectedTruck: widget.selectedTruck,
                        loadAllDataModel: widget.loadAllDataModel,
                      );
                    })));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: space_3, horizontal: space_3),
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 0.8,
                          color: black,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  Driver",
                                  style: TextStyle(
                                    fontSize: size_10,
                                    color: darkBlueColor,
                                    fontWeight: mediumBoldWeight,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        left: space_2 - 2,
                                        right: space_1 - 2,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: white,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: black,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 25, top: 15),
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: widgetBackGroundColor,
                                  borderRadius: BorderRadius.circular(13)),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: widget.driverName.toString() == "null"
                                    ? Text(
                                        "",
                                        style: TextStyle(
                                            color: black, fontSize: size_10),
                                      )
                                    : Text(
                                        "${widget.driverName}-${widget.mobileNo}",
                                        style: TextStyle(
                                            color: black, fontSize: size_10),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: space_4, top: space_4),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(space_1),
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButton<String>(
                          key: UniqueKey(),
                          value: selectedOperator,
                          icon: Icon(Icons.keyboard_arrow_down_sharp),
                          style: const TextStyle(color: black),
                          underline: Container(
                            height: 2,
                            color: white,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOperator = newValue!;
                            });
                          },
                          items: operatorOptions.map((String operator) {
                            return DropdownMenuItem<String>(
                              child: Padding(
                                padding: EdgeInsets.all(space_2),
                                child: Container(
                                  width: 100,
                                  height: 28,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/simIcon.png',
                                        width: 17,
                                        height: 17,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: space_2),
                                        child: Text(
                                          operator,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: size_7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              value: operator,
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: space_7),
                        child: SendConsentButton(
                          mobileno: widget.mobileNo,
                          selectedOperator: selectedOperator,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: UpdateButtonSendRequest(
                        selectedDriverName: widget.driverName,
                        selectedDriverPhoneno: widget.mobileNo,
                        selectedDeviceId: widget.selectedDeviceId,
                        loadAllDataModel: widget.loadAllDataModel,
                        truckId: widget.selectedTruck,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
