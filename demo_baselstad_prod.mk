INSTANCE_ID = baselstad
ifdef VARS_FILE
VARS_FILES += ${VARS_FILE} vars_demo_basel.yaml
else
VARS_FILE = vars_demo_basel.yaml
VARS_FILES += ${VARS_FILE}
endif

APACHE_VHOST = geomapfish-demo

include CONST_Makefile
