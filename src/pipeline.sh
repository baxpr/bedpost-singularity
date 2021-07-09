#!/bin/bash

# Initialize defaults
export label_info="UNKNOWN SCAN"
export bedpost_params="-n 3 --model=1 -b 1000 -w 1"

# Parse options
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --label_info)
        export label_info="$2"; shift; shift ;;
    --dwi_niigz)
        export dwi_niigz="$2"; shift; shift ;;
    --bval_txt)
        export bval_txt="$2"; shift; shift ;;
    --bvec_txt)
        export bvec_txt="$2"; shift; shift ;;
    --mask_niigz)
        export mask_niigz="$2"; shift; shift ;;
    --fa_niigz)
        export fa_niigz="$2"; shift; shift ;;
    --v1_niigz)
        export v1_niigz="$2"; shift; shift ;;
    --tensor_niigz)
        export tensor_niigz="$2"; shift; shift ;;
    --bedpost_params)
        export bedpost_params="$2"; shift; shift ;;
    --outdir)
        export outdir="$2"; shift; shift ;;
    *)
        echo "Unknown input ${1}"
        shift ;;
  esac
done

# Inputs report
echo "${label_info}"
echo "dwi_niigz:      $dwi_niigz"
echo "bvec_txt:       $bvec_txt"
echo "bval_txt:       $bval_txt"
echo "mask_niigz:     $mask_niigz"
echo "fa_niigz:       $fa_niigz"
echo "v1_niigz:       $v1_niigz"
echo "tensor_niigz:   $tensor_niigz"
echo "bedpost params: $bedpost_params"
echo "outdir:         $outdir"

# Set up bedpost working directory (fsl "subject directory") and copy/rename inputs
mkdir -p "${outdir}"/bedpostx
cp "${dwi_niigz}" "${outdir}"/bedpostx/data.nii.gz
cp "${mask_niigz}" "${outdir}"/bedpostx/nodif_brain_mask.nii.gz
cp "${bval_txt}" "${outdir}"/bedpostx/bvals
cp "${bvec_txt}" "${outdir}"/bedpostx/bvecs

# Run bedpost
bedpostx "${outdir}"/bedpostx ${bedpost_params}
export bedpost_dir="${outdir}"/bedpostx.bedpostX

# Make PDF
make_pdf.sh

