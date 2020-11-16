import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mychallange/screens/random_meal_gen/meal_list.dart';
import 'package:mychallange/screens/random_meal_gen/models/meal.dart';
import 'package:mychallange/screens/random_meal_gen/models/meals.dart';

Future<List<Meal>> fetchPost() async {
  final response =
      await http.get('https://www.themealdb.com/api/json/v1/1/random.php');

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.

    final parsed = response.body;

    var mealJson = jsonDecode(parsed)['meals'] as List;
    List resultMeal = mealJson.map((mealJs) => Meal.fromJson(mealJs)).toList();
    return resultMeal;
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class RandomMealGen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RandomMealGen',
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'back',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          title: Text('RandomMealGen'),
        ),
        body: Container(
          child: FutureBuilder(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print("err: " + snapshot.error.toString());

              if (snapshot.hasData) {
                //to-do
                //add image by url
                //add ingredients

                return Text(snapshot.data[0].strCategory);
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}