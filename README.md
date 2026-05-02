# Домашнее задание к занятию «GitLab» - Дорохов В.А.

---
### Задание 1

**Что нужно сделать:**

1. Разверните GitLab локально, используя Vagrantfile и инструкцию, описанные в [этом репозитории](https://github.com/netology-code/sdvps-materials/tree/main/gitlab).   
2. Создайте новый проект и пустой репозиторий в нём.
3. Зарегистрируйте gitlab-runner для этого проекта и запустите его в режиме Docker. Раннер можно регистрировать и запускать на той же виртуальной машине, на которой запущен GitLab.

В качестве ответа в репозиторий шаблона с решением добавьте скриншоты с настройками раннера в проекте.

Ответ:

<img src = "screens/20260502_runner.png" width = 100%>

---

### Задание 2

**Что нужно сделать:**

1. Запушьте [репозиторий](https://github.com/netology-code/sdvps-materials/tree/main/gitlab) на GitLab, изменив origin. Это изучалось на занятии по Git.
2. Создайте .gitlab-ci.yml, описав в нём все необходимые, на ваш взгляд, этапы.

В качестве ответа в шаблон с решением добавьте: 
   
 * файл gitlab-ci.yml для своего проекта или вставьте код в соответствующее поле в шаблоне; 
 * скриншоты с успешно собранными сборками.

Ответ: 
Файл gitlab-ci.yml

#----
stages:
  - test
  - build

test:
  stage: test
  image: golang:latest
  script:
    - go test .
  tags:
    - Job

build:
  stage: build
  image: docker:latest
  script:
    - docker build .
  tags:
    - Job
#---- 

<img src = "screens/20260502_runner.png" width = 100%>
