% Environnement NodeJS
% Didier Richard
% rév. 0.0.1 du 11/11/2016

---

# Building #

```bash
$ docker build -t dgricci/nodejs:0.0.1 -t dgricci/nodejs:latest .
```

## Behind a proxy (e.g. 10.0.1.2:3128) ##

```bash
$ docker build \
    --build-arg http_proxy=http://10.0.1.2:3128/ \
    --build-arg https_proxy=http://10.0.1.2:3128/ \
    -t dgricci/nodejs:0.0.1 -t dgricci/nodejs:latest .
```

## Build command with arguments default values ##

```bash
$ docker build \
    --build-arg NPM_CONFIG_LOGLEVEL=info \
    --build-arg NODE_VERSION=7.0.0 \
    -t dgricci/nodejs:0.0.1 -t dgricci/nodejs:latest .
```

# Use #

See `dgricci/jessie` README for handling permissions with dockers volumes.

```bash
$ docker run -it --rm dgricci/nodejs nodejs --version
v7.0.0
```

__Et voilà !__


_fin du document[^pandoc_gen]_

[^pandoc_gen]: document généré via $ `pandoc -V fontsize=10pt -V geometry:"top=2cm, bottom=2cm, left=1cm, right=1cm" -s -N --toc -o nodejs.pdf README.md`{.bash}

