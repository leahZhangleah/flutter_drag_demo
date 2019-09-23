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
  bool isSourceEmpty = false,isTargetEmpty = true;
  bool hasEnteredTarget = false;
  var testNumbers;
  DragItem dragTargetItem, dragSourceItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testNumbers = new List<int>.generate(3, (i)=>i+1);
    dragTargetItem = new DragItem();
    dragSourceItem = new DragItem();
    dragTargetItem.isEmpty = true;
    dragSourceItem.isEmpty = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:new Column(
        children: <Widget>[
          new Container(width: 10,height: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DragTarget(
                builder: (context, List<String> candidateData, rejectedData){
                  return dragTargetItem.isEmpty?
                  getTargetContainer():
                  new Draggable<String>(
                    data: dragTargetItem.data,
                    dragAnchor: DragAnchor.pointer,
                    child: getTargetDraggable(dragTargetItem.data),
                    feedback: getSourceDraggable(dragTargetItem.data),
                    childWhenDragging: getTargetContainer(),
                    onDragCompleted: (){
                      setState(() {
                        dragTargetItem.isEmpty = true;
                      });
                    },
                  );
                },
                onWillAccept: (data){
                  return dragTargetItem.isEmpty?true:false;
                },
                onAccept: (data){
                  setState(() {
                    dragTargetItem.isEmpty = false;
                    dragTargetItem.data = data;
                  });
                },
              ),
            ],
          ),
          new Container(width: 10,height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DragTarget(
                builder: (context, List<String> candidateData, rejectedData){
                  String data = dragSourceItem.data==null?testNumbers[0].toString():dragSourceItem.data;
                  return dragSourceItem.isEmpty?
                  getSourceContainer():
                  new Draggable<String>(
                    data:data,
                    child:getSourceDraggable(data) ,
                    feedback: getSourceDraggable(data),
                    childWhenDragging:getSourceContainer(),
                    onDragCompleted:(){
                      setState(() {
                        dragSourceItem.isEmpty = true;
                      });
                    },
                  );
                },
                onWillAccept: (data){
                  return dragSourceItem.isEmpty? true:false;
                },
                onAccept: (data){
                  setState(() {
                    dragSourceItem.isEmpty = false;
                    dragSourceItem.data = data;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getSourceDraggable(String data){
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber
        ),
        child: Center(
          child: Text(data),
        ),
      ),
    );
  }

  Widget getSourceContainer(){
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            border:Border.all(
              color: Colors.grey,
            )
        ),
      );
  }

  Widget getTargetContainer(){
    return Opacity(
        opacity: 1.0,
        child:  Container(
          width: 200,
          height: 200,
          color: Colors.blue,
        ),
    );
  }

  Widget getTargetDraggable(String data){
      return  Material(
        child: Stack(
          overflow: Overflow.clip,
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            Opacity(
              opacity: 0.5,
              child:  Container(
                width: 200,
                height: 200,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border:Border.all(
                        color: Colors.grey,
                      )
                  )
              ),
            ),
            Positioned(
                bottom: -5,
                right: -5,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                  child: Center(
                    child: Text(
                        data,
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      );
  }
}
