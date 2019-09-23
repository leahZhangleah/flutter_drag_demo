import 'package:flutter/material.dart';

void something() => runApp(MyApp());

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
  int data = 11;
  bool isSourceEmpty = false,isTargetEmpty = true;
  bool hasEnteredTarget = false;
  var testNumbers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testNumbers = new List<int>.generate(3, (i)=>i+1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:new Column(
        children: <Widget>[
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(3, (index){
              return DragTarget(
                builder: (context, candidateData, rejectedData){
                  return isTargetEmpty?
                  getTargetContainer():
                  new Draggable(
                    //data: candidateData[0],
                    dragAnchor: DragAnchor.pointer,
                    child: getTargetDraggable(candidateData[0]),
                    feedback: getSourceDraggable(candidateData[0]),
                    childWhenDragging: getTargetContainer(),
                    onDragCompleted: (){
                      setState(() {
                        isTargetEmpty = true;
                      });
                    },
                  );
                },
                onWillAccept: (data){
                  return isTargetEmpty?true:false;
                },
                onAccept: (data){
                  setState(() {
                    isTargetEmpty = false;
                  });
                },
                onLeave: (data){

                },
              );
            }),
          ),
          new Container(width: 10,height: 10,),
          new Container(
            height: 60,
            child: ListView.builder(
                itemCount: testNumbers.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return DragTarget(
                    builder: (context, candidateData, rejectedData){
                      String data = candidateData.isEmpty?testNumbers[index].toString():candidateData[0];
                      return isSourceEmpty?
                      getSourceContainer():
                      new Draggable(
                        data:data,
                        child:getSourceDraggable(data) ,
                        feedback: getSourceDraggable(data),
                        childWhenDragging:getSourceContainer(),
                        onDragCompleted:(){
                          setState(() {
                            isSourceEmpty = true;
                          });
                        },
                      );
                    },
                    onWillAccept: (data){
                      return isSourceEmpty? true:false;
                    },
                    onAccept: (data){
                      setState(() {
                        isSourceEmpty = false;
                      });
                    },
                  );
                }
            ),
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
        width: 100,
        height: 100,
        color: Colors.blue,
      ),
    );
  }

  Widget getTargetDraggable(String data){
    return  Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.clip,
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child:  Container(
                width: 100,
                height: 100,
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
