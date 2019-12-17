#!/usr/bin/env bash
#
# This script configures eddy based on the current system (cuda found or not)
#
# Call with -f <FSLDIR path>, e.g. /usr/local/fsl (will use FSLDIR if given
# no arguments)

# Where is this script?
script_dir=$( cd $(dirname $0) ; pwd)

# Set some defaults
OPTIND=1
fsl_dir=""
quiet=0
dropprivileges=0

# Have we been called by sudo?
if [ ! -z "${SUDO_UID}" ]; then
    dropprivileges=1
fi    

function syntax {
    echo "configure_eddy.sh [-f <FSLDIR>] [-q]"
    echo "  -f <FSLDIR> Location of installed FSL, e.g. /usr/local/fsl"
    echo "                  if not provided looks for FSLDIR in environment"
    echo "  -q          Install quietly"
}

while getopts "h?qf:" opt; do
    case "${opt}" in
    h|\?)
        syntax
        exit 0
        ;;
    q)  quiet=1
        ;;
    f)  fsl_dir=${OPTARG}
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ -z "${fsl_dir}" ]; then
    if [ -z "${FSLDIR}" ]; then
        echo "Error - FSLDIR not given as an argument and \$FSLDIR not set!" >&2
        exit 1
    else
        fsl_dir=${FSLDIR}
    fi
fi

if [ ! -e "${fsl_dir}/bin" ]; then
    echo "Error - ${fsl_dir}/bin does not exist!" >&2
    exit 1
fi

if [ ! -w "${fsl_dir}" ]; then
    echo "Error - cannot write to ${fsl_dir}!" >&2
    exit 1
fi

if [ ! -w "${fsl_dir}/bin" ]; then
    echo "Error - cannot write to ${fsl_dir}/bin!" >&2
    exit 1
fi

if [ ! -e "${fsl_dir}/etc/fslversion" ]; then
    echo "${fsl_dir} doesn't look like an FSL installation folder!" >&2
    exit 1
fi

function drop_sudo {
    if [ ${dropprivileges} -eq 1 ]; then
        sudo -u \#${SUDO_UID} "$@"
        if [ $? -eq 1 ]; then
            sudo -u \#${SUDO_UID} -g \#${SUDO_GID} "$@"
        fi
    else
        "$@"
    fi
}

#####################################
# Configure eddy
#####################################

# If Darwin (macOS) then no need to configure eddy_openmp or eddy_cuda
if [ "$platform" = "Darwin" ]; then
	echo "configure_eddy.sh: macOS detected. eddy configuration not required. Skipping now."
    exit 1
fi

# If Linux, run the following configuration steps:

# does eddy exist? If so, do not link eddy_openmp to eddy
if [ -f "${fsl_dir}/bin/eddy" ]; then
	echo "configure_eddy.sh: ${fsl_dir}/bin/eddy detected, NOT creating symlink to ${fsl_dir}/bin/eddy_openmp"
else # if not, check if eddy_openmp exists, then link to eddy
	echo "configure_eddy.sh: ${fsl_dir}/bin/eddy NOT detected. Checking for ${fsl_dir}/bin/eddy_openmp."
	if [ -f "${fsl_dir}/bin/eddy_openmp" ]; then
		echo "configure_eddy.sh: ${fsl_dir}/bin/eddy_openmp detected. Creating symlink to ${fsl_dir}/bin/eddy now."
		ln -sf ${fsl_dir}/bin/eddy_openmp ${fsl_dir}/bin/eddy
	fi
fi

# does eddy_cuda exist?
if [ -f "${fsl_dir}/bin/eddy_cuda" ]; then
	echo "configure_eddy.sh: ${fsl_dir}/bin/eddy_cuda detected. NOT creating symlink to specific eddy_cuda versions"
else
	# list installed fsl eddy_cuda versions (puts versions into array)
	echo "configure_eddy.sh: ${fsl_dir}/bin/eddy_cuda NOT detected. Checking for specific eddy_cudaX.X versions now."
	eddycudas=($(ls -d ${fsl_dir}/bin/eddy_cuda*))
	echo "configure_eddy.sh: found eddy_cuda versions... ${eddycudas[@]}"
	
	# List installed cuda versions in /opt/cuda* (put into array)
	echo "configure_eddy.sh: checking /opt/cuda* for installed cuda versions"
	optcudas=($(ls -d /opt/cuda*))
	echo "configure_eddy.sh: found cuda versions: ${optcudas[@]}"
	# loop through eddy_cuda versions found
	for eddycudaversionstring in "${eddycudas[@]}"
	do
		# parse full path string into parts separated by "/"
		IFS='/' read -a parts <<< $eddycudaversionstring
		# get the last part
		fslcudastring="${parts[-1]}"
		# parse again to get version string
		IFS='eddy_cuda' read -a verstring <<< $fslcudastring
		fslcudaver="${verstring[-1]}"
		
		for optcudaversionstring in "${optcudas[@]}"
		do
			# parse full path string into parts separated by "/"
			IFS='/' read -a parts <<< $optcudaversionstring
			# get the last part
			optcudastring="${parts[-1]}"
			# parse again to get version string
			IFS='-' read -a verstring <<< $optcudastring
			optcudaver="${verstring[-1]}"
			# if version strings are equal, we know that the user has version X available, so we can link to version X for eddy_cuda
			if [ "$fslcudaver" == "$optcudaver" ]; then
				echo "configure_eddy.sh: found matching cuda versions for eddy_cuda$fslcudaver and /opt/cuda-$optcudaver"
				echo "configure_eddy.sh: creating symlink from ${fsl_dir}/bin/eddy_cuda$fslcudaver to ${fsl_dir}/bin/eddy_cuda"
				echo "configure_eddy.sh: lower version numbers will be overwritten by higher versions"
				echo "configure_eddy.sh: to explicitly link eddy_cuda to a specific version, try: ln -sf ${fsl_dir}/bin/eddy_cudaX.X ${fsl_dir}/bin/eddy_cuda"
				ln -sf ${fsl_dir}/bin/eddy_cuda$fslcudaver ${fsl_dir}/bin/eddy_cuda
			fi
		done
	done
fi












