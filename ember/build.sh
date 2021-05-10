set +x

echo "Starting build.sh"
echo "vvvvvvvv BUILD ENVIRONMENT vvvvvvvvvvvvv"
env
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

echo "****************************"
echo "BUILD STARTED"
echo "****************************"

rm -f ember.conf

cp "${RECIPE_DIR}/../.ci_support/ember_base.conf" ember.conf

echo "python_cmd = '${PREFIX}/bin/python'" >> ember.conf
echo "include = '${PREFIX}/include'" >> ember.conf
echo "eigen = '${PREFIX}/include/eigen3'" >> ember.conf
echo "libdirs = '${PREFIX}/lib'" >> ember.conf
echo "link_flags = '${LDFLAGS}'" >> ember.conf

if [[ "${OSX_ARCH}" == "" ]]; then
    echo "CXX = '${CXX}'" >> ember.conf
    echo "blas_lapack = 'mkl_rt,dl'" >> ember.conf
else
    echo "CXX = '${CLANGXX}'" >> ember.conf
    echo "cxx_flags = '-isysroot ${CONDA_BUILD_SYSROOT} -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}'" >> ember.conf
fi

set -xe

${CONDA_PREFIX}/bin/scons build -j${CPU_COUNT}

set +xe

echo "****************************"
echo "BUILD COMPLETED SUCCESSFULLY"
echo "****************************"

${CONDA_PREFIX}/bin/scons install
