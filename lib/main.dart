import 'package:flutter/material.dart';

import 'DragItem.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var targetItems, sourceItems;

  //var testNumbers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //testNumbers = new List<int>.generate(3, (i)=>i+1);
    targetItems = new List<DragItem>.generate(3, (i) {
      var item = new DragItem();
      item.isEmpty = true;
      return item;
    });
    sourceItems = new List<DragItem>.generate(3, (i) {
      var item = new DragItem();
      item.isEmpty = false;
      item.data = (i + 1).toString();
      return item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            width: 10,
            height: 10,
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(3, (index) {
              return DragTarget(
                builder: (context, List<String> candidateData, rejectedData) {
                  return targetItems[index].isEmpty
                      ? getTargetContainer()
                      : new Draggable<String>(
                          data: targetItems[index].data,
                          dragAnchor: DragAnchor.pointer,
                          child: getTargetDraggable(targetItems[index].data),
                          feedback: getSourceDraggable(targetItems[index].data),
                          childWhenDragging: getTargetContainer(),
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
          ),
          new Container(
            width: 10,
            height: 10,
          ),
          new Container(
            height: 60,
            child: ListView.builder(
                itemCount: sourceItems.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return DragTarget(
                    builder:
                        (context, List<String> candidateData, rejectedData) {
                      String data = sourceItems[index].data;
                      return sourceItems[index].isEmpty
                          ? getSourceContainer()
                          : new Draggable<String>(
                              data: data,
                              child: getSourceDraggable(data),
                              feedback: getSourceDraggable(data),
                              childWhenDragging: getSourceContainer(),
                              onDragCompleted: () {
                                setState(() {
                                  sourceItems[index].isEmpty = true;
                                  sourceItems[index].data = null;
                                });
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
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget getSourceDraggable(String data) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
        child: Center(
          child: Text(data),
        ),
      ),
    );
  }

  Widget getSourceContainer() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.grey,
      )),
    );
  }

  Widget getTargetContainer() {
    return Opacity(
      opacity: 1.0,
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
      ),
    );
  }

  Widget getTargetDraggable(String data) {
    return Material(
      child: Stack(
        overflow: Overflow.clip,
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
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
