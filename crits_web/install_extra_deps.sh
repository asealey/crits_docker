#!/bin/bash
# Installs additional libraries which seem to be missed in crits_dependencies

# ushlex
ushlexVer=0.98
curl -SL https://pypi.python.org/packages/source/u/ushlex/ushlex-$ushlexVer.tar.gz | tar -zxvC /tmp/
pushd /tmp/ushlex-$ushlexVer
python setup.py install
popd

# PIL
pilVer=1.1.7
curl -SL http://effbot.org/downloads/Imaging-$pilVer.tar.gz | tar -zxvC /tmp/
python /tmp/Imaging-$pilVer/setup.py install
