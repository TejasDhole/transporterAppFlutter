import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/deviceApiCalls.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckDescriptionScreen.dart';
import 'package:liveasy/screens/myLoadPages/selectTruckScreen.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/alertDialog/sameTruckAlertDialogBox.dart';
import 'package:liveasy/widgets/buttons/mediumSizedButton.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';

//TODO: loading widget while post executes
class AddNewTruck extends StatefulWidget {
  late String fromScreen;
  LoadDetailsScreenModel? loadDetailsScreenModel;
  String? driverName;
  String? driverPhoneNo;

  AddNewTruck(
    this.fromScreen,
    this.loadDetailsScreenModel,
    this.driverName,
    this.driverPhoneNo,
  );

  @override
  _AddNewTruckState createState() => _AddNewTruckState();
}

class _AddNewTruckState extends State<AddNewTruck> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _controller = TextEditingController();
  TruckApiCalls truckApiCalls = TruckApiCalls();
  DriverApiCalls driverApiCalls = DriverApiCalls();
  DeviceApiCalls postDeviceApi = DeviceApiCalls();

  String? truckId;
  RegExp truckNoRegex = RegExp(
      r"^[A-Za-z]{2}[ -/]{0,1}[0-9]{1,2}[ -/]{0,1}(?:[A-Za-z]{0,1})[ -/]{0,1}[A-Za-z]{0,2}[ -/]{0,1}[0-9]{4}$");

  bool? loading = false;

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return (kIsWeb && (Responsive.isDesktop(context)))
        ? Container(
            padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_10),
            color: white,
            child: SafeArea(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Enter Truck Number',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 260.0),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.clear)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: space_2,
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: space_6),
                        margin: EdgeInsets.symmetric(vertical: space_4),
                        height: space_8,
                        child: TextFormField(
                          onChanged: (value) {
                            if (_controller.text != value.toUpperCase())
                              _controller.value = _controller.value
                                  .copyWith(text: value.toUpperCase());
                            //Check if the truckNumber length is greater than 9 and matches with the pattern.
                            if (truckNoRegex.hasMatch(value) &&
                                value.length >= 9) {
                              providerData.updateResetActive(true);
                            } else {
                              providerData.updateResetActive(false);
                            }
                          },
                          //Pattern allowed to enter the details are specified.
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-Z0-9]")),
                          ],
                          textCapitalization: TextCapitalization.characters,
                          controller: _controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: space_2),
                            filled: true,
                            fillColor: whiteBackgroundColor,
                            hintText: 'Eg: UP 22 GK 2222',
                            hintStyle: TextStyle(
                              fontWeight: boldWeight,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: unselectedGrey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: unselectedGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    loading!
                        ? Container(
                            margin: EdgeInsets.all(space_3),
                            child: LoadingWidget(),
                          )
                        : Container(),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MediumSizedButton(
                            text: 'next'.tr,
                            optional: false,
                            onPressedFunction: providerData.resetActive
                                ? () async {
                                    setState(() {
                                      loading = true;
                                    });

                                    final int random =
                                        new Random().nextInt(10000000 - 1) + 1;
                                    print(random);
                                    providerData.updateTruckNumberValue(
                                        _controller.text);
                                    truckId = await postDeviceApi.PostDevice(
                                        //post truck no in device api with random uniqueid
                                        truckName: _controller.text,
                                        uniqueid: random.toString());
                                    print("$truckId--------------------");

                                    if (truckId != null) {
                                      setState(() {
                                        loading = false;
                                      });
                                      providerData.updateResetActive(false);
                                      if (widget.fromScreen == "myTrucks") {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) => DashboardScreen(
                                                    selectedIndex: screens
                                                        .indexOf(auctionScreen),
                                                    index: 1000,
                                                    visibleWidget:
                                                        TruckDescriptionScreen(
                                                            truckId: truckId!,
                                                            truckNumber:
                                                                _controller
                                                                    .text,
                                                            truckUniqueId: random
                                                                .toString()))));
                                      } else if (widget.fromScreen ==
                                          "selectTruck") {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DashboardScreen(
                                                        selectedIndex:
                                                            screens.indexOf(
                                                                auctionScreen),
                                                        index: 1000,
                                                        visibleWidget:
                                                            SelectTruckScreen(
                                                          driverName:
                                                              widget.driverName,
                                                          driverPhoneNo: widget
                                                              .driverPhoneNo,
                                                          loadDetailsScreenModel:
                                                              widget
                                                                  .loadDetailsScreenModel!,
                                                          directBooking: false,
                                                        ))));
                                      }
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return SameTruckAlertDialogBox();
                                          });
                                    }
                                  }
                                : null),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        //TODO:App side code.
        : Scaffold(
            body: Container(
              padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_10),
              color: backgroundColor,
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(
                        backButton: true,
                        text: 'addTruck'.tr,
                        // AppLocalizations.of(context)!.addTruck,
                        reset: true,
                        resetFunction: () {
                          _controller.text = '';
                          providerData.resetTruckNumber();
                          providerData.updateResetActive(false);
                        },
                      ),
                      SizedBox(
                        height: space_2,
                      ),
                      AddTruckSubtitleText(text: 'truckNumber'.tr
                          // AppLocalizations.of(context)!.truckNumber
                          ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: space_6),
                          margin: EdgeInsets.symmetric(vertical: space_4),
                          height: space_8,
                          child: TextFormField(
                            onChanged: (value) {
                              if (_controller.text != value.toUpperCase())
                                _controller.value = _controller.value
                                    .copyWith(text: value.toUpperCase());
                              if (truckNoRegex.hasMatch(value) &&
                                  value.length >= 9) {
                                providerData.updateResetActive(true);
                              } else {
                                providerData.updateResetActive(false);
                              }
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[a-zA-Z0-9]")),
                            ],
                            textCapitalization: TextCapitalization.characters,
                            controller: _controller,
                            // textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: space_2),
                              filled: true,
                              fillColor: whiteBackgroundColor,
                              hintText: 'Eg: UP 22 GK 2222',
                              hintStyle: TextStyle(
                                fontWeight: boldWeight,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: unselectedGrey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: unselectedGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      loading!
                          ? Container(
                              margin: EdgeInsets.all(space_3),
                              child: LoadingWidget(),
                            )
                          : Container(),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: MediumSizedButton(
                              text: 'next'.tr,
                              // AppLocalizations.of(context)!.next,
                              optional: false,
                              onPressedFunction: providerData.resetActive
                                  ? () async {
                                      setState(() {
                                        loading = true;
                                      });

                                      final int random =
                                          new Random().nextInt(10000000 - 1) +
                                              1;
                                      print(random);
                                      providerData.updateTruckNumberValue(
                                          _controller.text);
                                      truckId = await postDeviceApi.PostDevice(
                                          //post truck no in device api with random uniqueid
                                          truckName: _controller.text,
                                          uniqueid: random.toString());
                                      print("$truckId--------------------");

                                      if (truckId != null) {
                                        setState(() {
                                          loading = false;
                                        });
                                        providerData.updateResetActive(false);
                                        if (widget.fromScreen == "myTrucks") {
                                          Get.to(() => TruckDescriptionScreen(
                                              truckId: truckId!,
                                              truckNumber: _controller.text,
                                              truckUniqueId:
                                                  random.toString()));
                                        } else if (widget.fromScreen ==
                                            "selectTruck") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectTruckScreen(
                                                        driverName:
                                                            widget.driverName,
                                                        driverPhoneNo: widget
                                                            .driverPhoneNo,
                                                        loadDetailsScreenModel:
                                                            widget
                                                                .loadDetailsScreenModel!,
                                                        directBooking: false,
                                                      )));
                                        }
                                        // print("hii ${truckId} and ${_controller.text}");
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return SameTruckAlertDialogBox();
                                            });
                                      }
                                    }
                                  : null),
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
