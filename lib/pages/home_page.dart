import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/data/workout_data.dart';
import 'package:workout/pages/workout_page.dart';

import '../components/heat_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  //text controller
  final newWorkoutNameController = TextEditingController();
  //create a new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          //save
          MaterialButton(
            onPressed: save,
            child: const Text('save'),
          ),
          //cancel

          MaterialButton(
            onPressed: cancel,
            child: const Text('cancel'),
          ),
        ],
      ),
    );
  }

// go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(
          workoutName: workoutName,
        ),
      ),
    );
  }

//for save
  void save() {
    //get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    //add workout to workout list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
    //pop dialogue box
    Navigator.pop(context);
    clear();
  }

//for cancel
  void cancel() {
    //pop dialog box
    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Workout Tracker'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView(children: [
          //Heat Map
          MyHeatMap(
              datasets: value.heatMapDataSet,
              startDateYYYYMMDD: value.getStartDate()),

          //Workout List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getWorkoutList().length,
            itemBuilder: (context, index) => ListTile(
              title: Text(value.getWorkoutList()[index].name),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () =>
                    goToWorkoutPage(value.getWorkoutList()[index].name),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
