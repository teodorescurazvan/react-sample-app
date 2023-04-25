# CI/CD Pipeline Sample (React, GIT, Docker, Jenkins, AWS) 

Acest proiect propune un exemplu simplu pentru implementarea unui CI/CD pipeline.

Proiectul include un numar de configurari finalizate (mandatory), precum si unele propuse (optional/WIP), mai specific:

### Minimum Viable Product (MVP)
- Sample React App (codebase)
- Git hosted cu 2 branch-uri (master/dev) (SCM)
- Docker & Dockerhub (hosting & versionare)
- Jenkins (CI/CD pipeline)
- AWS (hosting IaaS)

### Optional
- Configurare pipeline pt. branch-ul de DEV
- Provizionare automatizata via Terraform
- Instalare automatizata via Ansible

## Arhitectura

Diagrama de mai jos ofera o privire de ansamblu asupra pipeline-ului precum si tool-urile utilizate.
![alt text](https://github.com/alexandrub88/ITSchool/blob/dev/razvant/Project/pipeline_arch.png)

### Componentele arhitecturii:
- `react-sample-app` - O aplicatie minimalista bazata pe framework-ul ReactJS, oferita ca sample pt. testarea pipeline-ului.
`GitHub` - Platforma online folosita pt. SCM (source code management), implementare de GIT. In arhitectura curenta aceasta gestioneaza codul sursa pt. aplicatia 'react-sample-app' prin intermediul unui repository cu 2 branch-uri (dev si master).
- `Jenkins` - Tool popular pt. configurarea, rularea si monitorizarea de task-uri (ex: pipeline-uri, batch jobs, etc..). In acest context este folosit pt. configurarea a 2 pipeline-uri identice, fiecare corepunzand unui branch din repository-ul mentionat la pct. anterior (dev, respectiv master).
- `Docker` - Tehnologie populara de containerizare dezvoltata pt. modularizarea si portabilitatea componentelor unei arhitecturi software (ex: DB, app server, web server, custom apps, etc..). In arhitectura curenta folosim Docker atat pt. a "impacheta" aplicatia intr-o imagine pt. fiecare versiune de build, precum si hosting-ul aplicatiei 'react-sample-app' la runtime.
- `DockerHub` - Hub online oferit de Docker pt. hosting de imagini de containere reutilizable. Vol folosi DockerHub pt. a incarca imaginile generate de 'docker build' in urma fiecarui build de aplicatie.
- `Amazon Web Services` - Cel mai utilizat si popular furnizor de servicii de Cloud. In acest context folosim o instanta de EC2 (Elastic Cloud Compute), tip t2.medium (2 CPU, 4GB RAM) + 20GB block volume, resursele fiind necesare pt. arhitectura noastra (i.e. Docker si Jenkins).

NOTA: Deoarece pipeline-urile sunt 95% identice, vom examina flow-ul doar pt. cel mai complex (PROD).

## CI/CD Pipeline Flow

Configurarea pipeline-ului consta in urmatorii pasi:
- `1. Pull brach` - se executa un `git pull` pt. branch-ul respectiv si se downloadeaza local ultima versiune a condului sursa (care include schimbarile de la ultimul commit).
- `2. Build Docker image` - se executa `docker build` folosing Dockerfile-ul specific branch-ului master `Dockerfile.prod`. Acesta include un numar de pasi specifici build-ului multi-stage de Docker, in care in prima faza se face install si build aplicatiei de React (npm install + npm run build), iar ultierior fisierele statice rezultate sunt copiate din folderul /build/ intr-un container de nginx final.
- `3. Push image to DockerHub` - imaginea optimizata rezultata este tagged cu nr build-ului (nr job-ului din Jenkins) si tag-ul 'latest' si incarcata via `docker push` in Dockerhub, de unde poate fi atat pastrata pt. audit/rollback cat si descarcata pt. genera noi containere.
- `4. Cleanup stale containers` - in acest pas se ruleaza din shell comanda `docker container prune` care inchide si sterge toate containerele care ruleaza momentan. Scopul este de a elimina containerele care ruleaza varianta anterioara a aplicatiei si a crea un nou container cu ultima versiune.
- `5. Start container` - in acest ultim pas rulam comanda `docker run` folosind ca imagine de pornire cea tagged cu 'latest'. De asemenea, deoarece vrem sa folosim portul 3002 (iar NGINX ruleaza default pe 80) adaugam param -p pt. port mapping. -d este folosit pt. a porni si rula container-ul headless (detached)

## Configurari efectuate

- `1. Dockerfile` - pentru crearea imaniginilor de Docker pt. fiecare branch au fost definite doua fisiere: `Dockerfile` (pt. 'dev') si `Dockerfile.prod` (pt. 'master'). Ambele fisiere instaleaza aplicatia de Node, cu exceptia ca Dockerfile.prod de asemenea 
- `2. Docker Compose` - pt. convenienta, pt. fiecare Dockerfile a fost create si un fisier .yml pt. orchestrare via Docker Compose.
    - `docker-compose.yml` - pornire container pe imaginea de DEV, pe port-ul 3001, cu polling pt. webpack;
    - `docker-compose.prod.yml` - pornire container pe imaginea de PROD, pe port-ul 3002 (mapat de la 80);
- `3. Jenkins` - Multiple configurari:
    - `i. Credentiale` - configurat credentiale pt. GitHub si DockerHub;
    - `ii. Pipeline` - configurat cu polling la minut (H/60 * * * *) pe repository-ul de GitHub aferent aplicatiei (branch 'master') si ruland un `Jenkinsfile` pt. a executa pipeline-ul
    - `iii. Jenkinsfile` - fisierul care defineste pasii executati in pipeline.
- `4. AWS` - Multiple configurari:
    - `i. Generare keypair RSA` - deifinirea unui key-pair RSA pt. conectarea securizata prin SSH;
    - `ii. Volume storage` - crearea unui storage volume de 20GB pt. instanta de EC2;
    - `iii. Creare instanta EC2` - crearea unei instante t2.medium cu volumul atasat;
    - `Instalare Docker si Jenkins` - conectare prin SSH si instalarea via `yum install`;