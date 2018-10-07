FROM python:3.6-slim

RUN apt-get update -y --fix-missing \
  && apt-get install -y \
    build-essential \
    curl \
    libgflags-dev \
    libsnappy-dev \
    zlib1g-dev \
    libbz2-dev \
    liblz4-dev


ENV LD_LIBRARY_PATH=/usr/local/lib \
  PORTABLE=1

RUN cd /tmp \
  && curl -sL rocksdb.tar.gz https://github.com/facebook/rocksdb/archive/v5.15.10.tar.gz > rocksdb.tar.gz \
  && tar fvxz rocksdb.tar.gz \
  && cd rocksdb-5.15.10 \
  && make shared_lib \
  && make install-shared

RUN pip install python-rocksdb

RUN apt-get remove -y \
  build-essential \
  curl \
  && rm -rf /tmp

CMD ["python", "-c", "import rocksdb"]
