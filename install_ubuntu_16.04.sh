#!/usr/bin/env bash
ROOT=$(pwd)
INSTALLDIR=/usr/local
# run this script from within the directory you want to install PSOPT
sudo apt -y install g++ gfortran f2c libf2c2-dev libblas-dev libopenblas-dev libatlas-base-dev liblapack-dev cmake
# get Ipopt
wget http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.6.tgz
tar xvf Ipopt-3.12.6.tgz
rm Ipopt-3.12.6.tgz
# download thirdparty libraries
cd Ipopt-3.12.6/ThirdParty/Metis
./get.Metis
cd ../Mumps
./get.Mumps
cd ../../
# install Ipopt
./configure --enable-static coin_skip_warn_cxxflags=yes --prefix=$INSTALLDIR
make && sudo make install
# copy header files
cp Ipopt/src/* $INSTALLDIR/include/
# remove source file
cd ../
rm -rf Ipopt-3.12.6
# get ColPack
wget http://cscapes.cs.purdue.edu/download/ColPack/ColPack-1.0.9.tar.gz
tar xvf ColPack-1.0.9.tar.gz
rm ColPack-1.0.9.tar.gz
# configure ColPack
cd ColPack-1.0.9
./configure --prefix=$INSTALLDIR
# install
make && sudo make install
# remove source file
cd ../
rm -rf ColPack-1.0.9
# get ADOL-C
wget http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.6.2.tgz
tar xvf ADOL-C-2.6.2.tgz
rm ADOL-C-2.6.2.tgz
# configure ADOL-C
cd ADOL-C-2.6.2
./configure --enable-sparse --with-colpack=$INSTALLDIR --prefix=$INSTALLDIR
# install
make && sudo make install
# remove source file
cd ../
rm -rf ADOL-C-2.6.2
# get PDFlib-Lite
wget http://www.pdflib.com/binaries/PDFlib/705/PDFlib-Lite-7.0.5p3.tar.gz
tar xvf PDFlib-Lite-7.0.5p3.tar.gz
rm PDFlib-Lite-7.0.5p3.tar.gz
# configure PDFlib-Lite
cd PDFlib-Lite-7.0.5p3
./configure --prefix=$INSTALLDIR
# install
make && sudo make install
# remove source file
cd ../
rm -rf PDFlib-Lite-7.0.5p3
# get gnuplot
wget http://sourceforge.net/projects/gnuplot/files/gnuplot/4.2.2/gnuplot-4.2.2.tar.gz/download
mv download gnuplot.tar.gz
tar xvf gnuplot.tar.gz
rm gnuplot.tar.gz
# install dependencies
sudo apt install libx11-dev libxt-dev libgd2-xpm-dev libreadline6-dev
# configure gnuplot-4.2.2
cd gnuplot-4.2.2
./configure -with-readline=gnu -without-tutorial --prefix=$INSTALLDIR
# install
make && sudo make install
# remove source code
cd ../ &&
rm -rf gnuplot-4.2.2
# update linker cache
sudo ldconfig
# get PSOPT
wget https://github.com/PSOPT/psopt/archive/master.zip &&
unzip master.zip &&
mv psopt-master psopt &&
rm master.zip
# use modified Makefile
cp Makefile.psopt psopt/Makefile
cp Makefile.psopt.dmatrix.lib psopt/dmatrix/lib/Makefile
cp Makefile.psopt.dmatrix.examples psopt/dmatrix/examples/Makefile
cp Makefile.psopt.PSOPT.lib psopt/PSOPT/lib/Makefile
cp Makefile_linux.inc.psopt.PSOPT.examples psopt/PSOPT/examples/Makefile_linux.inc
# make all
cd psopt
make all target USERNAME=$ROOT prefix=$INSTALLDIR
