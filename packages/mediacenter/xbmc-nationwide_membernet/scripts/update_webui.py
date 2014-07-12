# -*- coding: utf-8 -*- 

import os
import sys

import json as simplejson

orig_file = open(sys.argv[1], "r").read()

json_query = unicode(orig_file, 'utf-8', errors='ignore')
json_query = simplejson.loads(json_query)

update = True
for js in json_query:
  if js == "url":
    for ass in json_query[js]:
      if ass == "feed":
        update = False

if update:
  json_query[u"url"] = {u"feed":"http://www.nationwidemember.com"}
  simplejson.dump(json_query, open(sys.argv[1],'w'))


