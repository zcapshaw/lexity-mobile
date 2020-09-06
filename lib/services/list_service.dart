import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/book.dart';

//TODO: add all my API call functions to this service
class ListService {
  static const API = 'https://api.lexity.co';

  Future<APIResponse> addOrUpdateListItem(accessToken, item) {
    print(accessToken);
    print(jsonEncode(item));
    return http
        .post(
      API + '/list/add',
      headers: {
        'access-token': accessToken,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(item),
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
}

class APIResponse<T> {
  T data;
  bool error;
  int errorCode;
  String errorMessage;

  APIResponse(
      {this.data, this.errorMessage, this.errorCode, this.error = false});
}
