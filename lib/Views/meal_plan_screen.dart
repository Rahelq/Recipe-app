import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Utils/constants.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  // Sample data for meals
  final Map<String, List<Map<String, dynamic>>> weeklyMealPlan = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  String selectedDay = 'Monday';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        centerTitle: true,
        title: const Text(
          "Meal Plan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Calendar Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weeklyMealPlan.keys.map((day) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: selectedDay == day
                            ? kprimaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          color:
                              selectedDay == day ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Meal List for Selected Day
          Expanded(
            child: weeklyMealPlan[selectedDay]!.isEmpty
                ? const Center(
                    child: Text(
                      "No meals added yet!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: weeklyMealPlan[selectedDay]!.length,
                    itemBuilder: (context, index) {
                      final meal = weeklyMealPlan[selectedDay]![index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(meal['image']),
                                ),
                              ),
                            ),
                            title: Text(
                              meal['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${meal['cal']} Calories",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  weeklyMealPlan[selectedDay]!.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Add Meal Button
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                _addMealDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Meal",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog to Add Meals
  void _addMealDialog(BuildContext context) {
    final mealNameController = TextEditingController();
    final mealImageController = TextEditingController();
    final mealCalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Meal"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: mealNameController,
                  decoration: const InputDecoration(labelText: "Meal Name"),
                ),
                TextField(
                  controller: mealImageController,
                  decoration:
                      const InputDecoration(labelText: "Meal Image URL"),
                ),
                TextField(
                  controller: mealCalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Calories"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  weeklyMealPlan[selectedDay]!.add({
                    'name': mealNameController.text,
                    'image': mealImageController.text,
                    'cal': int.parse(mealCalController.text),
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
