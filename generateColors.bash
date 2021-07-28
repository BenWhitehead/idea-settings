#!/bin/bash
set -o errexit -o nounset -o pipefail

__SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

COLORS_DIR="${__SCRIPT_DIR}/config/colors"

function _genColorConfig() { (
  local pt=$1
  local newFile=${COLORS_DIR}/BenWhitehead_${pt}pt.icls
  msg "Generating new config $newFile..."
  cp ${COLORS_DIR}/BenWhitehead.icls ${newFile}
  sed -i "s/BenWhitehead/BenWhitehead_${pt}pt/g" ${newFile}
  sed -i "s/\"12\"/\"${pt}\"/g" ${newFile}
  msg "Generating new config $newFile complete"
) }

function main() { (

  sizes=(
    14
    16
    18
    22
    24
  )

  for size in ${sizes[@]}; do
    _genColorConfig $size
  done
) }

function now { date +"%Y-%m-%d %H:%M:%S" | tr -d '\n' ;}
function msg { println "$(now) $*" >&2 ;}
function err { local x=$? ; msg "$*" ; return $(( $x == 0 ? 1 : $x )) ;}
function println { printf '%s\n' "$*" ;}
function print { printf '%s ' "$(now) $*" ;}

if [[ ${1:-} ]] && declare -F | cut -d' ' -f3 | fgrep -qx -- "${1:-}"
then "$@"
else main "$@"
fi

