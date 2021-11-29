import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/models/company.dart';

void main() {
  test('Company parsing from example login call', () {
    final userJson = json.decode(exampleResponseLogin);
    final company = Company.fromJson(userJson);

    expect(company.name, "deive");
    expect(company.id, UuidValue("2274734E-D8F5-4A19-89A2-51F982EEFDE6"));
    expect(company.users?.length, 1);
    expect(company.users?.first,
        UuidValue("24A1E1BA-45D5-44BD-8670-B8676503A45B"));
  });
}

const String exampleResponseLogin = '''{
            "accountPackage": "standard",
            "settings": [],
            "accountSuspendBilling": false,
            "accountGraceBalance": 0,
            "metadata": {},
            "accountType": "payg",
            "id": "2274734E-D8F5-4A19-89A2-51F982EEFDE6",
            "name": "deive",
            "users": [
                "24A1E1BA-45D5-44BD-8670-B8676503A45B"
            ]
        }''';
