import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/api_request_response.dart';

void main() {
  test('API response null parsing', () {
    final userJson = json.decode("{}");
    final response = ZestAPIRequestResponse.fromJson(userJson);
    expect(response.user, null);
    expect(response.companies, null);
    expect(response.decks, null);
    expect(response.files, null);
    expect(response.tasks, null);
    expect(response.companyId, null);
    expect(response.resourceId, null);
    expect(response.resources, null);
    expect(response.metadata, null);
  });
  test('API response parsing from example login call', () {
    final userJson = json.decode(exampleResponseLogin);
    final response = ZestAPIRequestResponse.fromJson(userJson);

    expect(response.companies?.length, 1);
    expect(response.metadata?["AuthToken"],
        "3mFKSDHwmQHxaaCMEMRvFKZc5GhpWaix4HTWrsyedUgwsZyKDJbDcXHBKCr8ZYowKYaaxVqMngFD3sbpLjmThVk387Z5bwodF9RiDgSkfbjoYP6WVkvorAgEDvfX5nXZVxDJxF2RRRys4frecZD1BtWPZk9Ts65UB6ByFiDM6TFjZsmsCeZHnppZAuvmJVHRtMDa26Y5nrQUc2QVQixCetGXiPMaxUgYkRatdfAxDvpjaH71XBnRHWC42DneYzfVZcSRZXHdVFjaiZNBucRpqkQkVkvNeEnbBxfeyckmqkdhKdWy6B3U3YuJcxz3AdMx49jVAT8K9nKTp8pJ4thUozzhJuEz1cd5Q3QuM2A3J9zgArXPQaMf");
    expect(
        response.user?.id, UuidValue("9C56ADC6-F5FD-41CB-98EB-D60B03B92394"));
    expect(response.user?.email, "deive@deive.co");
    expect(response.user?.validated, true);
    expect(
        response.user?.id, UuidValue("9C56ADC6-F5FD-41CB-98EB-D60B03B92394"));
  });
}

const String exampleResponseLogin = '''{
    "companies": [
        {
            "id": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
            "accountGraceBalance": 0,
            "accountSuspendBilling": false,
            "settings": [],
            "accountPackage": "standard",
            "name": "deive",
            "users": [
                "9C56ADC6-F5FD-41CB-98EB-D60B03B92394"
            ],
            "accountType": "payg",
            "metadata": {}
        }
    ],
    "metadata": {
        "AuthToken": "3mFKSDHwmQHxaaCMEMRvFKZc5GhpWaix4HTWrsyedUgwsZyKDJbDcXHBKCr8ZYowKYaaxVqMngFD3sbpLjmThVk387Z5bwodF9RiDgSkfbjoYP6WVkvorAgEDvfX5nXZVxDJxF2RRRys4frecZD1BtWPZk9Ts65UB6ByFiDM6TFjZsmsCeZHnppZAuvmJVHRtMDa26Y5nrQUc2QVQixCetGXiPMaxUgYkRatdfAxDvpjaH71XBnRHWC42DneYzfVZcSRZXHdVFjaiZNBucRpqkQkVkvNeEnbBxfeyckmqkdhKdWy6B3U3YuJcxz3AdMx49jVAT8K9nKTp8pJ4thUozzhJuEz1cd5Q3QuM2A3J9zgArXPQaMf"
    },
    "user": {
        "id": "9C56ADC6-F5FD-41CB-98EB-D60B03B92394",
        "email": "deive@deive.co",
        "companies": [
            "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C"
        ],
        "companyGrants": [
            "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
            [
                "cl",
                "dl",
                "rv",
                "dv",
                "pv",
                "uv",
                "acv",
                "bv",
                "av",
                "rm",
                "dm",
                "pm",
                "um",
                "acm",
                "bm",
                "am",
                "rd",
                "dd",
                "pd",
                "ud",
                "acd",
                "bd",
                "ad"
            ]
        ],
        "validated": true,
        "metadata": {}
    }
}''';
