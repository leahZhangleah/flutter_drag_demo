import 'dart:async';

import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier{
  Stopwatch _watch;
  Timer _timer;

  Duration _currentDuration = Duration.zero;

  String get currentDuration => _currentDuration.toString().substring(0,7).padLeft(8,'0');

  bool get isRunning => _timer != null;

  TimerService(){
    _watch = Stopwatch();
  }

  void _onTick(Timer timer){
    _currentDuration = _watch.elapsed;
    notifyListeners();
  }

  void start(){
    if(_timer !=null) return;
    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    _watch.start();
    notifyListeners();
  }

  void stop(){
    _timer?.cancel();
    _timer = null;
    _watch.stop();
    _currentDuration = _watch.elapsed;
    notifyListeners();
  }

  void reset(){
    stop();
    _watch.reset();
    _currentDuration = Duration.zero;
    notifyListeners();
  }

  static TimerService of(BuildContext context){
    var provider = context.inheritFromWidgetOfExactType(TimerServiceProvider) as TimerServiceProvider;
    return provider.service;
  }
}

class TimerServiceProvider extends InheritedWidget{
  final TimerService service;


  TimerServiceProvider({Key key, this.service,Widget child})
    :super(key:key,child:child);

  @override
  bool updateShouldNotify(TimerServiceProvider oldWidget) {
    return service != oldWidget.service;
  }

}