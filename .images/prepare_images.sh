#!/bin/sh

image="${1}"

[ -z "${image}" ] && { echo >&2 "prepare_images.sh image"; exit 1; }
[ -f "${image}" ] || { echo >&2 "prepare_images.sh: File \"${image}\" does not exist"; exit 1; }

current_image=$(basename "${image}")

[ -f "${current_image}" ] || { echo >&2 "prepare_images.sh: File must exist in current directory"; exit 1; }

set -x

convert -flatten "${image}" -scale '85%' "out_${image}" || exit 1
mv "out_${image}" "${image}" || exit 1

convert "${image}" -scale '85%' "out_${image}" || exit 1
mv "out_${image}" "${image}" || exit 1
