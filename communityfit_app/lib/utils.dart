import 'package:community_fit/models/edamamApiResponse.dart';
import 'package:meta/meta.dart';

double calculateNewScoreFromNutrients({
  @required double oldScore,
  @required double calories,
  @required double fatContent,
  @required double sugarContent,
  @required double proteinContent,
  @required double carbohydrateContent,
}) {
  print('calculating new score...');
  print('the old score is: ');
  print(oldScore);

  double newScore = oldScore;
  final extraCalories = calories - 2000;
  if (extraCalories > 0) {
    newScore -= (extraCalories / 100);
  }

  final extraFatContent = 77 - fatContent;
  if (extraFatContent > 0) {
    newScore -= newScore -= (extraFatContent / 100);
  }

  final extraSugarContent = 37.5 - sugarContent;
  if (extraSugarContent > 0) {
    newScore -= newScore -= (extraSugarContent / 100);
  }

  if (proteinContent >= 75) {
    newScore += 15;
  } else {
    newScore += (proteinContent / 5);
  }

  newScore += (carbohydrateContent / 30);

  if (carbohydrateContent > 325) {
    newScore -= 5;
  }
  return newScore;
}

double calculateScoreFromEdamamResponse(
  double oldScore,
  EdamamApiResponse edamamApiResponse,
) {
  final calories = edamamApiResponse.hits[0].recipe.calories;
  final fatContent =
      edamamApiResponse.hits[0].recipe.totalNutrients['FAT'].quantity;
  final sugarContent =
      edamamApiResponse.hits[0].recipe.totalNutrients['SUGAR'].quantity;
  final proteinContent =
      edamamApiResponse.hits[0].recipe.totalNutrients['PROCNT'].quantity;
  final carbohydrateContent =
      edamamApiResponse.hits[0].recipe.totalNutrients['CHOCDF'].quantity;

  return calculateNewScoreFromNutrients(
    oldScore: oldScore,
    calories: calories,
    fatContent: fatContent,
    sugarContent: sugarContent,
    proteinContent: proteinContent,
    carbohydrateContent: carbohydrateContent,
  );
}
