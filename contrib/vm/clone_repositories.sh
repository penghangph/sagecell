#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

# We need git that creates relative links for submodules:
# 1.8.5 is OK, 1.7.9 isn't.

mkdir --mode=0700 github
cd github

git clone https://github.com/novoselt/sage.git
pushd sage
git checkout sagecell
git submodule update --init --recursive

./sage -sh <<"EOF"
standard=`sage -standard`
for pkg in build/pkgs/*
do
    if [ -d $pkg ]; then
        pkg=`basename $pkg`
        if echo $standard | grep -q $pkg
        then
            sage-spkg -f -d $pkg
        fi
    fi
done
EOF
popd

git clone https://github.com/jasongrout/ipython.git
pushd ipython
git checkout sagecell
git submodule update --init --recursive
popd

git clone https://github.com/jasongrout/matplotlib
pushd matplotlib
git checkout sagecell
git submodule update --init --recursive
popd

git clone https://github.com/sagemath/sagecell.git
pushd sagecell
git submodule update --init --recursive
popd

cd ..
BASEMAP=basemap-1.0.7
wget --progress=dot:mega http://downloads.sourceforge.net/project/matplotlib/matplotlib-toolkits/$BASEMAP/$BASEMAP.tar.gz

