FROM ubuntu

RUN apt-get -y update \
 && apt-get -y install gnupg curl wget zip unzip bzip2 python-pip git vim nano cmake libsm6 libxext6 libgtk2.0-dev locales

ENV APP_NAME abot
ENV APP_HOME /app
RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

ENV CONDA_HOME /etc/miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && sh Miniconda3-latest-Linux-x86_64.sh -b -p ${CONDA_HOME} \
 && rm -rf Miniconda3-latest-Linux-x86_64.sh \
 && ln -sf ${CONDA_HOME}/bin/conda /usr/bin/conda \
 && echo ". ${CONDA_HOME}/etc/profile.d/conda.sh" >> ~/.bashrc

RUN conda create -y --name ${APP_NAME} python=3.8

ADD requirements.txt requirements.txt
RUN bash -c "source ${CONDA_HOME}/bin/activate ${APP_NAME} \
 && pip install -r requirements.txt "

RUN locale-gen C.UTF-8 pt_br.UTF-8 en_US.UTF-8
RUN chmod 0755 /etc/default/locale
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8

RUN echo export LC_ALL=C.UTF-8 >> ~/.bashrc
RUN echo export LANG=C.UTF-8 >> ~/.bashrc
RUN echo export LANGUAGE=C.UTF-8 >> ~/.bashrc

ADD conf.xml ${APP_HOME}
ADD setup.py ${APP_HOME}

RUN mkdir -p ${APP_HOME}/abot
ADD abot ${APP_HOME}/abot

RUN mkdir -p ${APP_HOME}/config
ADD config ${APP_HOME}/config

RUN mkdir -p ${APP_HOME}/data
ADD data ${APP_HOME}/data

RUN mkdir -p ${APP_HOME}/models
ADD models ${APP_HOME}/models


RUN mkdir -p ${APP_HOME}/resources
ADD resources ${APP_HOME}/resources


RUN bash -c "source ${CONDA_HOME}/bin/activate ${APP_NAME} \
 && pip install . "
