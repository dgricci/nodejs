# nodejs environment
FROM dgricci/jessie:0.0.4
LABEL       version="1.0.0" \
            node="v8.11.3" \
            yarn="v1.9.2" \
            gulpCli="v2.0.1" \
            os="Debian Jessie" \
            description="Node (v8.11.3) with Yarn (v8.11.3) and Gulp-Cli (v2.0.1) on Debian Jessie"

MAINTAINER  Didier Richard <didier.richard@ign.fr>

# Cf. https://github.com/nodejs/docker-node
ARG NPM_CONFIG_LOGLEVEL
ENV NPM_CONFIG_LOGLEVEL ${NPM_CONFIG_LOGLEVEL:-info}
ARG NODE_VERSION
ENV NODE_VERSION ${NODE_VERSION:-8.11.3}
ARG YARN_VERSION
ENV YARN_VERSION ${YARN_VERSION:-1.9.2}

# volume for user's projects
VOLUME /src

COPY build.sh /tmp/build.sh
RUN /tmp/build.sh && rm -f /tmp/build.sh

# Externally accessible data is by default put in /src
# use -v at run time !
WORKDIR /src

# Output capabilities by default.
CMD yarn versions && gulp --version

