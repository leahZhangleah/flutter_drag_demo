import 'dart:async';

import 'package:flutter/material.dart';

import 'DragItem.dart';
import 'TimerService.dart';

void main() {
  final timerService = TimerService();
  runApp(TimerServiceProvider(
    service: timerService,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  var questionNum = 5;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var targetItems, sourceItems;
  double pad = 20.0;
  double windowWidth,interval,marginH,marginV,horizontalW,verticalH,listMargin;
  //var testNumbers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    targetItems = new List<DragItem>.generate(widget.questionNum, (i) {
      var item = new DragItem();
      item.isEmpty = true;
      return item;
    });
    sourceItems = new List<DragItem>.generate(widget.questionNum, (i) {
      var item = new DragItem();
      item.isEmpty = false;
      item.data = (i + 1).toString();
      return item;
    });

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    initSizes();

  }

  void initSizes() {
    if(mounted){
      windowWidth = MediaQuery.of(context).size.width;
      interval = (windowWidth - pad * 2)  * 2/ (widget.questionNum * 3);
      listMargin = (windowWidth - pad * 2 - widget.questionNum * interval ) / (widget.questionNum - 1);
      marginH = 5.0;
      marginV = 10.0;
      horizontalW = (windowWidth - pad * 2 - marginH * 2) / 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    var timerService = TimerService.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(pad),
        child: Container(
          child: new Column(
            children: <Widget>[
              getTimeView(timerService),
              getMargin(),
              getListView(timerService),
              getMargin(),
              new Container(height: 1.0, color: Colors.grey,),
              getMargin(),
              getGridView(),
              getMargin(),
              RaisedButton(
                  child: Text("FINISH"), onPressed: () => timerService.stop())
            ],
          ),
        ),
      ),
    );
  }

  Widget getMargin(){
    return new Container(width: 10, height: 10,);
  }

  Widget getTimeView(TimerService timerService){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AnimatedBuilder(
          animation: timerService,
          builder: (context, child) {
            return Text(
                "${timerService.currentDuration}",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.amber[500]
                ),);
          },
        ),
      ],
    );
  }

  Widget getListView(TimerService timerService) {
    return new Container(
      height: interval,
      child: ListView.builder(
          itemCount: sourceItems.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.only(right: listMargin),
                child:DragTarget(
                  builder: (context, List<String> candidateData, rejectedData) {
                    String data = sourceItems[index].data;
                    return sourceItems[index].isEmpty
                        ? getSourceContainer(interval)
                        : new Draggable<String>(
                      data: data,
                      child: getSourceDraggable(data,interval),
                      feedback: getSourceDraggable(data,interval),
                      childWhenDragging: getSourceContainer(interval),
                      onDragCompleted: () {
                        setState(() {
                          sourceItems[index].isEmpty = true;
                          sourceItems[index].data = null;
                        });
                      },
                      onDragStarted: () {
                        if (!timerService.isRunning) {
                          timerService.start();
                        }
                      },
                    );
                  },
                  onWillAccept: (data) {
                    return sourceItems[index].isEmpty ? true : false;
                  },
                  onAccept: (data) {
                    setState(() {
                      sourceItems[index].isEmpty = false;
                      sourceItems[index].data = data;
                    });
                  },
                )
            );
          }),
    );
  }

  GridView getGridView() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      mainAxisSpacing: marginV,
      crossAxisSpacing: marginH,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(targetItems.length, (index) {
        return DragTarget(
          builder: (context, List<String> candidateData, rejectedData) {
            return targetItems[index].isEmpty
                ? getTargetContainer(horizontalW)
                : new Draggable<String>(
              data: targetItems[index].data,
              dragAnchor: DragAnchor.pointer,
              child: getTargetDraggable(targetItems[index].data,horizontalW),
              feedback: getSourceDraggable(targetItems[index].data,interval),
              childWhenDragging: getTargetContainer(horizontalW),
              onDragCompleted: () {
                setState(() {
                  targetItems[index].isEmpty = true;
                  targetItems[index].data = null;
                });
              },
            );
          },
          onWillAccept: (data) {
            return targetItems[index].isEmpty ? true : false;
          },
          onAccept: (data) {
            setState(() {
              targetItems[index].isEmpty = false;
              targetItems[index].data = data;
            });
          },
        );
      }),
    );
  }

  Widget getSourceDraggable(String data,double size) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
        child: Center(
          child: Text(data),
        ),
      ),
    );
  }

  Widget getSourceContainer(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.grey,
      )),
    );
  }

  Widget getSourceContainerWtBorder(double size) {
    return Container(
      width: size,
      height: size,
    );
  }


  Widget getTargetContainer(double width) {
    return Opacity(
      opacity: 1.0,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.blue,
        ),
        width: width,

      ),
    );
  }

  Widget getTargetDraggable(String data,double width) {
    return Material(
      child: Stack(
        overflow: Overflow.clip,
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: Container(
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.blue,
                    border: Border.all(
                      color: Colors.grey,
                    ))),
          ),
          Positioned(
              bottom: -5,
              right: -5,
              child: Container(
                width: 30,
                height: 30,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                child: Center(
                  child: Text(
                    data,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }


}
