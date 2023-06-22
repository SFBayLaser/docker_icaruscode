#
# Dockerfile for building image for icaruscode
#
FROM sfbaylaser/slf7-essentials:latest
#FROM slf7-essentials:latest
LABEL Maintainer: Tracy Usher

#RUN git --version

# Set the versions for code
ENV sbncode_version='v09_75_01_01'
ENV icaruscode_version='v09_75_01_01'
#ENV icarusalg='v09_75_01'
#ENV icarusutil='v09_75_00'
#ENV icarus_signal_processing='v09_75_00'

# Start by downloading the full necessary code stack
RUN mkdir icarus && mkdir icarus/products

COPY setup icarus/products/.
COPY larcv2.tar.bz2 icarus/

RUN  cd icarus && \
  tar -xvf larcv2.tar.bz2 -C products/ && \
  wget http://scisoft.fnal.gov/scisoft/bundles/tools/pullProducts && \
  chmod +x pullProducts && \
  ./pullProducts products/ slf7 sbn-${sbncode_version} e20 prof && \
  rm *tar.bz2 && \
  ./pullProducts products/ slf7 icarus-${icaruscode_version} e20 prof && \
  rm *tar.bz2 && \
  wget https://scisoft.fnal.gov/scisoft/packages/icarus_data/v09_71_00/icarus_data-09.71.00-noarch.tar.bz2 && \
  tar -xf icarus_data*.tar.bz2 -C products/ && \
  rm *tar.bz2 && \
  wget https://scisoft.fnal.gov/scisoft/packages/castxml/v0_4_2/castxml-0.4.2-sl7-x86_64.tar.bz2 && \
  tar -xvf castxml*.tar.bz2 -C products/ && \
  wget https://scisoft.fnal.gov/scisoft/packages/srproxy/v00_42/srproxy-00.42-noarch-py3913.tar.bz2 && \
  tar -xvf srproxy*.tar.bz2 -C products/ && \
  wget https://scisoft.fnal.gov/scisoft/packages/sbndata/v01_04/sbndata-01.04-noarch.tar.bz2 && \
  tar -xvf sbndata*.tar.bz2 -C products/ && \
  wget https://scisoft.fnal.gov/scisoft/packages/larbatch/v01_58_00/larbatch-01.58.00-noarch.tar.bz2 && \
  tar -xvf larbatch-01.58.00-noarch.tar.bz2 -C products/ && \
  rm *tar.bz2

# Install PyQt5 and PyQtGraph
# NOTE: replacing the line python -m pip install PyQt5==5.11.3 pyqtgraph==0.11.0 
RUN cd / && source icarus/products/setup && \
  setup icaruscode ${icaruscode_version} -q e20:prof && \
  pip install --upgrade pip && \
  python -m pip install PyQt5 pyqtgraph && \
  pip install uproot awkward pandas matplotlib \
              plotly jupyterlab scipy pywavelets
