#!/bin/bash
set -e

cd /

# Railway volumes hide files baked directly into /models. Seed the default image
# model on every fresh or empty volume while preserving user edits.
models_path="${LOCALAI_MODELS_PATH:-${MODELS_PATH:-/models}}"
mkdir -p "$models_path"
if [ ! -f "$models_path/sd15-cpu.yaml" ] && [ -f /opt/localai/railway/sd15-cpu.yaml ]; then
	install -m 0644 /opt/localai/railway/sd15-cpu.yaml "$models_path/sd15-cpu.yaml"
fi

# If we have set EXTRA_BACKENDS, then we need to prepare the backends
if [ -n "$EXTRA_BACKENDS" ]; then
	echo "EXTRA_BACKENDS: $EXTRA_BACKENDS"
	# Space separated list of backends
	for backend in $EXTRA_BACKENDS; do
		echo "Preparing backend: $backend"
		make -C $backend
	done
fi

echo "CPU info:"
grep -e "model\sname" /proc/cpuinfo | head -1
grep -e "flags" /proc/cpuinfo | head -1
if grep -q -e "\savx\s" /proc/cpuinfo ; then
	echo "CPU:    AVX    found OK"
else
	echo "CPU: no AVX    found"
fi
if grep -q -e "\savx2\s" /proc/cpuinfo ; then
	echo "CPU:    AVX2   found OK"
else
	echo "CPU: no AVX2   found"
fi
if grep -q -e "\savx512" /proc/cpuinfo ; then
	echo "CPU:    AVX512 found OK"
else
	echo "CPU: no AVX512 found"
fi

exec ./local-ai "$@"
