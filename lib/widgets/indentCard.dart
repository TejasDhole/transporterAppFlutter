import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/BackgroundAndLocation.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/screens/myLoadPages/bookLoadScreen.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import '../responsive.dart';
import 'LoadEndPointTemplateWeb.dart';
import 'buttons/bookNowButton.dart';

// ignore: must_be_immutable
class IndentCard extends StatelessWidget {
  TransporterIdController tIdController = Get.find<TransporterIdController>();

  final LoadDetailsScreenModel loadDetailsScreenModel;

  IndentCard({required this.loadDetailsScreenModel});
  List<TruckModel> truckDetailsList = [];
  List<DriverModel> driverDetailsList = [];

  TruckApiCalls truckApiCalls = TruckApiCalls();
  DriverApiCalls driverApiCalls = DriverApiCalls();

  loadData1() async {
    truckDetailsList = await truckApiCalls.getTruckData();
    driverDetailsList = await driverApiCalls.getDriversByTransporterId();
  }

  @override
  Widget build(BuildContext context) {
    String rateLengthData = loadDetailsScreenModel.rate!.length > 5
        ? loadDetailsScreenModel.rate!.substring(0, 4) + ".."
        : loadDetailsScreenModel.rate!;
    // String tonne = AppLocalizations.of(context)!.tonne;
    String tonne = 'tonne'.tr;
    String tonnes = 'tonnes'.tr;
    String rateInTonnes =
        (rateLengthData[0] == 'N' ? "--" : "\u20B9$rateLengthData/$tonne");

    String formatDate(String postLoadDate) {
      if (postLoadDate != 'NA') {
        DateTime date = DateFormat('EEE, MMM d yyyy').parse(postLoadDate);
        return DateFormat('dd/MM/yyyy').format(date);
      } else {
        return 'NA';
      }
    }

    return GestureDetector(
        onTap: () {
          if(kIsWeb && Responsive.isDesktop(context)){
            loadData1();
            if (transporterIdController.transporterApproved.value) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardScreen(
                          selectedIndex: screens.indexOf(auctionScreen),
                          index: 1000,
                          visibleWidget: BookLoadScreen(
                            truckModelList: truckDetailsList,
                            driverModelList: driverDetailsList,
                            loadDetailsScreenModel: loadDetailsScreenModel,
                            directBooking: true,
                          ))));
            } else {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => VerifyAccountNotifyAlertDialog(),
              );
            }
          }

        },
        child: Container(
          color: white,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            formatDate(
                                loadDetailsScreenModel.postLoadDate ?? 'NA'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: size_8,
                              fontWeight: mediumBoldWeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: greyDivider,
                  thickness: 1,
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${loadDetailsScreenModel.truckType}'.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: size_8,
                              fontWeight: mediumBoldWeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: greyDivider,
                  thickness: 1,
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${loadDetailsScreenModel.productType}'.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: size_8,
                              fontWeight: mediumBoldWeight,
                            ),
                          ),
                          Text(
                            '${loadDetailsScreenModel.weight}'.tr +
                                ' ' +
                                'tonne'.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: truckGreen,
                              fontSize: size_8,
                              fontWeight: mediumBoldWeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: greyDivider,
                  thickness: 1,
                ),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: space_2),
                              child: LoadEndPointTemplateWeb(
                                  text:
                                      '${loadDetailsScreenModel.loadingPointCity}'
                                          .tr,
                                  endPointType: 'loading'),
                            ),
                            Container(
                                height: space_5,
                                padding: EdgeInsets.only(right: space_40),
                                child: DottedLine(
                                  alignment: WrapAlignment.center,
                                  direction: Axis.vertical,
                                  dashColor: Colors.black,
                                  dashGapColor: Colors.white,
                                  lineThickness: 1.5,
                                  dashLength: 3.5,
                                  dashGapLength: 2.25,
                                  lineLength: 26,
                                  dashGapRadius: 0,
                                )),
                            Padding(
                              padding: EdgeInsets.only(left: space_2),
                              child: LoadEndPointTemplateWeb(
                                  text:
                                      '${loadDetailsScreenModel.unloadingPointCity}'
                                          .tr,
                                  endPointType: 'unloading'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: greyDivider,
                  thickness: 1,
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'NA' + '' + '(per tonne)'.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: size_8,
                              fontWeight: mediumBoldWeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: greyDivider,
                  thickness: 1,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BookNowButton(
                          loadDetailsScreenModel: loadDetailsScreenModel)
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
