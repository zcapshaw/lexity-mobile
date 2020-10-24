import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/models.dart';

// TODO: add all my API call functions to this service
class ListService {
  static const API = 'https://api.lexity.co';

  Future<APIResponse> addOrUpdateListItem(accessToken, ListedBook book) {
    return http
        .post(
      API + '/list/add',
      headers: {
        'access-token': accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(book.listElementsToJson()),
    )
        .then((res) {
      if (res.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse> updateListItemType(accessToken, userId, bookId, newType) {
    final jsonItem = jsonEncode({
      'userId': userId,
      'bookId': bookId,
      'type': newType,
    });

    return http
        .post(
      API + '/list/add',
      headers: {
        'access-token': accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonItem,
    )
        .then((res) {
      if (res.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse> deleteBook(accessToken, userId, listId) {
    return http.delete(
      API + '/list/delete/?userId=$userId&listId=$listId',
      headers: {'access-token': accessToken},
    ).then((res) {
      if (res.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse> deleteNote(accessToken, userId, listId, noteId) {
    return http.delete(
      API + '/list/notes/delete/?userId=$userId&listId=$listId&noteId=$noteId',
      headers: {'access-token': accessToken},
    ).then((res) {
      if (res.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse> updateNote(accessToken, updatedNote) async {
    return http
        .post(
      API + '/list/notes/update',
      headers: {
        'access-token': accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedNote),
    )
        .then((res) {
      if (res.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true,
          errorCode: res.statusCode,
          errorMessage: res.reasonPhrase);
    }).catchError(
      (_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'),
    );
  }

  Future<APIResponse<Object>> getListItemDetail(
      accessToken, userId, bookId) async {
    return http.get(
      API + '/list/detail/?userId=$userId&bookId=$bookId',
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
      (_) => APIResponse<Object>(error: true, errorMessage: 'An error occured'),
    );
  }

  //TODO: With new API, should eventually name getListedBooksByUser (or something like this) - it should also be passed a User type
  Future<APIResponse<Object>> getListItemSummary(accessToken, userId) async {
    return http.get(
      API + '/list/book/?userId=$userId',
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
      (_) => APIResponse<Object>(error: true, errorMessage: 'An error occured'),
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
