import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_deck/app/models/resource.dart';

void main() {
  test('Resource parsing from example call', () {
    final resourceJson = json.decode(exampleResponse);
    final resource = Resource.fromJson(resourceJson);

    expect(resource.name, "Bee of Doom");
    expect(resource.id, UuidValue("FA36801C-2661-40F2-B768-2A3C62EF784D"));
    expect(resource.modified, DateTime.utc(2021, 11, 28, 11, 52, 09));
    expect(resource.files.length, 4);
    expect(resource.files[ResourceFileType.thumbnail]?.length, 1);
    expect(resource.files[ResourceFileType.thumbnail]!.first,
        UuidValue("90257B40-31B0-462F-8078-2ACD2A2EFFEF"));
  });
}

const String exampleResponse = '''{
  "stage": "Complete",
  "mime": "image/jpeg",
  "version": "CEB00139-C070-4169-AC7A-AB6B6A563942",
  "properties": [],
  "name": "Bee of Doom",
  "description": "",
  "metadata": {
      "processor_output": "collected new task",
      "storage_size": "35681",
      "exif_mime_type": "image/jpeg",
      "exif_jfif_version": "1.01",
      "exif_image_width": "96",
      "exif_color_components": "3",
      "exif_x_resolution": "1",
      "exif_resolution_unit": "None",
      "exif_file_name": "6f362757-f28b-42d4-8c90-3ca2f4e97326.jpg",
      "exif_directory": ".",
      "exif_image_height": "92",
      "exif_bits_per_sample": "8",
      "exif_file_inode_change_date/time": "2021:11:28 11:52:10+00:00",
      "exif_file_type": "JPEG",
      "exif_exiftool_version_number": "11.88",
      "exif_image_size": "96x92",
      "exif_file_modification_date/time": "2021:11:28 11:52:10+00:00",
      "exif_file_size": "2.0 kB",
      "exif_encoding_process": "Baseline DCT, Huffman coding",
      "exif_y_cb_cr_sub_sampling": "YCbCr4:2:0 (2 2)",
      "exif_file_access_date/time": "2021:11:28 11:52:10+00:00",
      "exif_file_type_extension": "jpg",
      "exif_y_resolution": "1",
      "exif_megapixels": "0.009",
      "exif_file_permissions": "rw-r--r--"
  },
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
  "modified": "2021-11-28T11:52:09Z",
  "type": "image",
  "path": [],
  "id": "FA36801C-2661-40F2-B768-2A3C62EF784D",
  "filename": "Bee of Doom.jpg",
  "tags": []
}''';
