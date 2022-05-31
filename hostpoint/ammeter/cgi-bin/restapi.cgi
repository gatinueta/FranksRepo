#!/usr/local/bin/python
from wsgiref.handlers import CGIHandler
from restapi import app

CGIHandler().run(app)

