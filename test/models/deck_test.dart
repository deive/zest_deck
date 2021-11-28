import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/decks/deck.dart';
import 'package:zest_deck/app/models/resource.dart';
import 'package:zest_deck/app/models/section.dart';

void main() {
  test('Deck parsing from example call', () {
    final deckJson = json.decode(exampleResponse);
    final deck = Deck.fromJson(deckJson);

    expect(deck.title, "New deck");
    expect(deck.id, UuidValue("5824785B-2502-45A2-A2DF-CA15C5C23F91"));
    expect(deck.resources.length, 3);
    expect(deck.resources.first.id,
        UuidValue("FA36801C-2661-40F2-B768-2A3C62EF784D"));
    expect(deck.resources.first.type, ResourceType.image);
    expect(deck.sections.length, 1);
    expect(deck.sections.first.id,
        UuidValue("B95A57DA-0520-4FEE-8E1F-97CAAFF94FFA"));
    expect(deck.sections.first.type, SectionType.headline);
  });
}

const String exampleResponse = '''{
  "rank": 0,
  "subtitle": "new dck 'o doom.",
  "title": "New deck",
  "id": "5824785B-2502-45A2-A2DF-CA15C5C23F91",
  "resources": [
      {
          "version": "CEB00139-C070-4169-AC7A-AB6B6A563942",
          "description": "",
          "mime": "image/jpeg",
          "files": [
              "thumbnail",
              [
                  "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
              ],
              "chosen_thumbnail",
              [
                  "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
              ],
              "content",
              [
                  "6F362757-F28B-42D4-8C90-3CA2F4E97326"
              ],
              "original",
              [
                  "6F362757-F28B-42D4-8C90-3CA2F4E97326"
              ]
          ],
          "properties": [],
          "filename": "Bee of Doom.jpg",
          "modified": "2021-11-28T11:52:09Z",
          "metadata": {
              "exif_file_inode_change_date/time": "2021:11:28 11:52:10+00:00",
              "exif_exiftool_version_number": "11.88",
              "exif_file_access_date/time": "2021:11:28 11:52:10+00:00",
              "exif_color_components": "3",
              "exif_y_cb_cr_sub_sampling": "YCbCr4:2:0 (2 2)",
              "exif_file_name": "6f362757-f28b-42d4-8c90-3ca2f4e97326.jpg",
              "exif_image_height": "92",
              "exif_mime_type": "image/jpeg",
              "exif_megapixels": "0.009",
              "exif_file_modification_date/time": "2021:11:28 11:52:10+00:00",
              "exif_encoding_process": "Baseline DCT, Huffman coding",
              "exif_file_size": "2.0 kB",
              "exif_image_size": "96x92",
              "exif_bits_per_sample": "8",
              "exif_file_type": "JPEG",
              "storage_size": "35681",
              "exif_x_resolution": "1",
              "processor_output": "collected new task",
              "exif_jfif_version": "1.01",
              "exif_file_type_extension": "jpg",
              "exif_image_width": "96",
              "exif_resolution_unit": "None",
              "exif_y_resolution": "1",
              "exif_directory": ".",
              "exif_file_permissions": "rw-r--r--"
          },
          "type": "image",
          "tags": [],
          "path": [],
          "name": "Bee of Doom",
          "stage": "Complete",
          "id": "FA36801C-2661-40F2-B768-2A3C62EF784D"
      },
      {
          "version": "797C75F2-4D41-475C-8DD6-DBB11B276FB7",
          "description": "",
          "mime": "image/jpeg",
          "files": [
              "content",
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
              "original",
              [
                  "AD8DA554-187E-48FF-B1DB-A0AC4B4E2B60"
              ]
          ],
          "properties": [],
          "filename": "moo on zero.jpg",
          "modified": "2021-11-28T11:52:23Z",
          "metadata": {
              "processor_output": "collected new task",
              "exif_media_black_point": "0 0 0",
              "exif_resolution_unit": "inches",
              "exif_file_modification_date/time": "2021:11:28 11:52:24+00:00",
              "exif_y_resolution": "96",
              "exif_device_attributes": "Reflective, Glossy, Positive, Color",
              "exif_file_permissions": "rw-r--r--",
              "exif_blue_tone_reproduction_curve": "(Binary data 32 bytes, use -b option to extract)",
              "exif_red_tone_reproduction_curve": "(Binary data 32 bytes, use -b option to extract)",
              "exif_cmm_flags": "Not Embedded, Independent",
              "exif_profile_version": "4.0.0",
              "exif_color_components": "3",
              "exif_x_resolution": "96",
              "exif_device_model": "",
              "exif_media_white_point": "0.95045 1 1.08905",
              "exif_profile_file_signature": "acsp",
              "exif_file_name": "ad8da554-187e-48ff-b1db-a0ac4b4e2b60.jpg",
              "exif_bits_per_sample": "8",
              "exif_file_type": "JPEG",
              "exif_primary_platform": "Unknown ()",
              "exif_megapixels": "0.262",
              "exif_profile_creator": "Google",
              "exif_green_tone_reproduction_curve": "(Binary data 32 bytes, use -b option to extract)",
              "storage_size": "416518",
              "exif_image_height": "512",
              "exif_file_type_extension": "jpg",
              "exif_profile_date_time": "2016:12:08 09:38:28",
              "exif_profile_copyright": "Copyright (c) 2016 Google Inc.",
              "exif_chromatic_adaptation": "1.04788 0.02292 -0.05019 0.02959 0.99048 -0.01704 -0.00922 0.01508 0.75168",
              "exif_profile_connection_space": "XYZ",
              "exif_directory": ".",
              "exif_profile_cmm_type": "",
              "exif_profile_class": "Display Device Profile",
              "exif_rendering_intent": "Perceptual",
              "exif_encoding_process": "Baseline DCT, Huffman coding",
              "exif_mime_type": "image/jpeg",
              "exif_jfif_version": "1.01",
              "exif_device_manufacturer": "Google",
              "exif_image_size": "512x512",
              "exif_file_access_date/time": "2021:11:28 11:52:24+00:00",
              "exif_blue_matrix_column": "0.14305 0.06061 0.71391",
              "exif_red_matrix_column": "0.43604 0.22249 0.01392",
              "exif_file_size": "302 kB",
              "exif_color_space_data": "RGB",
              "exif_image_width": "512",
              "exif_y_cb_cr_sub_sampling": "YCbCr4:2:2 (2 1)",
              "exif_green_matrix_column": "0.38512 0.7169 0.09706",
              "exif_exiftool_version_number": "11.88",
              "exif_connection_space_illuminant": "0.9642 1 0.82491",
              "exif_profile_description": "sRGB IEC61966-2.1",
              "exif_profile_id": "75e1a6b13c34376310c8ab660632a28a",
              "exif_file_inode_change_date/time": "2021:11:28 11:52:24+00:00"
          },
          "type": "image",
          "tags": [],
          "path": [],
          "name": "moo on zero",
          "stage": "Complete",
          "id": "4868E62A-03E6-47EE-94B5-BF5A3DED5D12"
      },
      {
          "version": "CEB00139-C070-4169-AC7A-AB6B6A563942",
          "description": "",
          "mime": "image/jpeg",
          "files": [
              "content",
              [
                  "6F362757-F28B-42D4-8C90-3CA2F4E97326"
              ],
              "chosen_thumbnail",
              [
                  "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
              ],
              "thumbnail",
              [
                  "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
              ],
              "original",
              [
                  "6F362757-F28B-42D4-8C90-3CA2F4E97326"
              ]
          ],
          "properties": [],
          "filename": "Bee of Doom.jpg",
          "modified": "2021-11-28T11:52:09Z",
          "metadata": {
              "exif_color_components": "3",
              "processor_output": "collected new task",
              "exif_file_access_date/time": "2021:11:28 11:52:10+00:00",
              "exif_resolution_unit": "None",
              "storage_size": "35681",
              "exif_exiftool_version_number": "11.88",
              "exif_image_width": "96",
              "exif_image_size": "96x92",
              "exif_bits_per_sample": "8",
              "exif_file_name": "6f362757-f28b-42d4-8c90-3ca2f4e97326.jpg",
              "exif_image_height": "92",
              "exif_x_resolution": "1",
              "exif_y_resolution": "1",
              "exif_file_size": "2.0 kB",
              "exif_jfif_version": "1.01",
              "exif_file_type_extension": "jpg",
              "exif_file_modification_date/time": "2021:11:28 11:52:10+00:00",
              "exif_file_type": "JPEG",
              "exif_megapixels": "0.009",
              "exif_mime_type": "image/jpeg",
              "exif_y_cb_cr_sub_sampling": "YCbCr4:2:0 (2 2)",
              "exif_file_inode_change_date/time": "2021:11:28 11:52:10+00:00",
              "exif_file_permissions": "rw-r--r--",
              "exif_encoding_process": "Baseline DCT, Huffman coding",
              "exif_directory": "."
          },
          "type": "image",
          "tags": [],
          "path": [],
          "name": "Bee of Doom",
          "stage": "Complete",
          "id": "FA36801C-2661-40F2-B768-2A3C62EF784D"
      }
  ],
  "thumbnail": "FA36801C-2661-40F2-B768-2A3C62EF784D",
  "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
  "thumbnailFile": "90257B40-31B0-462F-8078-2ACD2A2EFFEF",
  "metadata": {
      "background-image": "4868e62a-03e6-47ee-94b5-bf5a3ded5d12",
      "header-text-colour": "#ffffff",
      "logo-image": "fa36801c-2661-40f2-b768-2a3c62ef784d",
      "header-colour": "#ff9c33",
      "section-title-colour": "#000000",
      "section-subtitle-colour": "#0a0a0a"
  },
  "modified": "2021-11-28T11:53:02Z",
  "sections": [
      {
          "type": "Headline",
          "title": "",
          "subtitle": "",
          "resources": [],
          "id": "B95A57DA-0520-4FEE-8E1F-97CAAFF94FFA",
          "index": 0
      }
  ],
  "version": "E4F47320-E494-465B-A7BD-1319C96014FA",
  "files": [
      {
          "resourceId": "FA36801C-2661-40F2-B768-2A3C62EF784D",
          "metadata": {},
          "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
          "ext": "jpg",
          "size": 17853,
          "mimeType": "image/jpg",
          "id": "90257B40-31B0-462F-8078-2ACD2A2EFFEF"
      },
      {
          "resourceId": "FA36801C-2661-40F2-B768-2A3C62EF784D",
          "metadata": {
              "filename": "Bee of Doom.jpg"
          },
          "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
          "ext": "jpg",
          "size": 2072,
          "mimeType": "image/jpeg",
          "id": "6F362757-F28B-42D4-8C90-3CA2F4E97326"
      },
      {
          "resourceId": "4868E62A-03E6-47EE-94B5-BF5A3DED5D12",
          "metadata": {
              "filename": "moo on zero.jpg"
          },
          "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
          "ext": "jpg",
          "size": 309244,
          "mimeType": "image/jpeg",
          "id": "AD8DA554-187E-48FF-B1DB-A0AC4B4E2B60"
      },
      {
          "resourceId": "4868E62A-03E6-47EE-94B5-BF5A3DED5D12",
          "metadata": {},
          "companyId": "65EA50BA-2C86-4FF0-8C0E-A1AFD104A86C",
          "ext": "jpg",
          "size": 370008,
          "mimeType": "image/jpg",
          "id": "00B03E10-F650-45F9-983E-CC6E6C89EFF1"
      }
  ]
}''';
