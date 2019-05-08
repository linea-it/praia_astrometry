FROM python:3.7-alpine
MAINTAINER Glauber Costa Vila Verde <galuber.vila.verde@gmail.com>

ENV APP_PATH=/app
ENV DATA_DIR=/data
ENV PRAIA_HEADER=PRAIA_header_extraction_30_08
ENV PRAIA_ASTROMETRY=PRAIA_astrometry_30_06
ENV PRAIA_TARGET=PRAIA_targets_search_20_03


RUN apk --no-cache --update-cache add gfortran postgresql-dev subversion musl-dev
#RUN mkdir ${APP_PATH} 
RUN mkdir ${DATA_DIR}


RUN mkdir $APP_PATH

WORKDIR $APP_PATH

RUN pip install --upgrade pip && pip install \
    psycopg2-binary \
    SQLAlchemy \
    humanize \
    numpy \
    spiceypy

COPY src/ $APP_PATH/src

COPY run.py $APP_PATH
COPY praia_header.py $APP_PATH
COPY praia_astrometry.py $APP_PATH
COPY praia_target.py $APP_PATH

# Compile Praia Header Extraction
# COPY src/${PRAIA_HEADER}.f ${APP_PATH}
RUN gfortran src/${PRAIA_HEADER}.f -o /bin/${PRAIA_HEADER}

# Compile Praia Astrometry
# COPY src/${PRAIA_ASTROMETRY}.f ${APP_PATH}
RUN gfortran src/${PRAIA_ASTROMETRY}.f -o /bin/${PRAIA_ASTROMETRY}

# Compile Praia Target Search
# COPY src/${PRAIA_TARGET}.f ${APP_PATH}
RUN gfortran src/${PRAIA_TARGET}.f -o /bin/${PRAIA_TARGET}

# Clear 
# RUN rm ${APP_PATH}/*.f 

