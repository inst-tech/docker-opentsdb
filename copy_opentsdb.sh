#!/bin/bash
test -n "$OPENTSDB_ROOT" || {
  echo >&2 'The environment variable OPENTSDB_ROOT must be set to the location where you built OpenTSDB'
  exit 1
}

test -d "$OPENTSDB_ROOT" || {
  echo >&2 "No such directory: OPENTSDB_ROOT=$OPENTSDB_ROOT"
  exit 1
}
cp $OPENTSDB_ROOT/src/mygnuplot.sh opentsdb/lib/mygnuplot.sh
cp -R $OPENTSDB_ROOT/build/third_party opentsdb/lib/
cp -R $OPENTSDB_ROOT/build/staticroot opentsdb/
cp $OPENTSDB_ROOT/build/tsdb-*.jar opentsdb/lib/
