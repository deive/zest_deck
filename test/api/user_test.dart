import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest/api/user.dart';

void main() {
  test('User parsing from example login call', () {
    final userJson = json.decode(exampleResponseLogin);
    final user = User.fromJson(userJson);

    expect(user.email, "deive@deive.co");
    expect(user.validated, true);
    expect(user.id, UuidValue("0785A72C-41D9-476F-A67B-206AE8F45957"));
  });
}

const String exampleResponseLogin = '''{
        "surname": "i",
        "metadata": {},
        "userGrants": [],
        "email": "deive@deive.co",
        "companies": [
            "EFCBDC5B-9000-4141-B429-D604A4969058"
        ],
        "id": "0785A72C-41D9-476F-A67B-206AE8F45957",
        "validated": true,
        "forename": "deive"
    }''';
