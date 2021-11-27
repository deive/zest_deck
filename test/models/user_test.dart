import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/models/user.dart';

void main() {
  test('User parsing from example login call', () {
    final userJson = json.decode(exampleResponseLogin);
    final user = User.fromJson(userJson);

    expect(user.email, "deive@deive.co");
    expect(user.validated, true);
    expect(user.id, UuidValue("9C56ADC6-F5FD-41CB-98EB-D60B03B92394"));
    // TODO: Test grants when in.
    // expect(user.companyGrants?.length, 1);
    // final companyId = UuidValue("65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C");
    // expect(user.companyGrants!.containsKey(companyId), true);
    // final grants = user.companyGrants![companyId]!;
    // expect(grants.length, 23);
  });
}

const String exampleResponseLogin = '''{
      "companyGrants":
        ["65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
          ["cl","dl","rv","dv","pv","uv","acv","bv","av","rm","dm","pm","um","acm","bm","am","rd","dd","pd","ud","acd","bd","ad"]
        ],
      "email":"deive@deive.co",
      "validated":true,
      "id":"9C56ADC6-F5FD-41CB-98EB-D60B03B92394",
      "metadata":{},
      "companies":["65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C"]
      }''';
