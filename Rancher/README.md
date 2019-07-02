# Rancher

## Pasos para crear un pipeline en Rancher:

Un pipeline es una herramienta de CI/CD que permite tener un observador que monitorea cualquier cambio en un repositorio (en este caso
se usara GitHub) y realizar una compilación y despliegue del proyecto de forma automática.

**1. Preparar proyecto y subirlo a un repositorio**

**2. En Rancher, loguearse y entrar al cluster donde se arbergará el pipeline**

**3. Ingresar en la seccion de Projects/Namespace**

**4. Crear un proyecto (en este caso se usará el nombre "Proyecto Final")**

**5. Click en Add Namespace dentro de la fila del proyecto recien creado (se usará e, nombre "entrega-final")**

**6. Ingresar al ambiente del proyecto recién creado y en la sección Workloads, seleccionar Pipelines**

**7. Click en Add repositories y seguir instrucciones para vincular el repositorio de su elección**

**8. Dentro del proyecto del repositorio, crear un archivo llamado "deployment.yaml" (se usará de ejemplo para la creación de una base de datos MySQL):**
```
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: bd
  namespace: [NOMBRE NAMESPACE]
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      workload.user.cattle.io/workloadselector: deployment-[NOMBRE NAMESPACE]-bd
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      labels:
        workload.user.cattle.io/workloadselector: deployment-[NOMBRE NAMESPACE]-bd
    spec:
      containers:
      - image: [USUARIO DOCKERHUB]/[NOMBRE IMAGEN]:[VERSION IMAGEN]
        imagePullPolicy: Always
        name: bd
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: '123456789'
      dnsPolicy: ClusterFirst
      imagePullSecrets:
      - name: dockerhub
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
---      
apiVersion: v1
kind: Service
metadata:
  annotations:
    field.cattle.io/targetWorkloadIds: '["deployment:[NOMBRE NAMESPACE]:bd"]'
    workload.cattle.io/targetWorkloadIdNoop: "true"
    workload.cattle.io/workloadPortBased: "true"
  labels:
    cattle.io/creator: norman
  name: nginx-loadbalancer-bd
  namespace: entrega-final
spec:
  externalTrafficPolicy: Cluster
  ports:
  - port: 3306
    protocol: TCP
    targetPort: 3306
  selector:
    workload.user.cattle.io/workloadselector: deployment-[NOMBRE NAMESPACE]-bd
  type: LoadBalancer 
```

**9. Dentro del proyecto del repositorio, crear un archivo llamado ".rancher-pipeline.yml" (se usará de ejemplo para la creación de una base de datos MySQL):**
```
	stages:
- name: Crear Imagen
  steps:
  - publishImageConfig:
      dockerfilePath: ./dockerfile
      buildContext: .
      tag: [USUARIO DOCKERHUB]/[NOMBRE IMAGEN]:[VERSION IMAGEN]
      pushRemote: true
      registry: index.docker.io
- name: Crear en k8s
  steps:
  - applyYamlConfig:
      path: ./deployment.yaml
timeout: 60
notification: {}
```

**10. En Rancher, click en enable al proyecto del repositorio al que se le desea agregar el pipeline**

**11. Click en opciones de este, click en Run**

**12. Cuando termine, en la sección de Workloads, aparecerá un link hacia la ruta donde esta corriendo el servicio:**
Ahora cada commit y push que se haga en ese repositorio, hará una recompilación en Rancher y un nuevo despliegue.


## Posibles errores:

**1. Timeout durante la compilación y creación de imagen**
Volver a darle en Run para el pipeline, o un nuevo cambio al repositorio


