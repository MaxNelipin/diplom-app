# diplom-app

## deployment.yaml
3 реплики разворачиваются в namespace = stage, доступ открывается через LoadBalancer
Нужный образ подставляется через переменную $nameImage

## Dockerfile
Разворачивается nginx и в дефолтный каталог в папку **1** копируется static.html
Шаг сборки контейнера с копированием статической страницы НЕ кэшируется

## Dockerfile_jenkinsagent
Кастомный образ агента Jenkins с добавленным kubectl, gettext-base(для envsubst), curl

## Jenkinsfile

- первый шаг: скачивание репозитория с dockerfile и получения тега последнего коммита
- Если нет тега - собираем и пушим образ в регистр с тегом равным id текущего коммита
- Если тег есть - собираем и пушим образ в регистр с тегом равным тегу текущего коммита, разворачиваем данный образ на кластер