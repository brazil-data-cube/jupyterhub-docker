#!/bin/bash

set -eou pipefail

#
# Download (if needed) and install SNAP
#
cd /tmp

if [ ! -f /tmp/esa-snap_all_unix_${BDC_SNAP_VERSION}_0.sh ]; then

    wget -q \
        -O "/tmp/esa-snap_all_unix_${BDC_SNAP_VERSION}_0.sh" \
        "http://step.esa.int/downloads/${BDC_SNAP_VERSION}.0/installers/esa-snap_all_unix_${BDC_SNAP_VERSION}_0.sh"

    chmod +x esa-snap_all_unix_${BDC_SNAP_VERSION}_0.sh
fi

./esa-snap_all_unix_${BDC_SNAP_VERSION}_0.sh -q -varfile response.varfile


#
# Download Apache Maven
#
wget -q \
        -O "/tmp/apache-maven-3.8.1-bin.tar.gz" \
        "https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.1/apache-maven-3.8.1-bin.tar.gz"

cd /tmp && tar xzvf apache-maven-3.8.1-bin.tar.gz


#
# Clone and build jpy
# See: https://forum.step.esa.int/t/unable-to-install-snappy-jpy-problem/5372/15
#
git clone https://github.com/bcdev/jpy.git /tmp/jpy

cd /tmp/jpy

PATH=$PATH:/tmp/apache-maven-3.8.1/bin/ JAVA_HOME=/opt/snap/8.0/jre python setup.py bdist_wheel

mkdir -p /opt/snap/8.0/snap-python/snappy/


#
# Copy jpy wheels to snappy folder
#
cp dist/*.whl  /opt/snap/8.0/snap-python/snappy/


#
# Configure and build snappy
#
/opt/snap/${BDC_SNAP_VERSION}.0/bin/snappy-conf /opt/conda/envs/geospatial/bin/python /opt/snap/${BDC_SNAP_VERSION}.0/snap-python


#
# Install snappy into the conda environment
#
cd /opt/snap/${BDC_SNAP_VERSION}.0/snap-python/snappy

python setup.py install

#
# Update modules
#
/opt/snap/${BDC_SNAP_VERSION}.0/bin/snap --nosplash --nogui --modules --list --refresh

/opt/snap/${BDC_SNAP_VERSION}.0/bin/snap --nosplash --nogui --modules --update-all

#
# Remove non-necessary software and files
#
rm -rf /tmp/apache-maven-3.8.1

rm -rf /tmp/jpy

rm -rf /tmp/esa-snap_all_unix_${BDC_SNAP_VERSION}_0.sh

rm /tmp/response.varfile