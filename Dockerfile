FROM python:3.14-alpine

RUN apk add --no-cache bash && \
    pip install yamllint

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
