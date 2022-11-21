import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shagun_resort_review/Component/custom_buttom.dart';
import 'package:shagun_resort_review/Component/pop_up.dart';
import 'package:shagun_resort_review/Provider/authenticate_provider.dart';
import 'package:shagun_resort_review/Screens/Check%20Food%20Quality/check_food_quality.dart';
import 'package:shagun_resort_review/utils/app_font.dart';
import 'package:shagun_resort_review/utils/app_images.dart';
import 'package:shagun_resort_review/utils/app_route.dart';
import 'package:shagun_resort_review/utils/string_capitalize.dart';
import '../../API Response Models/client_data_model.dart';
import '../../API/call_api.dart';
import '../../Component/try_again.dart';
import '../../utils/app_color.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({Key? key}) : super(key: key);

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {

  final apiCall = AppApi();
  final controller = ScrollController();
 // bool reachBottom = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Data> tempData = [];
    AuthProvider provider = AuthProvider();
    Future getRefreshData() async{
      await apiCall.getClientData();
      setState(() {});
    }
    return Scaffold(
      backgroundColor: AppColor.lightGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(AppImages.shagunLogo,height: 28,width: 74,),
        backgroundColor: AppColor.green,
        actions: [
          TextButton(
            onPressed: () {
              apiCall.getClientData();
              setState(() {});
            },
            child: const Icon(Icons.refresh,color: AppColor.white,),
          ),
          /// Logout button
          GestureDetector(
            onTap: (){
              /// Logout PopUp
              popUp(context: context, title: "Are you sure want to logout?",
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("cancel"),
                ),
                TextButton(
                  onPressed: () {
                    provider.logOutUser();
                    provider.emailController.clear();
                    provider.passwordController.clear();
                    Navigator.pushNamedAndRemoveUntil(context, AppScreen.login, (route) => false);
                  },
                  child: const Text("logout"),
                ),
              ]
              );
            },
            child: Row(children: [
              SvgPicture.asset(AppImages.signOut),
              const Padding(
                padding: EdgeInsets.only(left: 5.0,right: 15),
                child: Center(
                  child: Text("Logout",style: TextStyle(color: AppColor.white, fontFamily: AppFont.poppinsRegular,
                      fontSize: 12
                  ),),
                ),
              )
            ],),
          ),
        ],
      ),
      body: FutureBuilder(
        future: apiCall.getClientData(),
        builder: (context, snapshot) {
          // print("snapshot data ${snapshot.data}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(color: Colors.black),
            );
          }
          else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var clientDetail = snapshot.data as ClientDetail;
              var bookingReviewList = clientDetail.data as List<Data>;

              List<Data> getData = (bookingReviewList.getRange(tempData.length, 10)).toList();
              tempData.addAll(getData);

              var totalBooking = clientDetail.bookingDetails!.totalBooking;

              var pendingBooking = ((clientDetail.bookingDetails!.pendingReview! / totalBooking!) * 100).toInt();

              var completeBooking = ((clientDetail.bookingDetails!.complatedReview! / totalBooking) * 100).toInt();

              return RefreshIndicator(
                onRefresh: getRefreshData,
                child: clientDetail.data!.isNotEmpty ?
                Scrollbar(
                  radius: const Radius.circular(8),
                  thickness: 4.5,
                  child: ListView(
                    controller: controller,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0,bottom: 25,left: 10,right: 10),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: progressBar(
                                    total: "Total",
                                    color: AppColor.blue,
                                    progressColor: AppColor.blue,
                                    record: clientDetail.bookingDetails!.totalBooking.toString())),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: pendingBooking,
                                    child: progressBar(
                                        total: "Pending",
                                        color: AppColor.purple,
                                        progressColor: AppColor.purple,
                                        record: clientDetail.bookingDetails!.pendingReview.toString())
                                  ),

                                  Expanded(
                                    flex: completeBooking,
                                      child: progressBar(
                                          total: "Completed",
                                          color: AppColor.yellow,
                                          progressColor: AppColor.yellow,
                                          record: clientDetail.bookingDetails!.complatedReview.toString()))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                         StatefulBuilder(
                           builder: (context, tempDataState) {
                             controller.addListener(() {
                               if(controller.position.pixels == controller.position.maxScrollExtent){
                                 print(tempData.length);
                                 // if(mounted) {
                                   Future.delayed(const Duration(seconds: 1),(){
                                         tempDataState(() {
                                           // if (!reachBottom) {
                                           //  reachBottom = true;
                                           if (tempData.length <=
                                               bookingReviewList.length) {
                                             getData.clear();
                                             int endPoint = 0;
                                             if (tempData.length <=
                                                 bookingReviewList.length - 10) {
                                               endPoint = tempData.length + 10;
                                             }
                                             else {
                                               endPoint = bookingReviewList.length;
                                             }
                                             getData = (bookingReviewList.getRange(
                                                 tempData.length, endPoint)).toList();
                                             tempData.addAll(getData);
                                            // reachBottom = false;
                                           }
                                           //    }
                                         });
                                       });
                                // }
                               }
                             });
                             return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(left: 15,
                              right: 15, bottom: 8
                              ),
                              itemCount: tempData.length + 1,
                              //clientDetail.data?.length,
                              itemBuilder: (context, index) {
                                var fontStyle = const TextStyle(fontSize: 12,fontFamily: AppFont.poppinsRegular,color: AppColor.black);
                                return index == tempData.length ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: tempData.length == bookingReviewList.length ? Text("No Data to load",
                                  textAlign: TextAlign.center,
                                  ) : CupertinoActivityIndicator(),
                                ) :
                                       Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 22,horizontal: 15),
                                          tileColor: AppColor.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                          ),
                                          leading: Container(
                                            height: 51,
                                            width: 51,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
                                                  Random().nextInt(255),0.5),
                                              shape: BoxShape.circle,
                                            ),
                                            child:
                                            tempData[index].firstName == "" ? Center(
                                              child: const Text("N/A",
                                                  style: const TextStyle(color: AppColor.white,fontSize: 15,)),
                                            ) :
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(tempData[index].firstName?[0].toUpperCase() ?? "",
                                                  style: const TextStyle(color: AppColor.white,fontSize: 15,),
                                                ),
                                                Text(tempData[index].lastName?[0].toUpperCase() ?? "",
                                                    style: const TextStyle(color: AppColor.white,fontSize: 15)
                                                )
                                              ],
                                            ),
                                          ),
                                          title: Text(
                                              tempData[index].bookingId ?? "",style: fontStyle
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                child: Text(
                                                    tempData[index].firstName == "" ? "N/A" :
                                                    tempData[index].firstName?.capitalize() ?? "",style: fontStyle
                                                ),
                                              ),
                                              Text(tempData[index].mobileNumber ?? "",
                                                  style: fontStyle
                                              )
                                            ],
                                          ),
                                          trailing: CustomButton(
                                              backgroundColor: MaterialStateProperty.all<Color>(AppColor.green),
                                              height: 27,
                                              width: 76,
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckFoodQuality(
                                                    clientDetail: tempData[index],
                                                    clientData : clientDetail
                                                )));
                                              },
                                              buttonText: "review"),
                                        ),
                                      );
                              },
                        );
                           }
                         )
                    ],
                  ),
                ) : const Center(
                  child: Text("No bookings available",style: TextStyle(color: AppColor.black),),
                ),
              );
            }
            else {
              return tryAgain(errorMsg: snapshot.error.toString(),
                  onTap: ()=> setState((){}));
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        }
      ),
    );
  }

  /// Progress Bar
 Widget progressBar({required String record,
   required String total,
   Color? progressColor, Color? color}){
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearPercentIndicator(
          barRadius: const Radius.circular(10),
          backgroundColor: Colors.transparent,
          animation: true,
          lineHeight: 10.0,
          animationDuration: 1500,
          percent: 1.0,
          // linearStrokeCap: LinearStrokeCap.round,
          progressColor: progressColor
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0,top: 8),
          child: Text(total,style: const TextStyle(fontFamily: AppFont.poppinsRegular,
              fontSize: 12,
              color: AppColor.black
          ),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle
                ),
              ),
              const SizedBox(width: 5,),
              Text(record,
                style: const TextStyle(color: AppColor.black,fontSize: 12),
              )
            ],
          ),
        )
      ],
    );
 }
}
