import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/widgets.dart';

abstract class IGiphyApiInteractor {
  Future<GiphyGif?> create(BuildContext context);
}
