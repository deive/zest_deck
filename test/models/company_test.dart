import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/models/company.dart';

void main() {
  test('Company parsing from example login call', () {
    final userJson = json.decode(exampleResponseLogin);
    final company = Company.fromJson(userJson);

    expect(company.name, "deive");
    expect(company.id, UuidValue("EFCBDC5B-9000-4141-B429-D604A4969058"));
    expect(company.users?.length, 1);
    expect(company.users?.first,
        UuidValue("0785A72C-41D9-476F-A67B-206AE8F45957"));
  });
}

const String exampleResponseLogin = '''{
            "accountPackage": "standard",
            "metadata": {},
            "accountGraceBalance": 0,
            "name": "deive",
            "settings": [],
            "id": "EFCBDC5B-9000-4141-B429-D604A4969058",
            "accountType": "payg",
            "accountSuspendBilling": false,
            "users": [
                "0785A72C-41D9-476F-A67B-206AE8F45957"
            ]
        }''';
