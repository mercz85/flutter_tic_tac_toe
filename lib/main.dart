import 'package:flutter/material.dart';

//todo https://youtu.be/KMdLb5gEOK8?t=622
enum Mark { X, O, NONE }

const kStrokeWidth = 6.0;
const kHalfStrokeWidth = kStrokeWidth / 2.0;
const kDoubleStrokeWidth = kStrokeWidth * 2.0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.yellow[50],
        appBarTheme: const AppBarTheme(
          color: Colors.blueAccent,
        ),
      ),
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  Map<int, Mark> _gameMarks = Map();
  Mark _currentMark = Mark.O;

  void _addMark(double x, double y) {
    double _dividedSize = GamePainter.getDividedSize();
    bool isAbsent = false;

    _gameMarks
        .putIfAbsent((x ~/ _dividedSize + (y ~/ _dividedSize) * 3).toInt(), () {
      isAbsent = true;
      return _currentMark;
    });
/*    _gameMarks.putIfAbsent(6, () {
      isAbsent = true;
      return _currentMark;
    });
    _gameMarks.putIfAbsent(7, () {
      isAbsent = true;
      return _currentMark;
    });
    _gameMarks.putIfAbsent(8, () {
      isAbsent = true;
      return _currentMark;
    });*/

    if (isAbsent) _currentMark = _currentMark == Mark.O ? Mark.X : Mark.O;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTapUp: (TapUpDetails details) {
            setState(() {
              if (_gameMarks.length >= 9) {
                _gameMarks = Map<int, Mark>();
                _currentMark = Mark.O;
              } else {
                _addMark(details.localPosition.dx, details.localPosition.dy);
              }
            });
          },
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              child: CustomPaint(
                painter: GamePainter(_gameMarks),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  static double _dividedSize = 0;
  late Map<int, Mark> _gameMarks;

  GamePainter(this._gameMarks);

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = kStrokeWidth
      ..color = Colors.black;
    final blackThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = kDoubleStrokeWidth
      ..color = Colors.black;
    final redThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = kStrokeWidth
      ..color = Colors.red;

    var x1 = kStrokeWidth;
    var y1 = _dividedSize - kHalfStrokeWidth;
    var x2 = size.width - kStrokeWidth;
    var y2 = _dividedSize - kHalfStrokeWidth;
    //todo voy por aqui
    //https://youtu.be/KMdLb5gEOK8?t=366
    /*
    print("x1:" + x1.toString() + "y1:" + y1.toString());
    print("x2:" + x2.toString() + "y2:" + y2.toString());
    x1: 6.0 y1: 134.14285714285714
    x2: 405.42857142857144 y2: 134.14285714285714
    */
    _dividedSize = size.width / 3.0;
//drawLine( Offset(x1,y1), Offset(x2,y2), paint)
    //1st horizontal line
    canvas.drawLine(
        Offset(kStrokeWidth, _dividedSize - kHalfStrokeWidth),
        Offset(size.width - kStrokeWidth, _dividedSize - kHalfStrokeWidth),
        blackPaint);
    //2nd horizontal line
    canvas.drawLine(
        Offset(kStrokeWidth, _dividedSize * 2 - kHalfStrokeWidth),
        Offset(size.width - kStrokeWidth, _dividedSize * 2 - kHalfStrokeWidth),
        blackPaint);

    //1st vertical line
    canvas.drawLine(
        Offset(_dividedSize - kHalfStrokeWidth, kStrokeWidth),
        Offset(_dividedSize - kHalfStrokeWidth, size.height - kStrokeWidth),
        blackPaint);
    //2nd vertical line
    canvas.drawLine(
        Offset(_dividedSize * 2 - kHalfStrokeWidth, kStrokeWidth),
        Offset(_dividedSize * 2 - kHalfStrokeWidth, size.height - kStrokeWidth),
        blackPaint);

    _gameMarks.forEach((index, mark) {
      switch (mark) {
        case Mark.O:
          drawNought(canvas, index, redThickPaint);
          break;
        case Mark.X:
          drawCross(canvas, index, blackThickPaint);
          break;
        default:
          break;
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  static double getDividedSize() => _dividedSize;

  void drawNought(Canvas canvas, int index, Paint paint) {
    double left = (index % 3) * _dividedSize + kDoubleStrokeWidth * 2;
    double top = (index ~/ 3) * _dividedSize + kDoubleStrokeWidth * 2;
    double noughtSize = _dividedSize - kDoubleStrokeWidth * 4;

    canvas.drawOval(Rect.fromLTWH(left, top, noughtSize, noughtSize), paint);
  }

  void drawCross(Canvas canvas, int index, Paint paint) {
    double x1, y1;
    double x2, y2;

    x1 = (index % 3) * _dividedSize + kDoubleStrokeWidth * 2;
    y1 = (index ~/ 3) * _dividedSize + kDoubleStrokeWidth * 2;

    x2 = (index % 3 + 1) * _dividedSize - kDoubleStrokeWidth * 2;
    y2 = (index ~/ 3 + 1) * _dividedSize - kDoubleStrokeWidth * 2;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

    x1 = (index % 3 + 1) * _dividedSize - kDoubleStrokeWidth * 2;
    y1 = (index ~/ 3) * _dividedSize + kDoubleStrokeWidth * 2;

    x2 = (index % 3) * _dividedSize + kDoubleStrokeWidth * 2;
    y2 = (index ~/ 3 + 1) * _dividedSize - kDoubleStrokeWidth * 2;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }
}
