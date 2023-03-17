import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counselling_cell_application/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'question_model.dart';
import '../userPage.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

List<String> labels = [
  "Angry",
  "Disgust",
  "Fear",
  "Happy",
  "Sad",
  "Surprise",
  "Neutral"
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late File _customModel;
  final _username = FirebaseAuth.instance.currentUser!.email!;
  List<Question> questionList = getQuestions();
  int _currentQuestionIndex = 0;
  int _score = 0;
  late final List<int> _emotions = List<int>.filled(7, 0);
  Answer? _selectedAnswer;
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.veryHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    FirebaseModelDownloader.instance
        .getModel(
      "test_model",
      FirebaseModelDownloadType.latestModel,
      //Don't delete following lines , i'll need'em later bitch !
      // FirebaseModelDownloadConditions(
      //     androidChargingRequired: false,
      //     androidWifiRequired: true,
      //     androidDeviceIdleRequired: true,
      //   )
    )
        .then((customModel) {
      // Download complete. Depending on your app, you could enable the ML feature, or switch from the local model to the remote model, etc.
      // The CustomModel object contains the local path of the model file, which you can use to instantiate a TensorFlow Lite interpreter.
      //final localModelPath = customModel.file;
      log("Model size in bytes:${customModel.size}");
      var interpreter = Interpreter.fromFile(customModel.file);
      log(interpreter.getInputTensors().toString());
      log(interpreter.getOutputTensors().toString());
      setState(() {
        _customModel = customModel.file;
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();

    super.dispose();
  }

  //define the data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mental Health Assessment",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
            color: Colors.black87,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const UserPage()),
                  ModalRoute.withName(
                      '/') // Replace this with your root screen's route name (usually '/')
                  );
            }),
      ),
      // backgroundColor: Palette.whi,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:30.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset('assets/assessment.png', height: 200, width: 200),
          const SizedBox(height: 20),
      
          // const Text(
          //   "Mental Health Assessment",
          //   style: TextStyle(
          //     color: Colors.black87,
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          _questionWidget(),
          _answerList(),
          _nextButton(),
        ]),
      ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Question: ${_currentQuestionIndex + 1}/${questionList.length.toString()}",
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            // fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Palette.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            questionList[_currentQuestionIndex].questionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  _answerList() {
    return Column(
      children: questionList[_currentQuestionIndex]
          .answersList
          .map(
            (e) => _answerButton(e),
          )
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isSelected = answer == _selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // foregroundColor: isSelected ? Colors.white : Colors.black,
          // backgroundColor: isSelected ? Colors.orangeAccent : Palette.tileback,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        onPressed: () async {
          setState(() {
            _selectedAnswer = answer;
          });
        },
        child: Text(answer.answerText),
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    if (_currentQuestionIndex == questionList.length - 1) {
      isLastQuestion = true;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // foregroundColor: Colors.white,
          // backgroundColor: Palette.primary,
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          captureImage();
          _score += _selectedAnswer!.score;
          if (isLastQuestion) {
            //display score
            log(_emotions.toString());
            log(_score.toString());
            showDialog(context: context, builder: (_) => _showScoreDialog());
          } else {
            //next question

            setState(() {
              _selectedAnswer = null;
              _currentQuestionIndex++;
            });
          }
        },
        child: Text(isLastQuestion ? "Submit" : "Next"),
      ),
    );
  }

  _showScoreDialog() {
    return AlertDialog(
      title: Text(
        _score.toString(),
        style:
            const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            int maxx = 0;
            for (int i = 0; i < 7; i++) {
              if (_emotions[i] > _emotions[maxx]) maxx = i;
            }
            log(labels[maxx]);
            FirebaseFirestore.instance
                .collection("users")
                .doc(_username)
                .update({
              "assessment": false,
              "score": _score,
              "emotion": labels[maxx]
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const UserPage()),
                ModalRoute.withName(
                    '/') // Replace this with your root screen's route name (usually '/')
                );
          },
          child: const Text('Home'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        QuizScreen(camera: widget.camera)),
                ModalRoute.withName(
                    '/') // Replace this with your root screen's route name (usually '/')
                );
          },
          child: const Text('Restart'),
        ),
      ],
    );
  }

  void captureImage() async {
    try {
      // Ensure that the camera is initialized.
      _initializeControllerFuture;
      // Attempt to take a picture and get the file `image` where it was saved.
      var image = _controller.takePicture();
      final arr = await convertImage(await image);
      final prediction = predict(arr);
      _emotions[prediction]++;
      log(labels[prediction]);
      //final arr = await readImage(await image);
      //log(arr.shape.toString());
      /*var decodedImage = await decodeImageFromList(File(image.path).readAsBytesSync());
            log("${decodedImage.height} ${decodedImage.width}");*/
      // If the picture was taken, display it on a new screen.

      if (!mounted) return;
    } catch (e) {
      // If an error occurs, log the error to the console.
      log(e.toString());
    }
  }

  Future<List<List<double>>> convertImage(XFile image) async {
    List<List<double>> imgArray = [];
    final bytes = await image.readAsBytes();
    final decoder = img.JpegDecoder();
    final decodedImgOriginal = decoder.decodeImage(bytes);
    final decodedBytes = decodedImgOriginal!.getBytes();
    final img.Image decodedImg =
        img.copyResize(decodedImgOriginal, width: 48, height: 48);
    int height = decodedImg.height;
    int width = decodedImg.width;
    //log("$height $width");
    for (int y = 0; y < height; y++) {
      imgArray.add([]);
      for (int x = 0; x < width; x++) {
        int red = decodedBytes[y * decodedImg.width * 3 + x * 3];
        int green = decodedBytes[y * decodedImg.width * 3 + x * 3 + 1];
        int blue = decodedBytes[y * decodedImg.width * 3 + x * 3 + 2];
        double gray = 0.3 * red + 0.59 * green + 0.11 * blue;
        imgArray[y].add(gray);
      }
    }
    //log(imgArray[0].toString());
    imgArray.reshape([1, 48, 48, 1]);
    //log(imgArray.shape.toString());
    return imgArray;
  }

  int predict(List ip) {
    final interpreter = Interpreter.fromFile(_customModel);
    interpreter.allocateTensors();
    interpreter.invoke();
    List op = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    ip = ListShape(ip).reshape([1, 48, 48, 1]);
    op = ListShape(op).reshape([1, 7]);
    log("Input shape${ListShape(ip).shape.toString()}");
    log("Input expected${interpreter.getInputTensors().toString()}");
    //log("Input shape${ip.runtimeType.toString()}");
    log("Output shape${ListShape(op).shape.toString()}");
    log("Output expected${interpreter.getOutputTensors().toString()}");
    interpreter.run(ip, op);
    log(op.toString());
    int max = 0;
    for (int i = 0; i < 7; i++) {
      if (op[0][max] < op[0][i]) {
        max = i;
      }
    }
    log("Index of max value: ${max.toString()}");
    log("label of max value: ${labels[max].toString()}");
    interpreter.close();
    return max;
  }
}
