grids:
    # grid name, I just recommends to add the min resolution because it's common to not generate all the layers at the same resolution.
    swissgrid_005:
        # resolutions [required]
        resolutions: [1000, 500, 250, 100, 50, 20, 10, 5, 2, 1, 0.5, 0.25, 0.1, 0.05]
        # bbox [required]
        bbox: [420000, 30000, 900000, 350000]
        # srs [required]
        srs: EPSG:21781

caches:
    s3:
        type: s3
        bucket: camptocamp-gmf-demo-tiles
        folder: ''
        # for GetCapabilities
        http_url: '${web_protocol}://${host}${entry_point}'
        wmtscapabilities_file: ${wmtscapabilities_path}
        cache_control: 'public, max-age=14400'

# this defines some defaults values for all the layers
defaults:
    layer: &layer
        type: wms
        grid: swissgrid_005
        # The minimum resolution to seed, useful to use with mapcache, optional.
        min_resolution_seed: 5
        # the URL of the WMS server to used
        url: ${mapserver_url}
        # Set the headers to get the right virtual host, and don't get any cached result
        headers:
            Host: '${host}'
            Cache-Control: no-cache, no-store
            Pragma: no-cache
        # file name extension
        extension: png
        # the bbox there we want to generate tiles
        bbox: [473743, 74095, 850904, 325533]

        # mime type used for the WMS request and the WMTS capabilities generation
        mime_type: image/png
        wmts_style: default
        # the WMTS dimensions definition [default to []]
        #dimensions:
        #    -   name: DATE
        #        # the default value for the WMTS capabilities
        #        default: 2012
        #        # the generated value
        #        value: 2012
        #        # all the available values in the WMTS capabilities
        #        values: [2012]
        # the meta tiles definition [default to off]
        meta: on
        # the meta tiles size [default to 8]
        meta_size: 5
        # the meta tiles buffer [default to 128]
        meta_buffer: 128

layers:
    map:
        <<: *layer
        layers: default
        # connexion an sql to get geometries (in column named geom) where we want to generate tiles
        # Warn: too complex result can slow down the application
#    connection: user=www-data password=www-data dbname=<db> host=localhost
#    geoms:
#        -   sql: <column> AS geom FROM <table>
        # size and hash used to detect empty tiles and metatiles [optional, default to None]
        empty_metatile_detection:
            size: 740
            hash: 3237839c217b51b8a9644d596982f342f8041546
        empty_tile_detection:
            size: 921
            hash: 1e3da153be87a493c4c71198366485f290cad43c
    map_jpeg:
        <<: *layer
        layers: default
        extension: jpeg
        mime_type: image/jpeg
        empty_metatile_detection:
            size: 66163
            hash: a9d16a1794586ef92129a2fb41a739451ed09914
        empty_tile_detection:
            size: 1651
            hash: 2892fea0a474228f5d66a534b0b5231d923696da

generation:
    default_cache: s3

    # maximum allowed consecutive errors, after it exit [default to 10]
    maxconsecutive_errors: 10

sqs:
    # The region where the SQS queue is
    region: eu-west-1
    # The SQS queue name, it should already exists
    queue: '${tilegeneration_sqs_queue}'

server:
    mapcache_base: '${mapcache_url}'
    wmts_path: tiles
    static_path: static_tiles
    expires: 8  # 8 hours

mapcache:
    config_file: mapcache/mapcache.xml.tmpl
    location: ''
    memcache_host: '${memcached_host}'
    memcache_port: '${memcached_port}'

process:
    optipng_test:
    -   cmd: optipng -o7 -simulate %(in)s
    optipng:
    -   cmd: optipng %(args)s -q -zc9 -zm8 -zs3 -f5 %(in)s
        arg:
            default: '-q'
            quiet: '-q'
    jpegoptim:
    -   cmd: jpegoptim %(args)s --strip-all --all-normal -m 90 %(in)s
        arg:
            default: '-q'
            quiet: '-q'

openlayers:
    # srs, center_x, center_y [required]
    srs: EPSG:21781
    center_x: 600000
    center_y: 200000

metadata:
    title: Some title
    abstract: Some abstract
    servicetype: OGC WMTS
    keywords:
    - some
    - keywords
    fees: None
    access_constraints: None

provider:
    name: The provider name
    url: The provider URL
    contact:
        name: The contact name
        position: The position name
        info:
            phone:
                voice: +41 11 222 33 44
                fax: +41 11 222 33 44
            address:
                delivery: Address delivery
                city: Berne
                area: BE
                postal_code: 3000
                country: Switzerland
                email: info@example.com
