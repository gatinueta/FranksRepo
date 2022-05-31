#!/usr/local/bin/python
from wsgiref.handlers import CGIHandler
from modhtml import app

CGIHandler().run(app)

