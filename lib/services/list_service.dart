import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rxdart/streams.dart';

import '../models/models.dart';

// TODO: add all my API call functions to this service
class ListService {
  // ignore: constant_identifier_names
  static const API = 'https://api.lexity.co';

  Future<APIResponse> addOrUpdateListItem(User user, List<ListedBook> books) {
    var jsonBooks = <dynamic>[];
    for (var book in books) {
      jsonBooks.add(book.listElementsToJson());
    }
    return http
        .post(
      '$API/list/add',
      headers: {
        'access-token': user.accessToken,
        'user-id': user.id,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(jsonBooks),
    )
        .then((res) {
      if (res.statusCode == 200) {
        return const APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<bool>(
          error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse> updateListItemType(
      String accessToken, String userId, String bookId, String newType) {
    final jsonItem = jsonEncode({
      'userId': userId,
      'bookId': bookId,
      'type': newType,
    });

    return http
        .post(
      '$API/list/add',
      headers: {
        'access-token': accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonItem,
    )
        .then((res) {
      if (res.statusCode == 200) {
        return const APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<bool>(
          error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse> deleteBook(
      String accessToken, String userId, String listId) {
    return http.delete(
      '$API/list/delete/?userId=$userId&listId=$listId',
      headers: {'access-token': accessToken},
    ).then((res) {
      if (res.statusCode == 200) {
        return const APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<bool>(
          error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse> deleteNote(
      String accessToken, String userId, String listId, String noteId) {
    return http.delete(
      '$API/list/notes/delete/?userId=$userId&listId=$listId&noteId=$noteId',
      headers: {'access-token': accessToken},
    ).then((res) {
      if (res.statusCode == 200) {
        return const APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<bool>(
          error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse> updateNote(String accessToken, Note updatedNote) async {
    return http
        .post(
      '$API/list/notes/update',
      headers: {
        'access-token': accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedNote),
    )
        .then((res) {
      if (res.statusCode == 200) {
        return const APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<bool>(
          error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse<Object>> getListItemDetail(
      String accessToken, String userId, String bookId) async {
    return http.get(
      '$API/list/detail/?userId=$userId&bookId=$bookId',
      headers: {'access-token': accessToken},
    ).then((res) {
      if (res.statusCode == 200) {
        return APIResponse<Object>(data: res.body);
      }
      return APIResponse<Object>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<Object>(
          error: true, errorMessage: 'An error occured'),
    );
  }

  // ignore: lines_longer_than_80_chars
  //TODO: With new API, should eventually name getListedBooksByUser (or something like this) - it should also be passed a User type
  Future<APIResponse<Object>> getListItemSummary(
      String accessToken, String userId) async {
    return http.get(
      '$API/list/book/?userId=$userId',
      headers: {'access-token': accessToken},
    ).then((res) {
      if (res.statusCode == 200) {
        return APIResponse<Object>(data: res.body);
      }
      return APIResponse<Object>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<Object>(
          error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse<Object>> searchTwitterUsers(
      String accessToken, String userId, String query) async {
    return http.get(
      '$API/twitter/search/user?userId=$userId&q=$query',
      headers: {'access-token': accessToken},
    ).then((res) {
      if (res.statusCode == 200) {
        return APIResponse<Object>(data: res.body);
      }
      return APIResponse<Object>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (dynamic err) => const APIResponse<Object>(
          error: true, errorMessage: 'An error occured'),
    );
  }
}

class APIResponse<T> {
  const APIResponse(
      {this.data,
      this.errorMessage,
      this.errorCode,
      this.error = false,
      this.responseBody});

  final T data;
  final bool error;
  final int errorCode;
  final String errorMessage;
  final String responseBody;
}
