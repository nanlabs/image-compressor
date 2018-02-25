FROM acleancoder/imagemagick-full
MAINTAINER r+d@nan-labs.com
ADD ./bin/compress-dir.sh /usr/bin/compress-dir.sh
RUN chmod +x /usr/bin/compress-dir.sh
VOLUME /source /target /backup
CMD ["/usr/bin/compress-dir.sh"]

