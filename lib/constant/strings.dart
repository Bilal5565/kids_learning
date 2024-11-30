import 'package:edu_app/constant/images.dart';

class AppString {
  ////////////////////
// lang
  static const String english = 'en-US';
  static const String urdu = 'ur-PK';
  static const String letters = 'letters';
  //////////////////////////////
//errors
  static const String noContent = 'No content available';
  static const String errorLoading = 'Error loading content';
/////
///extra
static const String  fun='Fun Games';
static const String gameOver = 'Game Over';
static const String reach="You have reached the maximum number of tries.";
static const String tries="Tries";
static const String score="Score";
static const String sorry='Sorry try again';
static const String correct= 'Correct!';
static const String great="Great";
//////

  /////
  // Exit Text
static const String exitText='Are you sure you want to exit?';

//////////////
static const String correctAnswer ='Correct Answers:';
static const String congratulations='Congratulations';
static const String level ='Difficulty Level:';
static const String ok='OK';

///button Text
static const String cancel='Cancel';
static const String exit='Exit';
static const String restart="Restart";
  ////////////////////////
//List Of Category
  static const categoryNameAndCollectionNameList = [
    {
      "categoryName": "Alphabets",
      "collectionName": "alphabets",
      "categoryImage": AppImage.alphabets,
    },
    {
      "categoryName": "Letters",
      "collectionName": "letters",
      "categoryImage": AppImage.letters,
    },
    {
      "categoryName": "Numbers",
      "collectionName": "numbers",
      "categoryImage": AppImage.numbers,
    },
    {
      "categoryName": "Animals",
      "collectionName": "animals",
      "categoryImage": AppImage.animals,
    },
    {
      "categoryName": "Color",
      "collectionName": "colors",
      "categoryImage": AppImage.colors,
    },
    {
      "categoryName": "Fruits",
      "collectionName": "fruits",
      "categoryImage": AppImage.fruits,
    },
    {
      "categoryName": "Vegetables",
      "collectionName": "vegetables",
      "categoryImage": AppImage.vegetables,
    },
    {
      "categoryName": "Body",
      "collectionName": "body_parts",
      "categoryImage": AppImage.body_parts,
    },
    {
      "categoryName": "Shapes",
      "collectionName": "shapes",
      "categoryImage": AppImage.shapes,
    },
    {
      "categoryName": "Family",
      "collectionName": "family",
      "categoryImage":AppImage.family,
    }
  ];

  static const GamesList = [
    {
      'GameName': 'Color',
      'imagePath': 'assets/images/color.png',
    },
    {
      'GameName': 'Memo',
      'imagePath': 'assets/images/memo.png',
    },
    {
      'GameName': 'Math',
      'imagePath': 'assets/images/think.png',
    },
  ];

  static const gamesRoutes = [
    {
      'routePath': '/Color',
    },
    {
      'routePath': '/Memory',
    },
    {
      'routePath': '/Math',
    },
  ];

/// Button List
  static const  numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
  ];
}
