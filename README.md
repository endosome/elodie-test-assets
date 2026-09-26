# elodie-test-assets

Sample files used by the test suite of [elodie](https://github.com/endosome/elodie).
They are too large for the elodie repository, so they are published as assets of
the [releases](https://github.com/endosome/elodie-test-assets/releases) of this
repository and downloaded by the tests when needed.

Small files which the tests can generate or which are only a few kilobytes stay
in the elodie repository (`elodie/tests/files`).

## Files

| File | Camera | Size | Pillow can read it | Used for |
|---|---|---|---|---|
| `raw-nikon-z-f.nef` | Nikon Z f | 12.8 MB | no | gh-507: newer raw files which Pillow cannot read |
| `raw-leica-m10-r.dng` | Leica M10-R | 52.3 MB | no | gh-507: DNG 1.4 (JPEG compressed) like the Leica M11-D |
| `raw-sony-dslr-a100.arw` | Sony DSLR-A100 | 9.7 MB | no | Sony ARW |
| `raw-canon-eos-1d-mark-ii-n.cr2` | Canon EOS-1D Mark II N | 10.0 MB | yes | Canon CR2 |
| `raw-leica-m9.dng` | Leica M9 | 34.7 MB | yes | DNG |
| `raw-nikon-d3.nef` | Nikon D3 | 8.5 MB | yes | Nikon NEF |
| `raw-panasonic-dmc-lx7.rw2` | Panasonic DMC-LX7 | 3.1 MB | no | Panasonic RW2 |

[`manifest.json`](manifest.json) lists each file with its sha256, size, capture
date (`date_time_original`), MIME type as reported by ExifTool, license and source.

## License

Only files which may be redistributed freely are accepted. All current files are
from [raw.pixls.us](https://raw.pixls.us/) and are released under
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) (public domain),
as is the rest of this repository (see [LICENSE](LICENSE)).

## Using the files

Download a file of a release:

```
https://github.com/endosome/elodie-test-assets/releases/download/<version>/<file name>
```

Pin the version and verify the sha256 from `manifest.json` after downloading.

## Publishing a release

Releases are never changed once published so that tests which pin a version
keep working. To add or replace files, publish a new version with all files.

1. Add the file to `scripts/download.sh` and to `manifest.json` (keep both in sync)
   and bump `version` in `manifest.json`.
2. Download and verify all files into `build/`:

   ```
   scripts/download.sh
   ```

3. Publish the release (requires the [GitHub CLI](https://cli.github.com/)):

   ```
   gh release create v1 build/* manifest.json \
     --repo endosome/elodie-test-assets \
     --title v1 \
     --notes "Test assets for elodie, see README.md"
   ```

Files larger than 2 GB cannot be published as release assets.
