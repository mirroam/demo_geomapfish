FROM camptocamp/geomapfish_build:jenkins
LABEL maintainer Camptocamp "info@camptocamp.com"

COPY . /app/
RUN pip install --no-cache-dir --editable /app/

EXPOSE 80

CMD ["/app/c2cwsgiutils_run"]
