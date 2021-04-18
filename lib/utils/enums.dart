enum LogInService { twitter, apple }

extension ParseToString on LogInService {
  String toShortString() {
    return toString().substring(toString().indexOf('.') + 1);
  }
}
