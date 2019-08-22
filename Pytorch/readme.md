# Pytorch

## Docker

> 컨테이너 기반의 가상화 시스템

- 한 컴퓨터에서 독립전 운영체제를 갖게 쪼개는데는 문제가 있음
- 리눅스 커널 하나로 합치기 위한 오픈소스 기술
- 독립적인 운영체제를 여러개 띄울 필요 없이 리눅스 커널기반에 Docker만 띄우면 여러 환경을 구축해 사용할 수 있음

- 윈도우에서 도커 사용하면 리눅스 커널이 아니기때문에 성능이 좀 떨어지고 GPU를 사용할 수 없음

## Pytorch Basic Tensor Manipulation

- Vector(1차원), Matrix(2차원), Tensor(3차원)
- 2D Tensor(Typicla Simple Setting)
  - |t| = (batch size, dim)

- 3D Tensor
  - |t| = (batch size, width, height)
  - |t| = (batch size, length, dim)

