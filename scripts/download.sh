#!/usr/bin/env bash
# Download the test assets of elodie into dist/ and verify their checksums.
#
# All files are camera raw samples from https://raw.pixls.us/ released under
# CC0 1.0 (public domain). Keep this list in sync with manifest.json.
#
# Usage: scripts/download.sh [output directory, default: dist]

set -euo pipefail

OUTPUT_DIR="${1:-build}"

# name|sha256|source url
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
)

mkdir -p "$OUTPUT_DIR"
failed=0

for asset in "${ASSETS[@]}"; do
  IFS='|' read -r name sha256 url <<< "$asset"
  path="$OUTPUT_DIR/$name"

  if [ -f "$path" ] && echo "$sha256  $path" | sha256sum --check --status; then
    echo "ok        $name (already downloaded)"
    continue
  fi

  # Download to a temporary file so an interrupted download is never kept
  if ! curl --fail --silent --show-error --location --retry 3 --output "$path.part" "$url"; then
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
