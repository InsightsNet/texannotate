from texcompile.client import compile_pdf
import docker
import os
from sys import platform
import socket
from contextlib import closing


def find_free_port() -> int:  #https://stackoverflow.com/questions/1365265/on-localhost-how-do-i-pick-a-free-port-number
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as s:
        s.bind(('', 0))
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        return s.getsockname()[1]    


#check docker image
client = docker.from_env()
try:
    client.images.get('tex-compilation-service:latest')
except docker.errors.ImageNotFound:
    client.images.build(path='texcompile/service', tag='tex-compilation-service')

port = find_free_port()
if platform == "linux" or platform == "linux2":
    container = client.containers.run(
        image='tex-compilation-service',
        detach=True,
        ports={'80/tcp':port},
        tmpfs={'/tmpfs':''},
        remove=True,
    )
elif platform == "darwin":
    container = client.containers.run(
        image='tex-compilation-service',
        detach=True,
        ports={'80/tcp':port},
        #tmpfs={'/tmpfs':''},
        remove=True,
    )

result = compile_pdf(
  sources_dir='arxiv/2303.10142',
  output_dir='outputs/2303.10142',
)

with open("test.log", 'w') as file:
    file.write(result.log)

print(port)
print(container.logs())

container.stop()