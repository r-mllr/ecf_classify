FROM python:3.6-alpine as python
RUN apk update
RUN apk add --no-cache make automake gcc g++ subversion python3-dev

RUN mkdir /install
WORKDIR /install
COPY requirements.txt /requirements.txt

RUN pip3 install --install-option="--prefix=/install" -r /requirements.txt

FROM alpine:3.9 as builder

WORKDIR /src/
RUN apk add --no-cache gcc musl-dev make
RUN wget http://eddylab.org/software/hmmer/hmmer.tar.gz && tar zxf hmmer.tar.gz && cd hmmer-3.2.1 && ./configure --prefix /src/ && make -j && make install

# This file is a template, and might need editing before it works on your project.
FROM ruby:2.6-alpine as ruby

# Edit with nodejs, mysql-client, postgresql-client, sqlite3, etc. for your needs.
# Or delete entirely if not needed.
#RUN apk --no-cache add nodejs postgresql-client tzdata

RUN apk add --no-cache --virtual build-deps build-base && \
  apk add --no-cache git python3 && \
  apk del build-deps

WORKDIR /usr/src/app


RUN gem install bundler

COPY .git .git
COPY . .
RUN bundle install --without development test && rake -f Rakefile.prod install

FROM ruby:2.6-alpine

RUN apk add --no-cache --virtual build-deps build-base && \
  apk add --no-cache python3 bash && \
  apk del build-deps

COPY --from=ruby /usr/local/bundle /usr/local/bundle
COPY --from=builder /src/bin/hmmscan /usr/bin/
COPY --from=python /install/lib/python3.6/ /usr/local/lib/python3.6/



ENV PYTHONPATH=${PYTHONPATH}:/usr/local/lib/python3.6/site-packages/:/usr/local/lib/python3.6/

# Install build dependencies - required for gems with native dependencies

WORKDIR /

CMD ["ecf_classify", "help"]
