# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0


# TODO: pin digest — resolution failed
FROM python:3.12-slim-bookworm AS base

FROM base AS builder
RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends g++ \
    && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt .
RUN pip install --prefix="/reqs" -r requirements.txt

FROM base
WORKDIR /usr/src/app/
COPY --from=builder /reqs /usr/local
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers
RUN playwright install --with-deps chromium

# Drop to non-root user for runtime
RUN groupadd --system --gid 1001 appgroup && \
    useradd --system --uid 1001 --gid appgroup --no-create-home appuser && \
    chown -R appuser:appgroup /usr/src/app
USER appuser

COPY ./locustfile.py .
COPY ./people.json .
ENTRYPOINT ["locust", "--skip-log-setup"]
