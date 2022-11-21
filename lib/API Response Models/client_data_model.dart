class ClientDetail {
  bool? status;
  int? statusCode;
  String? message;
  BookingDetails? bookingDetails;
  List<String>? options;
  List<ReviewData>? reviewData;
  List<Data>? data;

  ClientDetail(
      {this.status,
        this.statusCode,
        this.message,
        this.bookingDetails,
        this.options,
        this.reviewData,
        this.data});

  ClientDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    bookingDetails = json['booking_details'] != null
        ? BookingDetails.fromJson(json['booking_details'])
        : null;
    options = json['options'].cast<String>();

    if (json['review_data'] != null) {
      reviewData = <ReviewData>[];
      json['review_data'].forEach((v) {
        reviewData!.add(ReviewData.fromJson(v));
      });
    }

    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class BookingDetails {
  int? totalBooking;
  int? pendingReview;
  int? complatedReview;

  BookingDetails({this.totalBooking, this.pendingReview, this.complatedReview});

  BookingDetails.fromJson(Map<String, dynamic> json) {
    totalBooking = json['Total_Booking'];
    pendingReview = json['Pending_Review'];
    complatedReview = json['Complated_Review'];
  }
}

class ReviewData {
  String? key;
  String? name;
  String? type;
  bool? skip;
  String? optionVal;
  bool isSelected = false;

  ReviewData({this.key, this.name, this.type, this.skip, this.isSelected = false, this.optionVal});

  ReviewData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    type = json['type'];
    skip = json['skip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = optionVal;
    return data;
  }
}

class Data {
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? bookingId;
  String? finalBookingAmount;
  String? totalPerson;
  String? bookingDatetime;

  Data(
      {this.firstName,
        this.lastName,
        this.mobileNumber,
        this.bookingId,
        this.finalBookingAmount,
        this.totalPerson,
        this.bookingDatetime});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'] ;
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    bookingId = json['booking_id'];
    finalBookingAmount = json['final_booking_amount'];
    totalPerson = json['total_person'];
    bookingDatetime = json['booking_datetime'];
  }
}
