# diplom-app


DOCKER_BUILDKIT=1 docker build --ssh github=/home/maxn/.ssh/id_ed25519 -t cr.yandex/crpis219qro17q8kksal/nginxapp:test .

cat ../kube-admin.json | docker login  --username json_key --password-stdin cr.yandex

docker build . -t cr.yandex/crpis219qro17q8kksal/nginxapp:test

