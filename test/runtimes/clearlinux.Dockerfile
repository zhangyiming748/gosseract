FROM clearlinux:latest

RUN swupd update
RUN swupd bundle-add \
    go-basic

RUN swupd bundle-add \
    devpkg-tesseract \
    devpkg-leptonica

# {{{ TODO: Do not use wget.
#     This part should be replaced by curl,
#     which is installed by default.
RUN swupd bundle-add wget
RUN wget \
        -O eng.traineddata \
        https://github.com/tesseract-ocr/tessdata/blob/main/eng.traineddata?raw=true \
    && mv eng.traineddata /usr/share/tessdata
# }}}

RUN mkdir -p ${GOPATH}/src/github.com/otiai10
ADD . ${GOPATH}/src/github.com/otiai10/gosseract
WORKDIR ${GOPATH}/src/github.com/otiai10/gosseract

CMD ["go", "test", "-v", "./..."]