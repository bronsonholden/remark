# Remark

Digital chatter at human scale and human pace.

[App](https://remark.social)
[Blog](https://remark.social/blog)

## Setup

Install:

* Heroku CLI
* ImageMagick
* Docker
* FFMPEG

Run:

```
bundle install
```

Drop `development.key` into `config/credentials`

## Run locally

```
./bin/dev
```

Set env `SHRINE_FORCE_S3=1` to use S3 (and AWS Rekognition) in development mode
