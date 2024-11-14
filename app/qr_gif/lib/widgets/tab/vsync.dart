import 'package:flutter/scheduler.dart';

class VSync implements TickerProvider {
  const VSync();
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
