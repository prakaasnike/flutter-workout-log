//return today date as yyyymmdd

String todaysDateYYYYMMDD() {
  //today
  var dateTimeObject = DateTime.now();

  //year in the format YYYY
  String year = dateTimeObject.year.toString();

  //month in format mm
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //day in format dd
  String date = dateTimeObject.day.toString();
  if (date.length == 1) {
    date = '0$date';
  }

  //final format
  String yyyymmdd = year + month + date;
  return yyyymmdd;
}

//convert string yyyymmdd to DateTime object
DateTime createDateTimeObject(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));
  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

//convert DateTime object to yyyymmdd string
String convertDateTimeToYYYYMMDD(DateTime dateTime) {
  //year in the format YYYY
  String year = dateTime.year.toString();

  //month in format mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //day in format dd
  String date = dateTime.day.toString();
  if (date.length == 1) {
    date = '0$date';
  }

  //final format
  String yyyymmdd = year + month + date;
  return yyyymmdd;
}
