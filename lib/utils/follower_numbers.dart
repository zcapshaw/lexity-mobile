class FollowerNumbers {
  static String converter(int number) {
    String stringNum = number.toString();
    int length = stringNum?.length;
    String newNumber = '0';
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
    String notationNumber = '0';
    double size = length / 3;
    if (size <= 2) {
      String base = largeNumber.substring(0, length - 3);
      String decimal = largeNumber.substring(length - 3, length - 2);
      notationNumber = base + '.' + decimal + 'K';
    } else if (size <= 3) {
      String base = largeNumber.substring(0, length - 6);
      String decimal = largeNumber.substring(length - 6, length - 5);
      notationNumber = base + '.' + decimal + 'M';
    } else if (size <= 4) {
      String base = largeNumber.substring(0, length - 9);
      String decimal = largeNumber.substring(length - 9, length - 8);
      notationNumber = base + '.' + decimal + 'B';
    }
    return notationNumber;
  }
}
