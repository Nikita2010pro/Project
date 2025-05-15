class BookingData {
  final String hotelName;
  final String country;
  final String departureDate;
  final String returnDate;
  final int nights;

  final String roomTitle;
  final String roomFeatures;
  final double roomPrice;
  final List<String> images;

  final double fuelFee;
  final double serviceFee;
 final int extraNightsCost;


  BookingData({
    required this.hotelName,
    required this.country,
    required this.departureDate,
    required this.returnDate,
    required this.nights,
    required this.roomTitle,
    required this.roomFeatures,
    required this.roomPrice,
    required this.images,
    required this.fuelFee,
    required this.serviceFee,
    required this.extraNightsCost,

  });

  double get totalCost => roomPrice + fuelFee + serviceFee + extraNightsCost;
}
