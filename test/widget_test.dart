import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
  test('Test extensions availability', () {

    
    const double value = 10.0;
    
   
    expect(value.s, 10.0);
    expect(value.fz, 10.0);
    expect(value.w, 10.0);
  });
}
