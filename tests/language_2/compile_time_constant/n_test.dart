// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.9

import "package:expect/expect.dart";

class A {
  const A();
  operator ==(x) => x == 499;
}

var a = const A();

main() {
  if (const A() != 499) Expect.isTrue("const equality failed");
  Expect.isTrue(a == 499);
}
