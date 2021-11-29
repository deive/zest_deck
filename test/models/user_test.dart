import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/users/user.dart';

void main() {
  test('User parsing from example login call', () {
    final userJson = json.decode(exampleResponseLogin);
    final user = User.fromJson(userJson);

    expect(user.email, "deive@deive.co");
    expect(user.validated, true);
    expect(user.id, UuidValue("24A1E1BA-45D5-44BD-8670-B8676503A45B"));
    // TODO: Test grants when in.
    // expect(user.companyGrants?.length, 1);
    // final companyId = UuidValue("65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C");
    // expect(user.companyGrants!.containsKey(companyId), true);
    // final grants = user.companyGrants![companyId]!;
    // expect(grants.length, 23);
  });
}

const String exampleResponseLogin = '''{
        "metadata": {},
        "id": "24A1E1BA-45D5-44BD-8670-B8676503A45B",
        "validated": true,
        "companies": [
            "2274734E-D8F5-4A19-89A2-51F982EEFDE6"
        ],
        "forename": "deive",
        "surname": "i",
        "email": "deive@deive.co",
        "companyGrants": {}
    }''';
