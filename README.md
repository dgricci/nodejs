% Environnement NodeJS  
% Didier Richard  
% 29/07/2018

---

revision:
- 0.0.1 : 11/11/2016  
- 0.0.2 : 29/07/2018  
- 0.0.3 : 07/08/2018  

---

# Building #

```bash
$ docker build -t dgricci/nodejs:$(< VERSION) .
$ docker tag dgricci/nodejs:$(< VERSION) dgricci/nodejs:latest
```

## Behind a proxy (e.g. 10.0.4.2:3128) ##

```bash
$ docker build \
    --build-arg http_proxy=http://10.0.4.2:3128/ \
    --build-arg https_proxy=http://10.0.4.2:3128/ \
    -t dgricci/nodejs:$(< VERSION) .
$ docker tag dgricci/nodejs:$(< VERSION) dgricci/nodejs:latest
```

## Build command with arguments default values ##

```bash
$ docker build \
    --build-arg NPM_CONFIG_LOGLEVEL=info \
    --build-arg NODE_VERSION=8.11.3 \
    --build-arg YARN_VERSION=1.9.4 \
    --build-arg GULPCLI_VERSION=2.0.1 \
    -t dgricci/nodejs:$(< VERSION) .
$ docker tag dgricci/nodejs:$(< VERSION) dgricci/nodejs:latest
```

# Use #

See `dgricci/jessie` README for handling permissions with dockers volumes.

```bash
$ docker run --rm dgricci/nodejs:$(< VERSION)
v8.11.3
yarn versions v1.9.4
{ yarn: '1.9.4',
  http_parser: '2.8.0',
  node: '8.11.3',
  v8: '6.2.414.54',
  uv: '1.19.1',
  zlib: '1.2.11',
  ares: '1.10.1-DEV',
  modules: '57',
  nghttp2: '1.32.0',
  napi: '3',
  openssl: '1.0.2o',
  icu: '60.1',
  unicode: '10.0',
  cldr: '32.0',
  tz: '2017c' }
Done in 0.02s.
[13:58:23] CLI version 2.0.1
```

__Et voilà !__


_fin du document[^pandoc_gen]_

[^pandoc_gen]: document généré via $ `pandoc -V fontsize=10pt -V geometry:"top=2cm, bottom=2cm, left=1cm, right=1cm" -s -N --toc -o nodejs.pdf README.md`{.bash}

