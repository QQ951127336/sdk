// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library fasta.redirecting_factory_body;

import 'package:kernel/ast.dart' show
    InvalidStatement,
    Member,
    Procedure;

class RedirectingFactoryBody extends InvalidStatement {
  final Member target;

  RedirectingFactoryBody(this.target);
}

bool isRedirectingFactory(Member member) {
  return member is Procedure &&
      member.function.body is RedirectingFactoryBody;
}

Member getImmediateRedirectionTarget(Member member) {
  if (isRedirectingFactory(member)) {
    Procedure procedure = member;
    RedirectingFactoryBody body = procedure.function.body;
    return body.target;
  } else {
    return null;
  }
}

Member getRedirectionTarget(Procedure member) {
  // We use the [tortoise and hare algorithm]
  // (https://en.wikipedia.org/wiki/Cycle_detection#Tortoise_and_hare) to
  // handle cycles.
  Member tortoise = member;
  Member hare = getImmediateRedirectionTarget(member);
  while (tortoise != hare) {
    if (!isRedirectingFactory(tortoise)) return tortoise;
    tortoise = getImmediateRedirectionTarget(tortoise);
    hare = getImmediateRedirectionTarget(getImmediateRedirectionTarget(hare));
  }
  return null;
}
