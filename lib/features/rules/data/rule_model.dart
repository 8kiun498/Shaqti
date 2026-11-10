import 'dart:core';

class RuleModel {

  final String text;
  final  int order ;
  final String id;

  RuleModel({required this.text, required this.order, required this.id});


  factory RuleModel.fromMap(Map <String,dynamic> map , String id) {
    return RuleModel(text: map["text"]?? "", order: map["order"] ?? 0,
        id: id);

  }

 Map <String, dynamic> toMap() {
    return {
      "text" : text,
      "order" : order,
    };
}


}
