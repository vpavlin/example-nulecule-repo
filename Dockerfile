FROM fedora:22

ADD . /opt/hello

RUN chmod +x /opt/hello/run.py

CMD /opt/hello/run.py
