[DEFAULT]
script_location = /opt/alembic

sqlalchemy.url = ${sqlalchemy["url"]}
version_table = c2cgeoportal_version
srid = 21781

[main]
version_table_schema = ${schema}
schema = ${schema}
version_locations = /opt/alembic/main/

[static]
version_table_schema = ${schema}_static
main_schema = ${schema}
static_schema = ${schema}_static
version_locations = /opt/alembic/static/

# Logging configuration
[loggers]
keys = root,sqlalchemy,alembic

[handlers]
keys = console

[formatters]
keys = generic

[logger_root]
level = WARN
handlers = console
qualname =

[logger_sqlalchemy]
level = WARN
handlers =
qualname = sqlalchemy.engine

[logger_alembic]
level = INFO
handlers =
qualname = alembic

[handler_console]
class = StreamHandler
args = (sys.stderr,)
level = NOTSET
formatter = generic

[formatter_generic]
format = %(levelname)-5.5s [%(name)s] %(message)s
datefmt = %H:%M:%S
