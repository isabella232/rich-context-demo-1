FROM jupyter/scipy-notebook:45b8529a6bfc

# All clones have hash checkouts so we can bust the docker cache by changing them
# and so they are pinned.

RUN git clone --single-branch --branch databus https://github.com/jupyterlab/jupyterlab.git \
    && cd jupyterlab \
    && git checkout df4a56711290bb8715601179be7112252dbbe35f
RUN git clone https://github.com/jupyterlab/jupyterlab-metadata-service.git \
    && cd jupyterlab-metadata-service \
    && git checkout ee4e8e5f1228d2f73e5c4e431492a510036a40f8 \
    && cd backend \
    && pip install -e .
RUN git clone https://github.com/jupyterlab/jupyterlab-commenting.git \
    && cd jupyterlab-commenting \
    && git checkout 58e11b321a7341ef73a388b4dbc6807b2874f194

WORKDIR ./jupyterlab
RUN pip install -e .
RUN jlpm run add:sibling ../jupyterlab-metadata-service/frontend 
RUN jlpm run add:sibling ../jupyterlab-commenting
RUN jlpm build:dev
RUN jupyter lab build --dev
workdir /app
CMD jupyter lab --dev
