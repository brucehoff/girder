FROM node:12-buster
LABEL maintainer="Kitware, Inc. <kitware@kitware.com>"

EXPOSE 8080

RUN mkdir /girder

RUN apt-get update && apt-get install -qy \
    gcc \
    libpython3-dev \
    git \
    libldap2-dev \
    libsasl2-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py

WORKDIR /girder
COPY . /girder/

# See http://click.pocoo.org/5/python3/#python-3-surrogate-handling for more detail on
# why this is necessary.
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN pip install --upgrade --upgrade-strategy eager --editable .

ARG plugins
RUN for plugin in $plugins; do pip install --upgrade --upgrade-strategy eager --editable ./plugins/$plugin; done

RUN girder build

ENTRYPOINT ["girder", "serve"]
