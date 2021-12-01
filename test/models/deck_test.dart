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

    expect(deck.title, "doom");
    expect(deck.id, UuidValue("7B28AEF4-0DAF-48E2-BA15-06B1F3FAA0F5"));
    expect(deck.resources.length, 5);
    expect(deck.resources.first.id,
        UuidValue("2E22D7B3-57F6-40C2-A386-C654D5886C11"));
    expect(deck.resources.first.type, ResourceType.image);
    expect(deck.sections.length, 1);
    expect(deck.sections.first.id,
        UuidValue("A648D1CB-6599-40B5-A91E-E067B8A4BE69"));
    expect(deck.sections.first.type, SectionType.headline);
    expect(deck.sections.first.title, "Section 1 o' Doom");
  });
}

const String exampleResponse = '''{
            "id": "7B28AEF4-0DAF-48E2-BA15-06B1F3FAA0F5",
            "version": "1DA7BF17-E0B2-48DA-ABF9-415D5C377080",
            "thumbnail": "2E22D7B3-57F6-40C2-A386-C654D5886C11",
            "resources": [
                {
                    "mime": "image/jpeg",
                    "searchableText": {},
                    "description": "",
                    "tags": [],
                    "type": "image",
                    "path": [],
                    "modified": "2021-12-01T19:52:15Z",
                    "version": "50A9A89D-EC52-4CAD-98BF-6B0078978E53",
                    "metadata": {},
                    "name": "Bee of Doom",
                    "stage": "Complete",
                    "filename": "Bee of Doom.jpg",
                    "exif": {},
                    "files": {
                        "original": [
                            "435CA56C-2B81-43AD-8C89-638F1632B744"
                        ],
                        "thumbnail": [
                            "62D6A900-5059-49E4-A450-881B10842DDC"
                        ],
                        "content": [
                            "435CA56C-2B81-43AD-8C89-638F1632B744"
                        ],
                        "chosen_thumbnail": [
                            "62D6A900-5059-49E4-A450-881B10842DDC"
                        ]
                    },
                    "id": "2E22D7B3-57F6-40C2-A386-C654D5886C11",
                    "properties": []
                },
                {
                    "mime": "image/jpeg",
                    "searchableText": {},
                    "description": "",
                    "tags": [],
                    "type": "image",
                    "path": [],
                    "modified": "2021-12-01T19:52:17Z",
                    "version": "2BD2A9F5-966F-4E79-9592-375E0262953C",
                    "metadata": {},
                    "name": "moo on zero",
                    "stage": "Complete",
                    "filename": "moo on zero.jpg",
                    "exif": {},
                    "files": {
                        "content": [
                            "F3AA40D8-E241-4E87-9274-57AC412A6D4D"
                        ],
                        "chosen_thumbnail": [
                            "EA9EE360-FDB2-4D30-8921-BF0692DA47A1"
                        ],
                        "thumbnail": [
                            "EA9EE360-FDB2-4D30-8921-BF0692DA47A1"
                        ],
                        "original": [
                            "F3AA40D8-E241-4E87-9274-57AC412A6D4D"
                        ]
                    },
                    "id": "D8621E69-4935-4D13-856A-F9CDC3DA3D53",
                    "properties": []
                },
                {
                    "mime": "image/jpeg",
                    "searchableText": {},
                    "description": "",
                    "tags": [],
                    "type": "image",
                    "path": [],
                    "modified": "2021-12-01T19:52:15Z",
                    "version": "0F074EE2-A686-43AA-975B-DA23C8CE3D3C",
                    "metadata": {},
                    "name": "gir",
                    "stage": "Complete",
                    "filename": "gir.jpg",
                    "exif": {},
                    "files": {
                        "content": [
                            "33F31079-E583-432A-AF4E-F76920780140"
                        ],
                        "original": [
                            "33F31079-E583-432A-AF4E-F76920780140"
                        ],
                        "chosen_thumbnail": [
                            "A2246F79-DCD5-4EA0-9E1D-C09DB39A3834"
                        ],
                        "thumbnail": [
                            "A2246F79-DCD5-4EA0-9E1D-C09DB39A3834"
                        ]
                    },
                    "id": "E7BD329C-8900-49AD-845E-A1A5DE085CDA",
                    "properties": []
                },
                {
                    "name": "moo on bike",
                    "description": "",
                    "path": [],
                    "files": {
                        "original": [
                            "EF88FDD8-E83A-4773-B802-3CAA5E61A66B"
                        ],
                        "content": [
                            "EF88FDD8-E83A-4773-B802-3CAA5E61A66B"
                        ],
                        "chosen_thumbnail": [
                            "32271C55-9E6F-4D36-9D3D-1E6F492E1E88"
                        ],
                        "thumbnail": [
                            "32271C55-9E6F-4D36-9D3D-1E6F492E1E88"
                        ]
                    },
                    "filename": "moo on bike.jpg",
                    "id": "2DCF7AB2-2A42-4434-97F5-8F16FC846887",
                    "modified": "2021-12-01T19:52:19Z",
                    "metadata": {},
                    "exif": {},
                    "version": "74B35411-F779-441B-90AC-F1D3E332F0B6",
                    "stage": "Complete",
                    "type": "image",
                    "tags": [],
                    "searchableText": {},
                    "mime": "image/jpeg",
                    "properties": []
                },
                {
                    "name": "south park deive",
                    "description": "",
                    "path": [],
                    "files": {
                        "content": [
                            "EB6DA362-8E0D-4241-BE7D-5622B53E2E1D"
                        ],
                        "original": [
                            "EB6DA362-8E0D-4241-BE7D-5622B53E2E1D"
                        ],
                        "chosen_thumbnail": [
                            "D2E8F864-3B6C-4643-ACEE-11169CB5A2E0"
                        ],
                        "thumbnail": [
                            "D2E8F864-3B6C-4643-ACEE-11169CB5A2E0"
                        ]
                    },
                    "filename": "south park deive.png",
                    "id": "F95F7028-A9A7-4903-A216-46C94530DA67",
                    "modified": "2021-12-01T19:52:16Z",
                    "metadata": {},
                    "exif": {},
                    "version": "66E74507-C5DB-48BB-A154-63B030F7F2A2",
                    "stage": "Complete",
                    "type": "image",
                    "tags": [],
                    "searchableText": {},
                    "mime": "image/png",
                    "properties": []
                }
            ],
            "companyId": "EFCBDC5B-9000-4141-B429-D604A4969058",
            "modified": "2021-12-01T19:54:52Z",
            "sections": [
                {
                    "title": "Section 1 o' Doom",
                    "resources": [
                        "2DCF7AB2-2A42-4434-97F5-8F16FC846887",
                        "F95F7028-A9A7-4903-A216-46C94530DA67"
                    ],
                    "index": 0,
                    "id": "A648D1CB-6599-40B5-A91E-E067B8A4BE69",
                    "type": "Headline",
                    "subtitle": "Subtitle o' Doom"
                }
            ],
            "files": [
                {
                    "mimeType": "image/jpg",
                    "id": "62D6A900-5059-49E4-A450-881B10842DDC",
                    "metadata": {},
                    "ext": "jpg"
                },
                {
                    "mimeType": "image/jpeg",
                    "id": "435CA56C-2B81-43AD-8C89-638F1632B744",
                    "metadata": {
                        "filename": "Bee of Doom.jpg"
                    },
                    "ext": "jpg"
                },
                {
                    "mimeType": "image/jpg",
                    "id": "EA9EE360-FDB2-4D30-8921-BF0692DA47A1",
                    "metadata": {},
                    "ext": "jpg"
                },
                {
                    "mimeType": "image/jpeg",
                    "id": "F3AA40D8-E241-4E87-9274-57AC412A6D4D",
                    "metadata": {
                        "filename": "moo on zero.jpg"
                    },
                    "ext": "jpg"
                },
                {
                    "mimeType": "image/jpg",
                    "id": "A2246F79-DCD5-4EA0-9E1D-C09DB39A3834",
                    "metadata": {},
                    "ext": "jpg"
                },
                {
                    "mimeType": "image/jpeg",
                    "id": "33F31079-E583-432A-AF4E-F76920780140",
                    "metadata": {
                        "filename": "gir.jpg"
                    },
                    "ext": "jpg"
                },
                {
                    "mimeType": "image/jpeg",
                    "id": "EF88FDD8-E83A-4773-B802-3CAA5E61A66B",
                    "metadata": {
                        "filename": "moo on bike.jpg"
                    },
                    "ext": "jpg"
                },
                {
                    "mimeType": "image/jpg",
                    "id": "32271C55-9E6F-4D36-9D3D-1E6F492E1E88",
                    "metadata": {},
                    "ext": "jpg"
                },
                {
                    "mimeType": "image/png",
                    "id": "EB6DA362-8E0D-4241-BE7D-5622B53E2E1D",
                    "metadata": {
                        "filename": "south park deive.png"
                    },
                    "ext": "png"
                },
                {
                    "mimeType": "image/jpg",
                    "id": "D2E8F864-3B6C-4643-ACEE-11169CB5A2E0",
                    "metadata": {},
                    "ext": "jpg"
                }
            ],
            "thumbnailFile": "62D6A900-5059-49E4-A450-881B10842DDC",
            "subtitle": "new dck 'o doom.",
            "metadata": {
                "header-colour": "#ff9c33",
                "section-subtitle-colour": "#0a0a0a",
                "background-image": "d8621e69-4935-4d13-856a-f9cdc3da3d53",
                "header-text-colour": "#ffffff",
                "section-title-colour": "#000000",
                "logo-image": "e7bd329c-8900-49ad-845e-a1a5de085cda"
            },
            "title": "doom",
            "rank": 0
        }''';
