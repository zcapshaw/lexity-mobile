import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';

// TODO: add all my API call functions to this service
class ListService {
  // ignore: constant_identifier_names
  static const API = 'https://api.lexity.co';

  Future<APIResponse> addOrUpdateListItem(String accessToken, ListedBook book) {
    return http
        .post(
      '$API/list/add',
      headers: {
        'access-token': accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(book.listElementsToJson()),
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
}

class APIResponse<T> {
  const APIResponse(
      {this.data, this.errorMessage, this.errorCode, this.error = false});

  final T data;
  final bool error;
  final int errorCode;
  final String errorMessage;
}
