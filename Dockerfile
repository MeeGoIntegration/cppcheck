FROM ubuntu:24.04

ARG UID=1000 GID=1000

RUN apt-get update && apt-get install -y sudo build-essential cmake git pip

RUN groupadd --gid "$GID" user && useradd --create-home --uid "$UID" --gid user user

COPY ./ /work/cppcheck/

WORKDIR /work/cppcheck/build
RUN cmake .. && cmake --build . -j$(nproc)

RUN cmake --install .

WORKDIR /work/cppcheck/htmlreport
RUN pip install --break-system-packages .

WORKDIR /
RUN rm -rf /work

USER user

CMD tail -f /dev/null
