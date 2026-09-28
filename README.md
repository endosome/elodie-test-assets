# elodie-test-assets

Sample files used by the test suite of [elodie](https://github.com/endosome/elodie).
They are too large for the elodie repository, so they are published as assets of
the [releases](https://github.com/endosome/elodie-test-assets/releases) of this
repository and downloaded by the tests when needed.

Small files which the tests can generate or which are only a few kilobytes stay
in the elodie repository (`elodie/tests/files`).

## Where the files come from

- **Downloaded:** files available elsewhere (i.e. the camera raw samples from
  raw.pixls.us) are downloaded from their source when a release is prepared.
- **Stored in this repository:** files without another source (i.e. photos
  contributed to this repository) are committed to [`files/`](files). Keep them
  small, GitHub rejects files larger than 100 MB.

Both kinds end up in the releases, which is where the tests get them from.

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
| `raw-canon-eos-r6.cr3` | Canon EOS R6 | 5.0 MB | – | CR3 (v2) |
| `raw-nikon-coolpix-p1000.nrw` | Nikon COOLPIX P1000 | 25.2 MB | – | NRW (v2) |
| `raw-fujifilm-x-s10.raf` | Fujifilm X-S10 | 17.8 MB | – | RAF (v2) |
| `raw-olympus-e-m1markii.orf` | Olympus E-M1MarkII | 16.5 MB | – | ORF (v2) |
| `raw-pentax-k10d.pef` | Pentax K10D | 9.1 MB | – | PEF (v2) |
| `raw-samsung-nx500.srw` | Samsung NX500 | 19.8 MB | – | SRW (v2) |
| `raw-panasonic-dmc-fz8.raw` | Panasonic DMC-FZ8 | 11.1 MB | – | RAW (v2) |
| `raw-phase-one-p40plus.iiq` | Phase One P40+ | 10.7 MB | – | IIQ (v2) |
| `raw-sigma-dp1.x3f` | Sigma DP1 | 9.8 MB | – | X3F (v2) |
| `raw-epson-r-d1.erf` | Epson R-D1 | 9.5 MB | – | ERF (v2) |
| `raw-minolta-dimage-5.mrw` | Minolta DiMAGE 5 | 6.1 MB | – | MRW (v2) |
| `live-photo-apple-iphone-15.heic` | Apple iPhone 15 | 4.9 MB | – | gh-474: Apple Live Photo, the photo (HEIC with an HDR gain map) (v3) |
| `live-photo-apple-iphone-15.mov` | Apple iPhone 15 | 3.7 MB | – | gh-474: Apple Live Photo, the video of live-photo-apple-iphone-15.heic (v3) |
| `motion-photo-google-pixel-9-pro-xl-ultra-hdr.jpg` | Google Pixel 9 Pro XL | 4.6 MB | – | Google Motion Photo with an Ultra HDR gain map (v3) |
| `motion-photo-samsung-galaxy-a34-mpv2.jpg` | Samsung Galaxy A34 5G | 7.3 MB | – | Samsung Motion Photo, JPEG, Google header and Samsung trailer v2 (v3) |
| `motion-photo-samsung-galaxy-s20-versionless.heic` | Samsung SM-G981U1 | 5.5 MB | – | Samsung Motion Photo, HEIC, only a Samsung trailer without version (v3) |
| `motion-photo-samsung-galaxy-s20fe-mpv2.heif` | Samsung SM-G781B | 3.2 MB | – | Samsung Motion Photo, HEIF, Google header and Samsung trailer v2 (v3) |
| `motion-photo-samsung-galaxy-s20fe-mpv2.jpg` | Samsung SM-G780F | 5.2 MB | – | Samsung Motion Photo, JPEG, Google header and Samsung trailer v2 (v3) |
| `motion-photo-samsung-galaxy-s23-ultra-mpv3.heic` | Samsung Galaxy S23 Ultra | 5.1 MB | – | Samsung Motion Photo, HEIC, Google header and Samsung trailer v3 (v3) |
| `motion-photo-samsung-galaxy-tab-s9-mpv3.heic` | Samsung Galaxy Tab S9 5G | 7.1 MB | – | Samsung Motion Photo, HEIC, Google header and Samsung trailer v3 (v3) |
| `motion-photo-samsung-galaxy-tab-s9-mpv3.jpg` | Samsung Galaxy Tab S9 5G | 7.3 MB | – | Samsung Motion Photo, JPEG, Google header and Samsung trailer v3 (v3) |

[`manifest.json`](manifest.json) lists each file with its sha256, size, capture
date (`date_time_original`), MIME type as reported by ExifTool, license and source.

## License

Only files which may be redistributed freely are accepted. All files are released
under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) (public
domain), as is the rest of this repository (see [LICENSE](LICENSE)). The files
from [raw.pixls.us](https://raw.pixls.us/) are CC0 there, files contributed to
`files/` are released under CC0 by their author. Check contributed photos for
personal information in their metadata (i.e. GPS, serial numbers, owner names)
before adding them.

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
   and bump `version` in `manifest.json`. For a downloaded file, its source is
   the URL. For a file stored in this repository, commit it to `files/` and use
   `files/<name>` as its source.
2. Download, copy and verify all files into `build/`:

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
