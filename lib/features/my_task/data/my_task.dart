import "package:shaqti/features/food_category/data/aparetment_mambers_data.dart";
import "package:shaqti/features/garbage_category/data/grabage_data.dart";
import "package:shaqti/features/water_category/data/water_category_data.dart";

class MyTask {
  final ApartmentMembersData _foodData = ApartmentMembersData();
  final WaterCategoryData _waterCategoryData = WaterCategoryData();
  final GrabageData _grabageData = GrabageData();

  Future<Map<String, List<String>>> myTasks({
    required String apartementCode,
    required String day,
    required String userId,
  }) async {
    final tasks = <String, List<String>>{
      "الطعام": [],
      "الماء": [],
      "القمامة": [],
    };

    final meals = await _foodData.getDaySchedule(
      apartmentCode: apartementCode,
      day: day,
    );

    final water = await _waterCategoryData.getWaterByDay(
      day: day,
      apartementcode: apartementCode,
    );

    final garbage = await _grabageData.getCarbage(
      apartementCode: apartementCode,
      day: day,
    );

    if (meals["lunch"] == userId) {
      tasks["الطعام"]!.add("تحضير الغداء");
    }

    if (meals["dinner"] == userId) {
      tasks["الطعام"]!.add("تحضير العشاء");
    }

    if (water == userId) {
      tasks["الماء"]!.add("تعبئة الماء");
    }

    if (garbage == userId) {
      tasks["القمامة"]!.add("رمي القمامة");
    }

    return tasks;
  }
}