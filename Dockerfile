FROM python:3.13-alpine

RUN apk add --no-cache bash && \
    pip install yamllint

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
