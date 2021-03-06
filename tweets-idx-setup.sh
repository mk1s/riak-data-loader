#!/usr/bin/env bash

function echoerr
{
  echo "$@" 1>&2
}

if [[ ! -s twitter-schema.xml ]]
then
  echoerr 'Required file twitter-schema.xml not found, exiting!'
  exit 1
fi

curl -XPUT -iH 'Content-Type: application/xml' 'http://localhost:8098/search/schema/tweets-sch' --data-binary @twitter-schema.xml

curl -XPUT -iH 'Content-Type: application/json' http://localhost:8098/search/index/tweets-idx -d '{"schema":"tweets-sch"}'

riak-admin bucket-type create tweets-type '{"props":{"search_index":"tweets-idx"}}'
riak-admin bucket-type activate tweets-type

# curl -iH 'Content-Type: application/json' -XPUT 'http://localhost:8098/types/tweets-type/props' --data-binary @tweets-bucket-type.json
