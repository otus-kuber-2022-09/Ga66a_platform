FROM quay.io/kubespray/kubespray:v2.20.0
COPY ./id_rsa /root/.ssh/id_rsa
COPY ./inventory/inventory.ini /inventory/
RUN chmod 400 /root/.ssh/id_rsa