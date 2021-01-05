class FollowerNumbers {
  static String converter(int number) {
    var stringNum = number.toString();
    var length = stringNum?.length;
    var newNumber = '0';
    if (length != null) {
      if (length <= 3) {
        newNumber = stringNum;
      } else {
        newNumber = _addNotation(stringNum, length);
      }
    }
    return newNumber;
  }

  static String _addNotation(String largeNumber, int length) {
    var notationNumber = '0';
    var size = length / 3;
    if (size <= 2) {
      var base = largeNumber.substring(0, length - 3);
      var decimal = largeNumber.substring(length - 3, length - 2);
      notationNumber = '$base.{$decimal}K';
    } else if (size <= 3) {
      var base = largeNumber.substring(0, length - 6);
      var decimal = largeNumber.substring(length - 6, length - 5);
      notationNumber = '$base.{$decimal}M';
    } else if (size <= 4) {
      var base = largeNumber.substring(0, length - 9);
      var decimal = largeNumber.substring(length - 9, length - 8);
      notationNumber = '$base.{$decimal}B';
    }
    return notationNumber;
  }
}
