import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/models/resource.dart';

void main() {
  test('Resource parsing from example call', () {
    final resourceJson = json.decode(exampleResponse);
    final resource = Resource.fromJson(resourceJson);

    expect(resource.name, "Bee of Doom");
    expect(resource.id, UuidValue("2E22D7B3-57F6-40C2-A386-C654D5886C11"));
    expect(resource.modified, DateTime.utc(2021, 12, 1, 19, 52, 15));
    expect(resource.files.length, 4);
    expect(resource.files[ResourceFileType.thumbnail]?.length, 1);
    expect(resource.files[ResourceFileType.thumbnail]!.first,
        UuidValue("62D6A900-5059-49E4-A450-881B10842DDC"));
  });
}

const String exampleResponse = '''{
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
                }''';
