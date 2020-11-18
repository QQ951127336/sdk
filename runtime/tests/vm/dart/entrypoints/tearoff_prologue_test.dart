// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// No type checks are removed here, but we can skip the argument count check.
// VMOptions=--enable-testing-pragmas --no-background-compilation --optimization-counter-threshold=10
// VMOptions=--enable-testing-pragmas --no-background-compilation --optimization-counter-threshold=10 -Denable_inlining=true
// VMOptions=--enable-testing-pragmas --no-background-compilation --optimization-counter-threshold=-1

import "package:expect/expect.dart";
import "common.dart";

class C<T> {
  @NeverInline
  @pragma("vm:testing.unsafe.trace-entrypoints-fn", validateTearoff)
  @pragma("vm:entry-point")
  void samir1(T x) {
    if (x == -1) {
      throw "oh no";
    }
  }
}

void run(void Function(int) test, int i) {
  test(i);
}

main(List<String> args) {
  var c = new C<int>();
  var f = c.samir1;

  const int iterations = benchmarkMode ? 100000000 : 100;
  for (int i = 0; i < iterations; ++i) {
    run(f, i);
  }

  entryPoint.expectChecked(iterations);
  tearoffEntryPoint.expectUnchecked(iterations);
}
