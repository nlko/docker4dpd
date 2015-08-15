FROM generic_node 

RUN apt-get update \
&& apt-get install -y python make g++ libavahi-compat-libdnssd-dev --no-install-recommends \
&& apt-get purge -y --auto-remove 

ENV APP_DIR /usr/src/app

WORKDIR /usr/src/app

ENV DPD_VERSION 0.8.5
ENV USER nonroot
ENV HOME /usr/local/$USER

RUN /usr/sbin/useradd --create-home --home-dir $HOME --shell /bin/bash $USER

RUN chown -R $USER $APP_DIR
RUN chgrp -R root $APP_DIR
RUN chmod 775 $APP_DIR

RUN npm install -g deployd@$DPD_VERSION \
&& npm cache clear 

EXPOSE 3000
EXPOSE 2403

USER nonroot

ADD start_dpd.sh /usr/bin/ 
