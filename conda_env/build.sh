# Conda build
#
# https://docs.anaconda.com/anaconda-cloud/user-guide/tasks/work-with-packages/#using-package-managers
# 1. Make sure to have channels in place
#    conda config --add channels bioconda
#    conda config --add channels conda-forge
#    conda config --add channels anaconda
#    conda config --add channels r
# 2. Install cget globally
#    sudo pip3 install cget
# 3. Build default (R=3.6.1)
#    conda build . -c r -c anaconda -c conda-forge -c bioconda -c defaults
# 4. Build with additional R version
#    conda build -R 3.5.1 . -c r -c anaconda -c conda-forge -c bioconda -c defaults
# 5. Test local installation
#    conda install --use-local r-saige

set -o errexit -o pipefail

export FLAGPATH=$(which python | sed 's|/bin/python$||')
export LDFLAGS="${LDFLAGS} -L${FLAGPATH}/lib"
export CPPFLAGS="${CPPFLAGS} -I${FLAGPATH}/include"
export TAR="$(which tar)"

echo "Building MetaSKAT"
(echo 'install.packages("MetaSKAT", repos = "https://cloud.r-project.org/")'; echo '1';) | $R --vanilla

echo "Building SPAtest"
echo 'devtools::install_github("leeshawn/SPAtest")' | $R --vanilla

echo "Building SAIGE"
# https://www.rdocumentation.org/packages/devtools/versions/1.13.6/topics/install_github
(echo 'devtools::install_github("weizhouUMICH/SAIGE", ref = "'${PKG_VERSION}'", dependencies = FALSE, upgrade_dependencies = FALSE)'; echo '3';) | $R --vanilla

# git clone --depth 1 -b SAIGE_homN_hetN_surv https://github.com/weizhouUMICH/SAIGE ${PREFIX}/lib/SAIGE
# (cd ${PREFIX}/lib/SAIGE; bash ./configure)
# (cd ${PREFIX}/lib/SAIGE; $R CMD INSTALL SAIGE)
