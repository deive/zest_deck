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
  test('API response parsing from example content call', () {
    final userJson = json.decode(exampleUpdateResponse);
    final response = ZestAPIRequestResponse.fromJson(userJson);

    expect(response.companies?.length, 1);
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
               
    final userJson = json.decode(exampleResponseLogin);
    final response = ZestAPIRequestResponse.fromJson(userJson);

    expect(response.companies?.length, 1);
        "validated": true,
        "metadata": {}
    }
}''';

const String exampleUpdateResponse = '''{
    "companies": [
        {
            "accountPackage": "standard",
            "accountType": "payg",
            "id": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
            "name": "deive",
            "accountSuspendBilling": false,
            "settings": [],
            "users": [
                "9C56ADC6-F5FD-41CB-98EB-D60B03B92394"
            ],
            "metadata": {},
            "accountGraceBalance": 0
        }
    ],
    "decks": [
        {
            "sections": [
                {
                    "resources": [],
                    "type": "Headline",
                    "subtitle": "",
                    "id": "B95A57DA-0520-4FEE-8E1F-97CAAFF94FFA",
                    "title": "",
                    "index": 0
                }
            ],
            "thumbnailFile": "90257B40-31B0-462F-8078-2ACD2A2EFFEF",
            "subtitle": "new dck 'o doom.",
            "thumbnail": "FA36801C-2661-40F2-B768-2A3C62EF784D",
            "id": "5824785B-2502-45A2-A2DF-CA15C5C23F91",
            "modified": 659793182.10834,
            "files": [
                {
                    "size": 17853,
                    "ext": "jpg",
                    "resourceId": "FA36801C-2661-40F2-B768-2A3C62EF784D",
                    "metadata": {},
                    "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
                    "mimeType": "image/jpg",
                    "id": "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
                },
                {
                    "size": 2072,
                    "ext": "jpg",
                    "resourceId": "FA36801C-2661-40F2-B768-2A3C62EF784D",
                    "metadata": {
                        "filename": "Bee of Doom.jpg"
                    },
                    "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
                    "mimeType": "image/jpeg",
                    "id": "6F362757-F28B-42D4-8C90-3CA2F4E97326"
                },
                {
                    "size": 309244,
                    "ext": "jpg",
                    "resourceId": "4868E62A-03E6-47EE-94B5-BF5A3DED5D12",
                    "metadata": {
                        "filename": "moo on zero.jpg"
                    },
                    "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
                    "mimeType": "image/jpeg",
                    "id": "AD8DA554-187E-48FF-B1DB-A0AC4B4E2B60"
                },
                {
                    "size": 370008,
                    "ext": "jpg",
                    "resourceId": "4868E62A-03E6-47EE-94B5-BF5A3DED5D12",
                    "metadata": {},
                    "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
                    "mimeType": "image/jpg",
                    "id": "00B03E10-F650-45F9-983E-CC6E6C89EFF1"
                }
            ],
            "resources": [
                {
                    "type": "image",
                    "mime": "image/jpeg",
                    "metadata": {
                        "exif_megapixels": "0.009",
                        "exif_file_permissions": "rw-r--r--",
                        "processor_output": "collected new task",
                        "storage_size": "35681",
                        "exif_color_components": "3",
                        "exif_bits_per_sample": "8",
                        "exif_directory": ".",
                        "exif_file_inode_change_date/time": "2021:11:28 11:52:10+00:00",
                        "exif_file_type_extension": "jpg",
                        "exif_resolution_unit": "None",
                        "exif_mime_type": "image/jpeg",
                        "exif_file_size": "2.0 kB",
                        "exif_image_size": "96x92",
                        "exif_file_type": "JPEG",
                        "exif_image_height": "92",
                        "exif_image_width": "96",
                        "exif_file_name": "6f362757-f28b-42d4-8c90-3ca2f4e97326.jpg",
                        "exif_file_modification_date/time": "2021:11:28 11:52:10+00:00",
                        "exif_y_resolution": "1",
                        "exif_file_access_date/time": "2021:11:28 11:52:10+00:00",
                        "exif_y_cb_cr_sub_sampling": "YCbCr4:2:0 (2 2)",
                        "exif_x_resolution": "1",
                        "exif_exiftool_version_number": "11.88",
                        "exif_jfif_version": "1.01",
                        "exif_encoding_process": "Baseline DCT, Huffman coding"
                    },
                    "description": "",
                    "modified": 659793129.940063,
                    "id": "FA36801C-2661-40F2-B768-2A3C62EF784D",
                    "name": "Bee of Doom",
                    "tags": [],
                    "version": "CEB00139-C070-4169-AC7A-AB6B6A563942",
                    "stage": "Complete",
                    "properties": [],
                    "files": [
                        "thumbnail",
                        [
                            "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
                        ],
                        "chosen_thumbnail",
                        [
                            "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
                        ],
                        "original",
                        [
                            "6F362757-F28B-42D4-8C90-3CA2F4E97326"
                        ],
                        "content",
                        [
                            "6F362757-F28B-42D4-8C90-3CA2F4E97326"
                        ]
                    ],
                    "filename": "Bee of Doom.jpg",
                    "path": []
                },
                {
                    "type": "image",
                    "mime": "image/jpeg",
                    "metadata": {
                        "exif_red_matrix_column": "0.43604 0.22249 0.01392",
                        "exif_red_tone_reproduction_curve": "(Binary data 32 bytes, use -b option to extract)",
                        "exif_jfif_version": "1.01",
                        "exif_blue_tone_reproduction_curve": "(Binary data 32 bytes, use -b option to extract)",
                        "exif_profile_class": "Display Device Profile",
                        "exif_cmm_flags": "Not Embedded, Independent",
                        "exif_file_type_extension": "jpg",
                        "exif_profile_copyright": "Copyright (c) 2016 Google Inc.",
                        "exif_file_type": "JPEG",
                        "exif_device_manufacturer": "Google",
                        "exif_resolution_unit": "inches",
                        "exif_profile_creator": "Google",
                        "exif_file_inode_change_date/time": "2021:11:28 11:52:24+00:00",
                        "exif_image_size": "512x512",
                        "exif_color_components": "3",
                        "exif_profile_description": "sRGB IEC61966-2.1",
                        "exif_primary_platform": "Unknown ()",
                        "exif_media_black_point": "0 0 0",
                        "storage_size": "416518",
                        "exif_green_matrix_column": "0.38512 0.7169 0.09706",
                        "exif_device_attributes": "Reflective, Glossy, Positive, Color",
                        "exif_profile_version": "4.0.0",
                        "exif_profile_connection_space": "XYZ",
                        "processor_output": "collected new task",
                        "exif_exiftool_version_number": "11.88",
                        "exif_connection_space_illuminant": "0.9642 1 0.82491",
                        "exif_profile_id": "75e1a6b13c34376310c8ab660632a28a",
                        "exif_y_cb_cr_sub_sampling": "YCbCr4:2:2 (2 1)",
                        "exif_mime_type": "image/jpeg",
                        "exif_media_white_point": "0.95045 1 1.08905",
                        "exif_profile_file_signature": "acsp",
                        "exif_file_modification_date/time": "2021:11:28 11:52:24+00:00",
                        "exif_profile_cmm_type": "",
                        "exif_image_width": "512",
                        "exif_x_resolution": "96",
                        "exif_directory": ".",
                        "exif_file_name": "ad8da554-187e-48ff-b1db-a0ac4b4e2b60.jpg",
                        "exif_y_resolution": "96",
                        "exif_file_access_date/time": "2021:11:28 11:52:24+00:00",
                        "exif_rendering_intent": "Perceptual",
                        "exif_bits_per_sample": "8",
                        "exif_profile_date_time": "2016:12:08 09:38:28",
                        "exif_encoding_process": "Baseline DCT, Huffman coding",
                        "exif_file_size": "302 kB",
                        "exif_chromatic_adaptation": "1.04788 0.02292 -0.05019 0.02959 0.99048 -0.01704 -0.00922 0.01508 0.75168",
                        "exif_color_space_data": "RGB",
                        "exif_image_height": "512",
                        "exif_file_permissions": "rw-r--r--",
                        "exif_megapixels": "0.262",
                        "exif_blue_matrix_column": "0.14305 0.06061 0.71391",
                        "exif_green_tone_reproduction_curve": "(Binary data 32 bytes, use -b option to extract)",
                        "exif_device_model": ""
                    },
                    "description": "",
                    "modified": 659793143.664944,
                    "id": "4868E62A-03E6-47EE-94B5-BF5A3DED5D12",
                    "name": "moo on zero",
                    "tags": [],
                    "version": "797C75F2-4D41-475C-8DD6-DBB11B276FB7",
                    "stage": "Complete",
                    "properties": [],
                    "files": [
                        "original",
                        [
                            "AD8DA554-187E-48FF-B1DB-A0AC4B4E2B60"
                        ],
                        "chosen_thumbnail",
                        [
                            "00B03E10-F650-45F9-983E-CC6E6C89EFF1"
                        ],
                        "thumbnail",
                        [
                            "00B03E10-F650-45F9-983E-CC6E6C89EFF1"
                        ],
                        "content",
                        [
                            "AD8DA554-187E-48FF-B1DB-A0AC4B4E2B60"
                        ]
                    ],
                    "filename": "moo on zero.jpg",
                    "path": []
                },
                {
                    "type": "image",
                    "mime": "image/jpeg",
                    "metadata": {
                        "storage_size": "35681",
                        "exif_y_resolution": "1",
                        "exif_file_type": "JPEG",
                        "exif_file_name": "6f362757-f28b-42d4-8c90-3ca2f4e97326.jpg",
                        "exif_directory": ".",
                        "exif_encoding_process": "Baseline DCT, Huffman coding",
                        "exif_file_access_date/time": "2021:11:28 11:52:10+00:00",
                        "exif_image_height": "92",
                        "exif_file_type_extension": "jpg",
                        "exif_y_cb_cr_sub_sampling": "YCbCr4:2:0 (2 2)",
                        "exif_file_size": "2.0 kB",
                        "exif_file_permissions": "rw-r--r--",
                        "exif_mime_type": "image/jpeg",
                        "exif_image_size": "96x92",
                        "exif_resolution_unit": "None",
                        "exif_bits_per_sample": "8",
                        "exif_megapixels": "0.009",
                        "exif_file_inode_change_date/time": "2021:11:28 11:52:10+00:00",
                        "exif_file_modification_date/time": "2021:11:28 11:52:10+00:00",
                        "exif_color_components": "3",
                        "exif_exiftool_version_number": "11.88",
                        "exif_image_width": "96",
                        "processor_output": "collected new task",
                        "exif_x_resolution": "1",
                        "exif_jfif_version": "1.01"
                    },
                    "description": "",
                    "modified": 659793129.940063,
                    "id": "FA36801C-2661-40F2-B768-2A3C62EF784D",
                    "name": "Bee of Doom",
                    "tags": [],
                    "version": "CEB00139-C070-4169-AC7A-AB6B6A563942",
                    "stage": "Complete",
                    "properties": [],
                    "files": [
                        "thumbnail",
                        [
                            "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
                        ],
                        "original",
                        [
                            "6F362757-F28B-42D4-8C90-3CA2F4E97326"
                        ],
                        "content",
                        [
                            "6F362757-F28B-42D4-8C90-3CA2F4E97326"
                        ],
                        "chosen_thumbnail",
                        [
                            "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
                        ]
                    ],
                    "filename": "Bee of Doom.jpg",
                    "path": []
                }
            ],
            "metadata": {
                "section-title-colour": "#000000",
                "background-image": "4868e62a-03e6-47ee-94b5-bf5a3ded5d12",
                "logo-image": "fa36801c-2661-40f2-b768-2a3c62ef784d",
                "section-subtitle-colour": "#0a0a0a",
                "header-colour": "#ff9c33",
                "header-text-colour": "#ffffff"
            },
            "title": "New deck",
            "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
            "version": "E4F47320-E494-465B-A7BD-1319C96014FA",
            "rank": 0
        }
    ],
    "user": {
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
        "id": "9C56ADC6-F5FD-41CB-98EB-D60B03B92394",
        "email": "deive@deive.co",
        "password": "59966faf6162312c817daa2abefd710f27a90ffa2f087c10a0dfba996c4ade5cc657a57da12b9d16326c894fd2eab8044dcf8d4a6a557d5e67af74ad7e3e07c0",
        "validated": true,
        "metadata": {},
        "companies": [
            "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C"
        ]
    }
}''';
