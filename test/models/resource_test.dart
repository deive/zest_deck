import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/models/resource.dart';

void main() {
  test('Resource parsing from example call', () {
    final resourceJson = json.decode(exampleResponse);
    final resource = Resource.fromJson(resourceJson);

    expect(resource.name, "Bee of Doom");
    expect(resource.id, UuidValue("82E5A188-382B-441A-AB5F-C8F1D0BA5EF6"));
    expect(resource.modified, DateTime.utc(2021, 11, 29, 16, 41, 43));
    expect(resource.files.length, 4);
    expect(resource.files[ResourceFileType.thumbnail]?.length, 1);
    expect(resource.files[ResourceFileType.thumbnail]!.first,
        UuidValue("B1A56E82-0459-4327-98EA-8705419DD518"));
  });
}

const String exampleResponse = '''{
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
                }''';
