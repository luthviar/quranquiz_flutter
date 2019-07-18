import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:quranquiz/models/category.dart';
import 'package:quranquiz/models/question.dart';

const String baseUrl = "http://quranquiz.gotongroyong.com/api/question-answers/surah/get";

Future<List<Question>> getQuestions(Category category, int total, String difficulty) async {
  String url = "$baseUrl/$total/${category.id}";
  if(difficulty != null) {
    url = "$url&difficulty=$difficulty";
  }
  http.Response res = await http.get(url);
  List<Map<String, dynamic>> questions = List<Map<String,dynamic>>.from(json.decode(res.body)["results"]);
  return Question.fromData(questions);
}