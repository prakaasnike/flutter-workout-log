//related data of workout in this file

import 'package:flutter/cupertino.dart';
import 'package:workout/data/hive_database.dart';
import 'package:workout/models/exercise.dart';
import 'package:workout/models/workout.dart';

import '../datetime/date_time.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
/*
  SECTION
 *  WITHOUT DATA STRUCTURE
 * 
 * -This overall list contains the different workouts
 * -Each workout has a name, and list of exercise
 * 
 */

  List<Workout> workoutList = [
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(
          name: "Biceps Curl",
          weight: "10",
          reps: "10",
          sets: "3",
        )
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(
          name: "Squats",
          weight: "10",
          reps: "10",
          sets: "3",
        )
      ],
    ),
  ];

  //if there are workouts already to database, then get that workoutlist,otherwise use default
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    }
    //otherwise use default database
    else {
      db.saveToDatabase(workoutList);
    }

    //load heat map
    loadHeatMap();
  }

  //get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //get the length of the given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  //add a workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);
  }

  //add an exercise to a workout
  void addExercise(String workoutName, String excerciseName, String weight,
      String reps, String sets) {
    //find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(name: excerciseName, weight: weight, reps: reps, sets: sets),
    );
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //check of the exercise
  void checkOffExcercise(String workoutName, String exerciseName) {
    //find the relevant workout and relevant excercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    //check off boolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
    //load heat map
    loadHeatMap();
  }

  //return relevant workout object given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  //return relevant workout object, given a workout name + excercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    //then find the relevant excercise in that workout
    Exercise relevantExcercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExcercise;
  }

//get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSet = {};
  //Heat Map
  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    //count number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from start date to today, and add each completion status to the datasets
    //"COMPLETION_STATUS_yyyymmdd" will be the key in the datasets
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      //completion status 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);

      //year
      int year = startDate.add(Duration(days: i)).year;
      //month
      int month = startDate.add(Duration(days: i)).month;
      //day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };
      //add to heat map datasets
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
