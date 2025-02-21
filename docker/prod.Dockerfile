ARG PYTHON_VERSION=3.11-slim-bullseye

FROM python:${PYTHON_VERSION} as base

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1


# ---
FROM base as builder

ARG BUILD_ENVIRONMENT=production

ENV PATH /venv/bin:$PATH

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential libjpeg-dev zlib1g-dev libpq-dev

# use pipenv to manage virtualenv
RUN python -m venv /venv
RUN pip install pipenv

COPY Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy


# ---
FROM base as runtime

ARG BUILD_ENVIRONMENT=production
ARG APP_HOME=/app

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV BUILD_ENV ${BUILD_ENVIRONMENT}

ENV PATH /venv/bin:$PATH

WORKDIR ${APP_HOME}

RUN apt-get update && apt-get install --no-install-recommends -y \
  libpq-dev gettext wget gnupg chromium \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

# copy in Python environment
COPY --from=builder /venv /venv

COPY --chmod=0755 ./scripts/*.sh ./

COPY . ${APP_HOME}

EXPOSE 9000
