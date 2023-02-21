import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout/models/workout.dart';
import '../datetime/date_time.dart';
import '../models/exercise.dart';

class HiveDatabase {
  //reference our hive box
  final _mybox = Hive.box('workout_database4');

  //check if there is already data stored if not record the start date
  bool previousDataExists() {
    if (_mybox.isEmpty) {
      print('Data does not exist.');
      _mybox.put('START_DATE', todaysDateYYYYMMDD());
      return false;
    } else {
      print('Existing previous data.');
      return true;
    }
  }

  //return start date as yymmdd
  String getStartDate() {
    return _mybox.get('START_DATE');
  }

  //write data
  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _mybox.put('COMPLETION_STATUS${todaysDateYYYYMMDD()}', 1);
    } else {
      _mybox.put('COMPLETION_STATUS${todaysDateYYYYMMDD()}', 0);
    }
    //lets try to save it in hive
    _mybox.put('WORKOUTS', workoutList);
    _mybox.put('EXERCISES', exerciseList);
  }

//read data and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _mybox.get('WORKOUTS');
    final exerciseDetails = _mybox.get('EXERCISES');

    //create a workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      //each workout can have multiple exercises
      List<Exercise> exercisesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        //so lets add each exercise in each workout
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == 'true' ? true : false,
          ),
        );
      }
      // create individual workouts
      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);
      //add individual workout to overall list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  //return completion status of a given date yyyyMMdd
  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _mybox.get('COMPLETION_STATUS$yyyymmdd') ?? 0;
    return completionStatus;
  }

  //check if any exercises has been done
  bool exerciseCompleted(List<Workout> workouts) {
    //go through each exercise
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }
}

//converts workout objects into a list-> eg.[upperbody,lowerbody]
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

//converts the exercise in a workout object into alist of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [];

    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [
        exercisesInWorkout[j].name,
        exercisesInWorkout[j].weight,
        exercisesInWorkout[j].reps,
        exercisesInWorkout[j].sets,
        exercisesInWorkout[j].isCompleted.toString(),
      ];
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
