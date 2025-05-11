# Задание
*Цель*: научиться делать сборку с помощью пакетного менеджера Helm

### Задача

1. Сделать RESTful CRUD по созданию, удалению, просмотру и обновлению пользователей.
2. Добавить базу данных для приложения.
    - Конфигурация приложения должна хранится в Configmaps.
    - Доступы к БД должны храниться в Secrets.
3. Первоначальные миграции должны быть оформлены в качестве Job.
4. Ingress должны также вести на url arch.homework/.

#### На выходе должны быть предоставлена

- ссылка на директорию в github, где находится директория с манифестами кубернетеса
- инструкция по запуску приложения.
- команда установки БД из helm, вместе с файлом values.yaml.
- команда применения первоначальных миграций
- команда kubectl apply -f, которая запускает в правильном порядке манифесты кубернетеса
- Postman коллекция, в которой будут представлены примеры запросов к сервису на создание, получение, изменение и удаление пользователя.

------------

### Результат


------------
### Инструкция по запуску приложения

**Клонирум проект в локальный репозиторий**

 ```
 git clone https://github.com/Jony2Good/k8s-helm.git
```
- в корневой директории найти файл .env.example исправить его на .env

**Стартуем minikube**

```
minikube start
```
**Инициализируем манифесты***

СПРАВКА: *по причине наличия helm и особенностей работы Laravel приложения развертывание разбито на 3 ступени)*

1. Первый шаг
    - инициализируем namespace, configmap и secrets:
```
kubectl apply -f k8s/first-stage/
```

2. Второй шаг
    - инициализируем postgresql из helm:
```agsl
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install postgres bitnami/postgresql --namespace k8s-basics -f values.yaml
```

3. Третий шаг
    - завершаем развертывание:
```agsl
kubectl apply -f k8s/last-stage/
```

**Проверяем pods**
```
kubectl get pods -n k8s-basics
```
***Проверяем Ingress (его не будет, далее установим)***
```
kubectl get ingress -n k8s-basics
```
ПРЕЖДЕ ВСЕГО НУЖЕН РЕПОЗИТОРИЙ HELM (скачиваем)
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```
Устанавливаем ingress-controller в namespase k8s-basics
```
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace k8s-basics
```
Проверяем
```
kubectl get svc -n k8s-basics
```
Должна появится таблица. Нас интересует только ingress-nginx-controller. У него должен быть *Type:LoadBalanser* и *External-IP:pending*

| NAME                    | TYPE         | CLUSTER-IP     | EXTERNAL-IP    | PORT(S)                    | AGE |
| ----------------------- | ------------ | -------------- | -------------- | -------------------------- | --- |
| ngress-nginx-controller | LoadBalancer | 10.104.118.219 |  pending  | 80:31047/TCP,443:31617/TCP | 95m |

Нам необходимо, чтобы домен arch.homework открывался без порта и по специальному url. Для этого мы должны прописать команду:
```
minikube tunnel
```

Далее снова смотрим в таблицу на значение в колонке **EXTERNAL-IP** (вместо pending должно появится значение, к примеру, 10.107.105.245) в ней должен прописаться внешний IP-адрес.

Копируем данный внешний адрес и прописываем в файле hosts машины правило маршрутизации, где развернут кластер:

```
10.107.105.245 arch.homework
```
Справка: для ОС windows прописываем в файле и сохраняем:
```
C:\Windows\System32\drivers\etc\hosts
```
