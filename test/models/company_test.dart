import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/models/company.dart';

void main() {
  test('Company parsing from example login call', () {
    final userJson = json.decode(exampleResponseLogin);
    final company = Company.fromJson(userJson);

    expect(company.name, "deive");
    expect(company.id, UuidValue("65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C"));
    expect(company.users?.length, 1);
    expect(company.users?.first,
        UuidValue("9C56ADC6-F5FD-41CB-98EB-D60B03B92394"));
  });
}

const String exampleResponseLogin = '''
        {
            "accountGraceBalance": 0,
            "accountSuspendBilling": false,
            "users": [
                "9C56ADC6-F5FD-41CB-98EB-D60B03B92394"
            ],
            "metadata": {},
            "id": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
            "name": "deive",
            "accountPackage": "standard",
            "settings": [],
            "accountType": "payg"
        }''';
