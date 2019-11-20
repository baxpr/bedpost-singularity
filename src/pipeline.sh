#!/bin/bash

# Initialize bedpost defaults (will be changed later if specified 
# with --bedpost_params)
bedpost_params="--nf=3 --fudge=1 --bi=1000"

# Parse options
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --project)
        project="$2"
        shift; shift
        ;;
    --subject)
        subject="$2"
        shift; shift
        ;;
    --session)
        session="$2"
        shift; shift
        ;;
    --scan)
        scan="$2"
        shift; shift
        ;;
    --preprocessed_dir)
        preprocessed_dir="$2"
        shift; shift
        ;;
    --restore_dir)
        restore_dir="$2"
        shift; shift
        ;;
	--bedpost_params)
		bedpost_params="$2"
		shift; shift
		;;
    --outdir)
        outdir="$2"
        shift; shift
        ;;
    *)
        shift
        ;;
  esac
done

# Inputs report
echo "${project} ${subject} ${session} ${scan}"
echo "PREPROCESSED:   $preprocessed_dir"
echo "RESTORE:        $restore_dir"
echo "bedpost params: $bedpost_params"
echo "outdir:         $outdir"

# Set up bedpost working directory (fsl "subject directory") and copy/rename inputs
mkdir -p "${outdir}"/bedpostx
cp ${preprocessed_dir}/dwmri.nii.gz "${outdir}"/bedpostx/data.nii.gz
cp ${preprocessed_dir}/mask.nii.gz "${outdir}"/bedpostx/nodif_brain_mask.nii.gz
cp ${preprocessed_dir}/dwmri.bval "${outdir}"/bedpostx/bvals
cp ${preprocessed_dir}/dwmri.bvec "${outdir}"/bedpostx/bvecs

# Run bedpost
bedpostx "${outdir}"/bedpostx ${bedpost_params}

# Make PDF
make_pdf.sh \
  --info_string "${project} ${subject} ${session} ${scan}" \
  --restore_dir "${restore_dir}" \
  --outdir "${outdir}"


