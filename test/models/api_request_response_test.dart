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

    expect(response.metadata?["AuthToken"],
        "BAcBPZS5pMEZx5A8jUxfXyz6f1p3QbSW3r3ZG5eQrJSWbRYprX8forpepukzR6qiWr941XsCZr7QX3LNwxr861T7J5hb1vi2jArNNhLcmVt3hGDbtVVjjLD6BKT4hVVV2fCxUfdJAsHaARmYcVxHzKTydwkMew6Echk8TusgV482ALBKPdUCaaCoJWKKpDcyiiTSkJkKR836jPDU655CTxmshtkshAnooJbdhArubijZYH9qd7SkxqHfCEzSgxJhEpUNMTb7ZEfERWtbJQuqbxYx3s8q31nMh7Hc9uT5FeqCt27qkz6yKAnc16NyehTZfd5oQsYiHKMweP2MwTjE8QJ4Wk9k6VrKQgzVTjHrAz2fJuHQRv97dt6SCW4fDPhoJUPC1rAr4PrJzSeL7dVVNf1ohB5cBwXjUeXc2zCn5GaHs249sY2qURK6PWVBFGAEoqWsR9hYSBjjV4Ddd1zXLiwbUTRgKhJx2");
    expect(
        response.user?.id, UuidValue("24A1E1BA-45D5-44BD-8670-B8676503A45B"));
    expect(response.user?.email, "deive@deive.co");
    expect(response.user?.validated, true);

    expectTestCompany(response);
  });
  test('API response parsing from example content call', () {
    final userJson = json.decode(exampleUpdateResponse);
    final response = ZestAPIRequestResponse.fromJson(userJson);

    expectTestCompany(response);

    expect(response.decks?.length, 1);
    expect(response.decks!.first.id,
        UuidValue("E0ED6652-F5EF-4B74-9BF2-BE8B4E98D7E0"));
    expect(response.decks!.first.title, "doom");
  });
}

expectTestCompany(ZestAPIRequestResponse response) {
  expect(response.companies?.length, 1);
  expect(response.companies!.first.id,
      UuidValue("2274734E-D8F5-4A19-89A2-51F982EEFDE6"));
  expect(response.companies!.first.name, "deive");
}

const String exampleResponseLogin = '''{
    "companies": [
        {
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
        }
    ],
    "metadata": {
        "AuthToken": "BAcBPZS5pMEZx5A8jUxfXyz6f1p3QbSW3r3ZG5eQrJSWbRYprX8forpepukzR6qiWr941XsCZr7QX3LNwxr861T7J5hb1vi2jArNNhLcmVt3hGDbtVVjjLD6BKT4hVVV2fCxUfdJAsHaARmYcVxHzKTydwkMew6Echk8TusgV482ALBKPdUCaaCoJWKKpDcyiiTSkJkKR836jPDU655CTxmshtkshAnooJbdhArubijZYH9qd7SkxqHfCEzSgxJhEpUNMTb7ZEfERWtbJQuqbxYx3s8q31nMh7Hc9uT5FeqCt27qkz6yKAnc16NyehTZfd5oQsYiHKMweP2MwTjE8QJ4Wk9k6VrKQgzVTjHrAz2fJuHQRv97dt6SCW4fDPhoJUPC1rAr4PrJzSeL7dVVNf1ohB5cBwXjUeXc2zCn5GaHs249sY2qURK6PWVBFGAEoqWsR9hYSBjjV4Ddd1zXLiwbUTRgKhJx2"
    },
    "user": {
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
    }
}''';

const String exampleUpdateResponse = '''{
    "user": {
        "email": "deive@deive.co",
        "surname": "i",
        "id": "24A1E1BA-45D5-44BD-8670-B8676503A45B",
        "forename": "deive",
        "validated": true,
        "metadata": {},
        "companyGrants": {},
        "companies": [
            "2274734E-D8F5-4A19-89A2-51F982EEFDE6"
        ]
    },
    "companies": [
        {
            "accountGraceBalance": 0,
            "name": "deive",
            "accountSuspendBilling": false,
            "id": "2274734E-D8F5-4A19-89A2-51F982EEFDE6",
            "settings": [],
            "accountPackage": "standard",
            "accountType": "payg",
            "metadata": {},
            "users": [
                "24A1E1BA-45D5-44BD-8670-B8676503A45B"
            ]
        }
    ],
    "decks": [
        {
            "subtitle": "new dck 'o doom.",
            "modified": "2021-11-29T16:43:01Z",
            "companyId": "2274734E-D8F5-4A19-89A2-51F982EEFDE6",
            "id": "E0ED6652-F5EF-4B74-9BF2-BE8B4E98D7E0",
            "sections": [
                {
                    "id": "1C44332B-70D7-4DCC-B240-CBD87CB54895",
                    "subtitle": "Subtitle o' Doom",
                    "index": 0,
                    "title": "Section 1 o' Doom",
                    "type": "Headline",
                    "resources": []
                },
                {
                    "id": "4D0F0017-008B-43D3-A9FB-89049AD2C945",
                    "subtitle": "",
                    "index": 0,
                    "title": "",
                    "type": "Headline",
                    "resources": []
                }
            ],
            "thumbnailFile": "B1A56E82-0459-4327-98EA-8705419DD518",
            "files": [
                {
                    "id": "B1A56E82-0459-4327-98EA-8705419DD518",
                    "size": 17853,
                    "mimeType": "image/jpg",
                    "ext": "jpg",
                    "metadata": {},
                    "resourceId": "82E5A188-382B-441A-AB5F-C8F1D0BA5EF6",
                    "companyId": "2274734E-D8F5-4A19-89A2-51F982EEFDE6"
                },
                {
                    "id": "4A929B75-406B-494E-8126-812FD947B32C",
                    "size": 2072,
                    "mimeType": "image/jpeg",
                    "ext": "jpg",
                    "metadata": {
                        "filename": "Bee of Doom.jpg"
                    },
                    "resourceId": "82E5A188-382B-441A-AB5F-C8F1D0BA5EF6",
                    "companyId": "2274734E-D8F5-4A19-89A2-51F982EEFDE6"
                },
                {
                    "id": "C07A3508-1ED4-4A29-B6D4-880CC299FDE2",
                    "size": 309244,
                    "mimeType": "image/jpeg",
                    "ext": "jpg",
                    "metadata": {
                        "filename": "moo on zero.jpg"
                    },
                    "resourceId": "B7091DDA-C4C4-4BB6-BB05-A0F9F1163743",
                    "companyId": "2274734E-D8F5-4A19-89A2-51F982EEFDE6"
                },
                {
                    "id": "7B6545E0-1FEE-499A-BCA7-C2BF2933E4C0",
                    "metadata": {},
                    "companyId": "2274734E-D8F5-4A19-89A2-51F982EEFDE6",
                    "ext": "jpg",
                    "size": 370008,
                    "resourceId": "B7091DDA-C4C4-4BB6-BB05-A0F9F1163743",
                    "mimeType": "image/jpg"
                },
                {
                    "id": "FE383FC5-975D-48C3-B591-F41C79671F74",
                    "metadata": {},
                    "companyId": "2274734E-D8F5-4A19-89A2-51F982EEFDE6",
                    "ext": "jpg",
                    "size": 22252,
                    "resourceId": "A1B694DC-1DEC-4A0B-A73B-FD19AAD7FACC",
                    "mimeType": "image/jpg"
                },
                {
                    "id": "8375B4B3-EFDE-4143-8E0F-1C0F6ED1C6D4",
                    "metadata": {
                        "filename": "gir.jpg"
                    },
                    "companyId": "2274734E-D8F5-4A19-89A2-51F982EEFDE6",
                    "ext": "jpg",
                    "size": 5926,
                    "resourceId": "A1B694DC-1DEC-4A0B-A73B-FD19AAD7FACC",
                    "mimeType": "image/jpeg"
                }
            ],
            "thumbnail": "82E5A188-382B-441A-AB5F-C8F1D0BA5EF6",
            "version": "4CEAEB14-DEB2-430A-A525-E2D7D85DCA00",
            "title": "doom",
            "rank": 0,
            "metadata": {
                "logo-image": "a1b694dc-1dec-4a0b-a73b-fd19aad7facc",
                "section-title-colour": "#000000",
                "background-image": "b7091dda-c4c4-4bb6-bb05-a0f9f1163743",
                "header-colour": "#ff9c33",
                "section-subtitle-colour": "#0a0a0a",
                "header-text-colour": "#ffffff"
            },
            "resources": [
                {
                    "description": "",
                    "searchableText": {},
                    "mime": "image/jpeg",
                    "tags": [],
                    "modified": "2021-11-29T16:41:43Z",
                    "version": "4FD2AEB6-C73F-4791-B880-8E20A370EEFF",
                    "id": "82E5A188-382B-441A-AB5F-C8F1D0BA5EF6",
                    "type": "image",
                    "metadata": {},
                    "stage": "Complete",
                    "filename": "Bee of Doom.jpg",
                    "path": [],
                    "files": {
                        "thumbnail": [
                            "B1A56E82-0459-4327-98EA-8705419DD518"
                        ],
                        "original": [
                            "4A929B75-406B-494E-8126-812FD947B32C"
                        ],
                        "chosen_thumbnail": [
                            "B1A56E82-0459-4327-98EA-8705419DD518"
                        ],
                        "content": [
                            "4A929B75-406B-494E-8126-812FD947B32C"
                        ]
                    },
                    "name": "Bee of Doom",
                    "exif": {
                        "exif_encoding_process": "Baseline DCT, Huffman coding",
                        "exif_y_cb_cr_sub_sampling": "YCbCr4:2:0 (2 2)",
                        "exif_file_type": "JPEG",
                        "exif_image_size": "96x92",
                        "exif_file_name": "4a929b75-406b-494e-8126-812fd947b32c.jpg",
                        "exif_file_access_date/time": "2021:11:29 16:41:45+00:00",
                        "exif_resolution_unit": "None",
                        "exif_file_inode_change_date/time": "2021:11:29 16:41:45+00:00",
                        "exif_bits_per_sample": "8",
                        "exif_image_height": "92",
                        "exif_y_resolution": "1",
                        "exif_image_width": "96",
                        "exif_megapixels": "0.009",
                        "exif_file_permissions": "rw-r--r--",
                        "exif_mime_type": "image/jpeg",
                        "exif_file_modification_date/time": "2021:11:29 16:41:45+00:00",
                        "exif_color_components": "3",
                        "exif_directory": ".",
                        "exif_x_resolution": "1",
                        "exif_exiftool_version_number": "11.88",
                        "exif_jfif_version": "1.01",
                        "exif_file_size": "2.0 kB",
                        "exif_file_type_extension": "jpg"
                    },
                    "properties": []
                },
                {
                    "description": "",
                    "searchableText": {},
                    "mime": "image/jpeg",
                    "tags": [],
                    "modified": "2021-11-29T16:41:45Z",
                    "version": "48071022-9A25-4BBB-A236-55D8D4325519",
                    "id": "B7091DDA-C4C4-4BB6-BB05-A0F9F1163743",
                    "type": "image",
                    "metadata": {},
                    "stage": "Complete",
                    "filename": "moo on zero.jpg",
                    "path": [],
                    "files": {
                        "content": [
                            "C07A3508-1ED4-4A29-B6D4-880CC299FDE2"
                        ],
                        "chosen_thumbnail": [
                            "7B6545E0-1FEE-499A-BCA7-C2BF2933E4C0"
                        ],
                        "original": [
                            "C07A3508-1ED4-4A29-B6D4-880CC299FDE2"
                        ],
                        "thumbnail": [
                            "7B6545E0-1FEE-499A-BCA7-C2BF2933E4C0"
                        ]
                    },
                    "name": "moo on zero",
                    "exif": {
                        "exif_bits_per_sample": "8",
                        "exif_file_type": "JPEG",
                        "exif_profile_date_time": "2016:12:08 09:38:28",
                        "exif_file_permissions": "rw-r--r--",
                        "exif_jfif_version": "1.01",
                        "exif_profile_id": "75e1a6b13c34376310c8ab660632a28a",
                        "exif_image_height": "512",
                        "exif_image_width": "512",
                        "exif_profile_creator": "Google",
                        "exif_cmm_flags": "Not Embedded, Independent",
                        "exif_exiftool_version_number": "11.88",
                        "exif_red_matrix_column": "0.43604 0.22249 0.01392",
                        "exif_green_matrix_column": "0.38512 0.7169 0.09706",
                        "exif_file_size": "302 kB",
                        "exif_connection_space_illuminant": "0.9642 1 0.82491",
                        "exif_device_model": "",
                        "exif_image_size": "512x512",
                        "exif_mime_type": "image/jpeg",
                        "exif_blue_tone_reproduction_curve": "(Binary data 32 bytes, use -b option to extract)",
                        "exif_profile_connection_space": "XYZ",
                        "exif_color_space_data": "RGB",
                        "exif_media_black_point": "0 0 0",
                        "exif_device_manufacturer": "Google",
                        "exif_y_resolution": "96",
                        "exif_profile_cmm_type": "",
                        "exif_chromatic_adaptation": "1.04788 0.02292 -0.05019 0.02959 0.99048 -0.01704 -0.00922 0.01508 0.75168",
                        "exif_x_resolution": "96",
                        "exif_resolution_unit": "inches",
                        "exif_color_components": "3",
                        "exif_y_cb_cr_sub_sampling": "YCbCr4:2:2 (2 1)",
                        "exif_profile_file_signature": "acsp",
                        "exif_file_modification_date/time": "2021:11:29 16:41:46+00:00",
                        "exif_file_access_date/time": "2021:11:29 16:41:46+00:00",
                        "exif_file_type_extension": "jpg",
                        "exif_green_tone_reproduction_curve": "(Binary data 32 bytes, use -b option to extract)",
                        "exif_profile_class": "Display Device Profile",
                        "exif_red_tone_reproduction_curve": "(Binary data 32 bytes, use -b option to extract)",
                        "exif_profile_version": "4.0.0",
                        "exif_media_white_point": "0.95045 1 1.08905",
                        "exif_profile_copyright": "Copyright (c) 2016 Google Inc.",
                        "exif_encoding_process": "Baseline DCT, Huffman coding",
                        "exif_rendering_intent": "Perceptual",
                        "exif_profile_description": "sRGB IEC61966-2.1",
                        "exif_device_attributes": "Reflective, Glossy, Positive, Color",
                        "exif_megapixels": "0.262",
                        "exif_primary_platform": "Unknown ()",
                        "exif_file_name": "c07a3508-1ed4-4a29-b6d4-880cc299fde2.jpg",
                        "exif_file_inode_change_date/time": "2021:11:29 16:41:46+00:00",
                        "exif_blue_matrix_column": "0.14305 0.06061 0.71391",
                        "exif_directory": "."
                    },
                    "properties": []
                },
                {
                    "path": [],
                    "tags": [],
                    "mime": "image/jpeg",
                    "description": "",
                    "modified": "2021-11-29T16:41:44Z",
                    "properties": [],
                    "version": "936310BC-700B-4B0E-BA0A-87C4683868AC",
                    "files": {
                        "original": [
                            "8375B4B3-EFDE-4143-8E0F-1C0F6ED1C6D4"
                        ],
                        "thumbnail": [
                            "FE383FC5-975D-48C3-B591-F41C79671F74"
                        ],
                        "chosen_thumbnail": [
                            "FE383FC5-975D-48C3-B591-F41C79671F74"
                        ],
                        "content": [
                            "8375B4B3-EFDE-4143-8E0F-1C0F6ED1C6D4"
                        ]
                    },
                    "stage": "Complete",
                    "name": "gir",
                    "type": "image",
                    "filename": "gir.jpg",
                    "exif": {
                        "exif_file_size": "5.8 kB",
                        "exif_image_height": "204",
                        "exif_color_components": "3",
                        "exif_file_inode_change_date/time": "2021:11:29 16:41:48+00:00",
                        "exif_file_type": "JPEG",
                        "exif_jfif_version": "1.01",
                        "exif_mime_type": "image/jpeg",
                        "exif_megapixels": "0.042",
                        "exif_resolution_unit": "None",
                        "exif_file_access_date/time": "2021:11:29 16:41:48+00:00",
                        "exif_image_size": "204x204",
                        "exif_image_width": "204",
                        "exif_file_name": "8375b4b3-efde-4143-8e0f-1c0f6ed1c6d4.jpg",
                        "exif_bits_per_sample": "8",
                        "exif_exiftool_version_number": "11.88",
                        "exif_encoding_process": "Baseline DCT, Huffman coding",
                        "exif_file_permissions": "rw-r--r--",
                        "exif_x_resolution": "1",
                        "exif_y_resolution": "1",
                        "exif_directory": ".",
                        "exif_file_type_extension": "jpg",
                        "exif_file_modification_date/time": "2021:11:29 16:41:48+00:00",
                        "exif_y_cb_cr_sub_sampling": "YCbCr4:2:0 (2 2)"
                    },
                    "id": "A1B694DC-1DEC-4A0B-A73B-FD19AAD7FACC",
                    "searchableText": {},
                    "metadata": {}
                }
            ]
        }
    ]
}''';
