import 'modules/carp_test.dart' as carp_test;
import 'modules/pike_builder_test.dart' as pike_builder_test;
import 'modules/pike_consumer_test.dart' as pike_consumer_test;

import 'modules/pike_observer_test.dart' as pike_observer_test;
import 'modules/pike_test.dart' as pike_test;

void main() {
  pike_test.main();
  carp_test.main();
  pike_observer_test.main();
  pike_builder_test.main();
  pike_consumer_test.main();
}
