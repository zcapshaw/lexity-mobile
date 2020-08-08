// Quick extension to convert string to bool
extension BoolParsing on String {
  bool parseBool() {
    if (this != null) {
      return this.toLowerCase() == 'true';
    } else {
      return false;
    }
  }
}
