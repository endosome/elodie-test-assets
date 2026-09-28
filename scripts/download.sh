#!/usr/bin/env bash
# Collect the test assets of elodie into build/ and verify their checksums.
#
# Files are either downloaded from their source (i.e. camera raw samples from
# https://raw.pixls.us/) or stored in this repository under files/ (i.e.
# samples contributed to this repository which have no other source). All are
# released under CC0 1.0 (public domain). Keep this list in sync with
# manifest.json.
#
# Usage: scripts/download.sh [output directory, default: build]

set -euo pipefail

OUTPUT_DIR="${1:-build}"
REPOSITORY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# name|sha256|source: a URL, or a path in this repository (files/<name>)
ASSETS=(
  # gh-507: raw files which Pillow cannot read
  "raw-nikon-z-f.nef|98d6ca8e6c98048ca7ffed68ccaeda7b2b9f03807f0d320d97d5678db21748c2|https://raw.pixls.us/getfile.php/6887/nice/Nikon%20-%20Z%20f%20-%208bit%208bit%20lossy%20compressed%20(3:2).NEF"
  "raw-leica-m10-r.dng|ba35d25d521c7ddbc4feca69c8cdbe071ac65dcd6cf2c93374391bf6f3662b8d|https://raw.pixls.us/getfile.php/7853/nice/Leica%20-%20M10-R%20-%2016bit%20compressed%20(3:2).DNG"
  # One sample for each raw format elodie supports
  "raw-sony-dslr-a100.arw|4df7981ac4baec9648b4f106751ea4b09a6e27bc70a15f8ef09bec051fec362d|https://raw.pixls.us/getfile.php/2346/nice/Sony%20-%20DSLR-A100%20-%20compressed%20(3:2).ARW"
  "raw-canon-eos-1d-mark-ii-n.cr2|8bf6591f64b0657bc6133cbd0ee1418ef8e6dd3dd595827f8e9910c0f235843c|https://raw.pixls.us/getfile.php/1781/nice/Canon%20-%20EOS-1D%20Mark%20II%20N%20-%20RAW%20(3:2).CR2"
  "raw-leica-m9.dng|914f27df1ab095446c5db058703719f4a3749adedbfb9f353a3e85fa4f8f9b58|https://raw.pixls.us/getfile.php/752/nice/Leica%20-%20M9%20Digital%20Camera%20-%2016bit.DNG"
  "raw-nikon-d3.nef|880c60c5f611adf6b70de3d099f8433492de3a3d96866d570122f17f0a651fc8|https://raw.pixls.us/getfile.php/3516/nice/Nikon%20-%20D3%20-%2012bit%2012bit%20compressed%20(Lossy%20(type%202))%20(3:2).NEF"
  "raw-panasonic-dmc-lx7.rw2|d142a23aca836053ed53e9ce3cb3ed2d434541d734d71a94a6eefadcd08bd31b|https://raw.pixls.us/getfile.php/7008/nice/Panasonic%20-%20DMC-LX7%20-%201:1.RW2"
  # v2: raw formats of more camera makers
  "raw-canon-eos-r6.cr3|74abb0a113d075ad9887a058082f40dd2a938c4813a08474d82356f11a027778|https://raw.pixls.us/getfile.php/4659/nice/Canon%20-%20EOS%20R6%20-%203:2.CR3"
  "raw-nikon-coolpix-p1000.nrw|1d9470ee083f914e51aa0be782161b432f27f87dbef551a59ec435f5dbc289dd|https://raw.pixls.us/getfile.php/3381/nice/Nikon%20-%20COOLPIX%20P1000%20-%2012bit%2012bit%20uncompressed%20(4:3).NRW"
  "raw-fujifilm-x-s10.raf|9419d1408ebf850395e5dd563beb96309466546252caf541466034c9cb7e9724|https://raw.pixls.us/getfile.php/4190/nice/Fujifilm%20-%20X-S10%20-%2014bit%2014bit%20compressed%20(3:2).RAF"
  "raw-olympus-e-m1markii.orf|0b433019e5fa61548d7eb0eb7bb90894251542c056da72355202382696d0ceb8|https://raw.pixls.us/getfile.php/1993/nice/Olympus%20-%20E-M1MarkII%20-%2016bit%20(4:3).ORF"
  "raw-pentax-k10d.pef|e35ae4154a468be3154f5f462e884ba5941f010d3e8f23d347fbec14809f44d3|https://raw.pixls.us/getfile.php/2239/nice/Pentax%20-%20K10D%20-%2012bit%2012bit%20compressed%20(3:2).PEF"
  "raw-samsung-nx500.srw|156e43118811bcecb6fcc600b5f41ee1773c4f00b6a5b2dd72e177e35f6596ab|https://raw.pixls.us/getfile.php/3668/nice/Samsung%20-%20NX500%20-%2012bit%2012bit%20normal%20compression%20(3:2).SRW"
  "raw-panasonic-dmc-fz8.raw|a11f1534f3092a4d5f2b57d182f6b06f8d26cf766eb463c3e02b26a338b63b8b|https://raw.pixls.us/getfile.php/2282/nice/Panasonic%20-%20DMC-FZ8%20-%204:3.RAW"
  "raw-phase-one-p40plus.iiq|61aa32c5947d386f0d5ee465c5183185df6c9cd7ff7eb66ffec12e84b487878c|https://raw.pixls.us/getfile.php/8010/nice/Phase%20One%20-%20P40+%20-%20IIQ%20S%20(4:3).IIQ"
  "raw-sigma-dp1.x3f|44508f7df4191aacaecb6461e1841dae002e5b71a4f95a00aa3f52d1c6d6bc5f|https://raw.pixls.us/getfile.php/1116/nice/Sigma%20-%20DP1%20-%203:2.X3F"
  "raw-epson-r-d1.erf|09d8e533d93116294a9f3e161ed868e929454c7b946e083b644bd6bb75bcb5e4|https://raw.pixls.us/getfile.php/2680/nice/Epson%20-%20R-D1%20-%2012bit%20(3:2).ERF"
  "raw-minolta-dimage-5.mrw|d60bfd80bcb1f7b9c88b14a5e46ea27885bbf92d990ab30b3939288678fea0d9|https://raw.pixls.us/getfile.php/7795/nice/Minolta%20-%20DiMAGE%205%20-%204:3.MRW"
  # v3: Apple Live Photo, Google and Samsung Motion Photos, stored in this repository
  "live-photo-apple-iphone-15.heic|7db0c63e7e04fcff26b9af6a4f039f8a35cb58fe288d99b147448e5862c06e73|files/live-photo-apple-iphone-15.heic"
  "live-photo-apple-iphone-15.mov|7602b94a3de6f0aa1723c940145c57a426616aae3afcea4df4cccb025375df9e|files/live-photo-apple-iphone-15.mov"
  "motion-photo-google-pixel-9-pro-xl-ultra-hdr.jpg|ac0d8ac4560aa2137316678058c6723aa8a72d009475f0aa1fff87cb7dd8a4e7|files/motion-photo-google-pixel-9-pro-xl-ultra-hdr.jpg"
  "motion-photo-samsung-galaxy-a34-mpv2.jpg|8b4de80def81867630fe0f28c3051053ff0b76b7249f91b9d515a2e67ba04a8a|files/motion-photo-samsung-galaxy-a34-mpv2.jpg"
  "motion-photo-samsung-galaxy-s20-versionless.heic|f2dbe60e0402479f3c0d4246f30756fc73a416cdd9c64509c9767b070e22660e|files/motion-photo-samsung-galaxy-s20-versionless.heic"
  "motion-photo-samsung-galaxy-s20fe-mpv2.heif|3b9da515a1ddf66910397c7f9165e254b8022fc82b0d0436bfc91952c26e7baf|files/motion-photo-samsung-galaxy-s20fe-mpv2.heif"
  "motion-photo-samsung-galaxy-s20fe-mpv2.jpg|8676244eb21226043f4af46336e028e537a4f64895600c178efc5592dd2b547e|files/motion-photo-samsung-galaxy-s20fe-mpv2.jpg"
  "motion-photo-samsung-galaxy-s23-ultra-mpv3.heic|0f6afcca1755df94834b9ec93b0622b2eb027d17b1a981b232603a63b4ffb2cb|files/motion-photo-samsung-galaxy-s23-ultra-mpv3.heic"
  "motion-photo-samsung-galaxy-tab-s9-mpv3.heic|23e9f77624a870e2f70c31b68b6986893345fd805eb319bfe26114fbe4e461b3|files/motion-photo-samsung-galaxy-tab-s9-mpv3.heic"
  "motion-photo-samsung-galaxy-tab-s9-mpv3.jpg|3304d46313fbb39ab002ac04882e1198b5f148f5028abf58e938d5c0b5413cb1|files/motion-photo-samsung-galaxy-tab-s9-mpv3.jpg"
)

mkdir -p "$OUTPUT_DIR"
failed=0

for asset in "${ASSETS[@]}"; do
  IFS='|' read -r name sha256 url <<< "$asset"
  path="$OUTPUT_DIR/$name"

  if [ -f "$path" ] && echo "$sha256  $path" | sha256sum --check --status; then
    echo "ok        $name (already in place)"
    continue
  fi

  if [[ "$url" == files/* ]]; then
    # Stored in this repository
    if ! cp "$REPOSITORY_DIR/$url" "$path.part" 2>/dev/null; then
      echo "FAILED    $name: $url not found" >&2
      rm -f "$path.part"
      failed=1
      continue
    fi
  # Download to a temporary file so an interrupted download is never kept
  elif ! curl --fail --silent --show-error --location --retry 3 --output "$path.part" "$url"; then
    echo "FAILED    $name: download error" >&2
    rm -f "$path.part"
    failed=1
    continue
  fi

  if echo "$sha256  $path.part" | sha256sum --check --status; then
    mv "$path.part" "$path"
    echo "ok        $name ($(stat -c %s "$path") bytes)"
  else
    echo "FAILED    $name: sha256 does not match" >&2
    rm -f "$path.part"
    failed=1
  fi
done

exit "$failed"
