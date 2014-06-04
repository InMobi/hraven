#!/bin/bash
#
# Copyright 2013 Twitter, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Run on the daemon node per specific cluster
# This script runs on the HBase cluster
# Usage ./jobFileProcessor.sh [hadoopconfdir]
#   [schedulerpoolname] [historyprocessingdir] [cluster] [threads] [batchsize] [machinetype] [costfile]
# a sample cost file can be found in the conf dir as sampleCostDetails.properties

if [ $# -ne 10 ]
then
  echo "Usage: `basename $0` [hbaseconfdir] [schedulerpoolname] [historyprocessingdir] [cluster] [threads] [batchsize] [machinetype] [sinks] [costfilehdfspath] [taskhistoryprocessing]"
  exit 1
fi

home=$(dirname $0)
source $home/../../conf/hraven-env.sh
source $home/pidfiles.sh
myscriptname=$(basename "$0" .sh)
export LIBJARS=`find $home/../../lib/ -name 'hraven-core*.jar'`,$(ls $home/../../lib/guava-*.jar)
hravenEtlJar=`find $home/../../lib/ -name 'hraven-etl*.jar'`
stopfile=$HRAVEN_PID_DIR/$myscriptname.stop
export HADOOP_CLASSPATH=$(ls $home/../../lib/commons-lang-*.jar):`find $home/../../lib/ -name 'hraven-core*.jar'`:`hbase classpath`:$(ls $home/../../lib/guava-*.jar)

if [ -f $stopfile ]; then
  echo "Error: not allowed to run. Remove $stopfile continue." 1>&2
  exit 1
fi

create_pidfile $HRAVEN_PID_DIR
trap 'cleanup_pidfile_and_exit $HRAVEN_PID_DIR' INT TERM EXIT

hadoop --config $1 jar $hravenEtlJar com.twitter.hraven.etl.JobFileProcessor -libjars=$LIBJARS -Dmapred.fairscheduler.pool=$2 -d -p $3 -c $4 -t $5 -b $6 -m $7 -s $8 -zf $9 -tt $10

