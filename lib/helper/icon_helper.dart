class IconHelper {
  static getDeviceIcon(String deviceCategory) {
    return "https://firebasestorage.googleapis.com/v0/b/mysmax-user.appspot.com/o/icons%2Fdevices%2F$deviceCategory.png?alt=media&token=29bd1fa3-fcae-41ca-9b3f-3758f06a6bed";
  }

  static getServiceIcon(String serviceCategory) {
    return "https://firebasestorage.googleapis.com/v0/b/mysmax-user.appspot.com/o/icons%2Fservices%2F$serviceCategory.png?alt=media&token=29bd1fa3-fcae-41ca-9b3f-3758f06a6bed";
  }
}
