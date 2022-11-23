import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagun_resort_review/API/call_api.dart';
import 'package:shagun_resort_review/Component/custom_buttom.dart';
import 'package:shagun_resort_review/Component/textform_field.dart';
import 'package:shagun_resort_review/Provider/authenticate_provider.dart';
import 'package:shagun_resort_review/Service/secure_storage.dart';
import 'package:shagun_resort_review/utils/app_font.dart';
import 'package:shagun_resort_review/utils/app_route.dart';
import 'package:shagun_resort_review/utils/app_size.dart';
import '../../API Response Models/client_data_model.dart';
import '../../Component/pop_up.dart';
import '../../utils/app_color.dart';

class CheckFoodQuality extends StatefulWidget {
  final Data clientDetail;
  final ClientDetail clientData;
  const CheckFoodQuality({
    Key? key,
    required this.clientDetail,
    required this.clientData,
  }) : super(key: key);

  @override
  State<CheckFoodQuality> createState() => _CheckFoodQualityState();
}

class _CheckFoodQualityState extends State<CheckFoodQuality>
    with TickerProviderStateMixin {
  var extraCommentController = TextEditingController();
  DateTime? selectedDate;
  var api = AppApi();
  var provider = AuthProvider();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );


  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    extraCommentController.dispose();
    // animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fontStyle = const TextStyle(
        fontSize: 12,
        fontFamily: AppFont.poppinsRegular,
        height: 2,
        color: AppColor.black);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColor.green,
        title: const Text(
          "Reviews",
          style: TextStyle(
              fontSize: 14,
              fontFamily: AppFont.poppinsMedium,
              color: AppColor.white),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        /// Customer Details heading
        Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20, bottom: 15),
          child: Text(
            "Customer Details",
            style: TextStyle(color: AppColor.black, fontSize: 14),
          ),
        ),

        /// Customer Booking Details Card
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: AppColor.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Booking No:", style: fontStyle),
                  Text(
                    "Name:",
                    style: fontStyle,
                  ),
                  Text(
                    "Mobile No:",
                    style: fontStyle,
                  ),
                  Text(
                    "Final Booking Amount:",
                    style: fontStyle,
                  ),
                  Text(
                    "Total Person:",
                    style: fontStyle,
                  ),
                  Text(
                    "Booking Date Time:",
                    style: fontStyle,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.clientDetail.bookingId ?? "",
                    style: fontStyle,
                  ),
                  Text(
                    widget.clientDetail.firstName ?? "",
                    style: fontStyle,
                  ),
                  Text(
                    widget.clientDetail.mobileNumber ?? "",
                    style: fontStyle,
                  ),
                  Text(
                    widget.clientDetail.finalBookingAmount ?? "",
                    style: fontStyle,
                  ),
                  Text(
                    widget.clientDetail.totalPerson ?? "",
                    style: fontStyle,
                  ),
                  Text(
                    widget.clientDetail.bookingDatetime ?? "",
                    style: fontStyle,
                  ),
                ],
              )
            ],
          ),
        ),

        /// Review heading
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, bottom: 15),
          child: Text(
            "Review",
            style: TextStyle(color: AppColor.black, fontSize: 14),
          ),
        ),

        /// Feedback Page Slider
        SizedBox(
          height: AppSize.getHeight(context) * .30,
          child: PageView.builder(
            // allowImplicitScrolling: true,
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.clientData.reviewData?.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColor.yellow,
                        ),
                        Text(
                          "${index + 1}/${widget.clientData.reviewData?.length}",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(widget.clientData.reviewData![index].name.toString()),
                    widget.clientData.reviewData![index].type == "text"
                        ? CustomTextFormField(
                      fillColor: AppColor.lightGrey,
                      controller: extraCommentController,
                      hintText: "Extra Comment",
                      labelStyle: const TextStyle(color: AppColor.green),
                    )
                        : widget.clientData.reviewData![index].type == "date"
                            ?
                            Column(
                                children: [
                                  Visibility(
                                    visible: widget.clientData
                                            .reviewData![index].optionVal !=
                                        null,
                                    child: Center(
                                      child: Text(
                                        "${widget.clientData.reviewData![index].optionVal}"
                                            .split(' ')[0],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _selectDate(context, index),
                                    icon: const Icon(Icons.calendar_today),
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  for (int item = 0;
                                      item < widget.clientData.options!.length;
                                      item++)
                                    ratingButton(
                                        widget.clientData.options![item],
                                        index),
                                ],
                              ),
                    index != widget.clientData.reviewData!.length - 1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// back button
                              Visibility(
                                visible: index != 0,
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CustomButton(
                                      textColor: AppColor.white,
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppColor.yellow),
                                      buttonText: "back",
                                      onPressed: () {
                                        pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.ease);
                                      },
                                    )),
                              ),

                              /// next button
                              Visibility(
                                visible: widget.clientData.reviewData![index].skip == false &&
                                widget.clientData.reviewData![index].isSelected,
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CustomButton(
                                      textColor: AppColor.black,
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColor.lightGrey),
                                      buttonText: "next",
                                      onPressed: () {
                                        pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.ease);
                                      },
                                    )),
                              ),

                              /// next/skip button
                              Visibility(
                                visible:
                                    widget.clientData.reviewData![index].skip ??
                                        false,
                                child: CustomButton(
                                  textColor: AppColor.black,
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColor.lightGrey),
                                  onPressed: () {
                                    pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn);
                                  },
                                  buttonText: extraCommentController.text.isNotEmpty || widget.clientData.reviewData![index].isSelected ? "next" : "skip",
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// back button
                              Visibility(
                                visible: index != 0,
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CustomButton(
                                      textColor: AppColor.white,
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppColor.yellow),
                                      buttonText: "back",
                                      onPressed: () {
                                        pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.ease);
                                      },
                                    )),
                              ),

                              /// submit Button
                              CustomButton(
                                  width: 50,
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColor.green),
                                  onPressed: () {
                                    {
                                      callSubmitReviewApi();
                                    }
                                  },
                                  buttonText: "submit",
                                  isLoading: context.watch<AuthProvider>().loginLoader,
                              ),
                            ],
                          )
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

   Future callSubmitReviewApi() async{
    var storage = SecureStorage();
    Map<String, dynamic> requestBody = <String, dynamic>{};
    requestBody['booking_id'] = widget.clientDetail.bookingId;
    requestBody['token'] = await storage.readSecureData('userToken');
    // print("user token ${requestBody['token']}");
    for (var item = 0; item < widget.clientData.reviewData!.length; item++) {
      if(widget.clientData.reviewData?[item].optionVal != null) {
        requestBody[ widget.clientData.reviewData![item].key!] = widget.clientData.reviewData?[item].optionVal;
      }
    }
    try {
      api.submitReview(requestBody).then((response) {
        // provider.updateLoader(true);
       // print("request body $requestBody");
        if (response.status == true) {
          popUp(title: response.message, context: context, actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, AppScreen.bookingStatus,(route) => false);
                // provider.updateLoader(false);
              },
              child: const Text("okay"),
            ),
          ]);
        }
        else{
          if(response.status == false) {
            popUp(title: response.message, context: context, actions: [
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, AppScreen.bookingStatus);
                // provider.updateLoader(false);
              },
              child: const Text("okay"),
            ),
          ]);
          }
        }
      });
    } catch (error) {
      print("Login API error $error");
      rethrow;
    }
  }

  _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
        builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColor.green,
            onPrimary: AppColor.white,
            onSurface: AppColor.black,
          ),
          // textButtonTheme: TextButtonThemeData(
          //   style: TextButton.styleFrom(
          //     primary: Colors.red, // button text color
          //   ),
          // ),
        ),
        child: child!,
      );}
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        // textController.text = picked.toString();
        widget.clientData.reviewData![index].optionVal = picked.toString();
        widget.clientData.reviewData![index].isSelected = true;
      });
    }
  }

  Widget ratingButton(String text, int index) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          elevation: MaterialStateProperty.all<double?>(0),
          backgroundColor: MaterialStateProperty.all<Color>(
              widget.clientData.reviewData![index].optionVal == text
                  ? AppColor.yellow
                  : AppColor.lightGrey)),
      onPressed: () {
        setState(() {
          widget.clientData.reviewData![index].optionVal = text;
          widget.clientData.reviewData![index].isSelected = true;
        });
        pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      },
      child: Text(
        text,
        style: TextStyle(
            color: widget.clientData.reviewData![index].optionVal == text
                ? AppColor.white
                : AppColor.black,
            fontSize: 12,
            fontFamily: AppFont.poppinsMedium),
      ),
    );
  }
}
