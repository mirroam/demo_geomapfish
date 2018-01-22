[app:app]
use = egg:demo_geoportal
pyramid.reload_templates = false
pyramid.debug_authorization = false
pyramid.debug_notfound = false
pyramid.debug_routematch = false
pyramid.debug_templates = false
mako.directories = demo_geoportal:templates
    c2cgeoportal_geoportal:templates
authtkt_secret = ${authtkt["secret"]}
authtkt_cookie_name = ${authtkt["cookie_name"]}
% if "timeout" in authtkt:
authtkt_timeout = ${authtkt["timeout"]}
% endif
app.cfg = %(here)s/config.yaml

c2c.base_path = /c2c

[pipeline:main]
pipeline =
    app

###
# logging configuration
# http://docs.pylonsproject.org/projects/pyramid/en/1.5-branch/narr/logging.html
###

[loggers]
keys = root, sqlalchemy, gunicorn.access, gunicorn.error, c2cgeoportal_commons, c2cgeoportal_geoportal, demo_commons, demo_geoportal

[handlers]
keys = console, logstash, json

[formatters]
keys = generic

[logger_root]
level = %(OTHER_LOG_LEVEL)s
handlers = console

[logger_c2cgeoportal_commons]
level = %(C2CGEOPORTAL_LOG_LEVEL)s
handlers =
qualname = c2cgeoportal_commons

[logger_c2cgeoportal_geoportal]
level = %(C2CGEOPORTAL_LOG_LEVEL)s
handlers =
qualname = c2cgeoportal_geoportal

[logger_demo_commons]
level = %(LOG_LEVEL)s
handlers =
qualname = demo_commons

[logger_demo_geoportal]
level = %(LOG_LEVEL)s
handlers =
qualname = demo_geoportal

[logger_gunicorn.access]
level = %(GUNICORN_ACCESS_LOG_LEVEL)s
handlers =
qualname = gunicorn.access

[logger_gunicorn.error]
level = %(GUNICORN_LOG_LEVEL)s
handlers =
qualname = gunicorn.error

[logger_sqlalchemy]
level = %(SQL_LOG_LEVEL)s
handlers =
qualname = sqlalchemy.engine
# "level = INFO" logs SQL queries.
# "level = DEBUG" logs SQL queries and results.
# "level = WARN" logs neither.  (Recommended for production systems.)

[handler_console]
class = StreamHandler
args = (sys.stderr,)
level = NOTSET
formatter = generic

[formatter_generic]
format = %(asctime)s %(levelname)-5.5s [%(name)s][%(thread)s] %(message)s

[handler_logstash]
class = c2cwsgiutils.pyramid_logging.PyramidCeeSysLogHandler
args = [("%(LOG_HOST)s", %(LOG_PORT)s)]
level = NOTSET

[handler_json]
class = c2cwsgiutils.pyramid_logging.JsonLogHandler
args = (sys.stdout,)
level = NOTSET
