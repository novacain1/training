kind: Template
apiVersion: v1
metadata:
  annotations:
    description: The Gogs git server. Requires a PostgreSQL database.
    tags: instant-app,gogs,datastore
    iconClass: icon-github
  name: gogs
objects:
- kind: Service
  apiVersion: v1
  metadata:
    annotations:
      description: The Gogs servers http port
    labels:
      app: ${APPLICATION_NAME}
    name: ${APPLICATION_NAME}
  spec:
    ports:
    - name: 3000-tcp
      port: 3000
      protocol: TCP
      targetPort: 3000
    selector:
      app: ${APPLICATION_NAME}
      deploymentconfig: ${APPLICATION_NAME}
    sessionAffinity: None
    type: ClusterIP
- kind: Route
  apiVersion: v1
  id: ${APPLICATION_NAME}-http
  metadata:
    annotations:
      description: Route for applications http service.
    labels:
      app: ${APPLICATION_NAME}
    name: ${APPLICATION_NAME}
  spec:
    host: ${GOGS_ROUTE}
    to:
      name: ${APPLICATION_NAME}
- kind: DeploymentConfig
  apiVersion: v1
  metadata:
    labels:
      app: ${APPLICATION_NAME}
    name: ${APPLICATION_NAME}
  spec:
    replicas: 1
    selector:
      app: ${APPLICATION_NAME}
      deploymentconfig: ${APPLICATION_NAME}
    strategy:
      rollingParams:
        intervalSeconds: 1
        maxSurge: 25%
        maxUnavailable: 25%
        timeoutSeconds: 600
        updatePeriodSeconds: 1
      type: Rolling
    template:
      metadata:
        labels:
          app: ${APPLICATION_NAME}
          deploymentconfig: ${APPLICATION_NAME}
      spec:
        containers:
        - image: \"\"
          imagePullPolicy: Always
          name: ${APPLICATION_NAME}
          ports:
          - containerPort: 3000
            protocol: TCP
          resources: {}
          terminationMessagePath: /dev/termination-log
          volumeMounts:
          - name: gogs-data
            mountPath: /data
          - name: gogs-config
            mountPath: /opt/gogs/custom/conf
          readinessProbe:
              httpGet:
                path: /
                port: 3000
                scheme: HTTP
              initialDelaySeconds: 3
              timeoutSeconds: 1
              periodSeconds: 20
              successThreshold: 1
              failureThreshold: 3
          livenessProbe:
              httpGet:
                path: /
                port: 3000
                scheme: HTTP
              initialDelaySeconds: 3
              timeoutSeconds: 1
              periodSeconds: 10
              successThreshold: 1
              failureThreshold: 3
        dnsPolicy: ClusterFirst
        restartPolicy: Always
        terminationGracePeriodSeconds: 30
        volumes:
        - name: gogs-data
          persistentVolumeClaim:
            claimName: gogs-data
        - name: gogs-config
          configMap:
            name: gogs-config
            items:
              - key: app.ini
                path: app.ini
    test: false
    triggers:
    - type: ConfigChange
    - imageChangeParams:
        automatic: true
        containerNames:
        - ${APPLICATION_NAME}
        from:
          kind: ImageStreamTag
          name: ${GOGS_IMAGE}
          namespace: openshift
      type: ImageChange
- kind: PersistentVolumeClaim
  apiVersion: v1
  metadata:
    name: gogs-data
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: ${GOGS_VOLUME_CAPACITY}
- kind: ConfigMap
  apiVersion: v1
  metadata:
    name: gogs-config
  data:
    app.ini: |
      APP_NAME = Gogs
      RUN_MODE = prod
      RUN_USER = gogs

      [database]
      DB_TYPE  = postgres
      HOST     = postgresql:5432
      NAME     = ${DATABASE_NAME}
      USER     = ${DATABASE_USER}
      PASSWD   = ${DATABASE_PASSWORD}
      SSL_MODE = disable

      [repository]
      ROOT = /data/repositories

      [server]
      ROOT_URL=http://${GOGS_ROUTE}

      [security]
      INSTALL_LOCK = true

      [mailer]
      ENABLED = false

      [service]
      ENABLE_CAPTCHA = false
      REGISTER_EMAIL_CONFIRM = false
      ENABLE_NOTIFY_MAIL     = false
      DISABLE_REGISTRATION   = false
      REQUIRE_SIGNIN_VIEW    = false

      [picture]
      DISABLE_GRAVATAR        = false
      ENABLE_FEDERATED_AVATAR = true

      [webhook]
      SKIP_TLS_VERIFY = true
parameters:
- name: APPLICATION_NAME
  description: The name for the application.
  required: true
  value: gogs
- name: GOGS_ROUTE
  description: The route for the Gogs Application
  required: true
- name: GOGS_VOLUME_CAPACITY
  description: Volume space available for data, e.g. 512Mi, 2Gi
  required: true
  value: 4Gi
- name: DATABASE_USER
  displayName: Database Username
  required: true
  value: gogs
- name: DATABASE_PASSWORD
  displayName: Database Password
  required: true
  value: gogs
- name: DATABASE_NAME
  displayName: Database Name
  required: true
  value: gogs
- name: GOGS_IMAGE
  displayName: Gogs Image and tag
  required: true
  value: gogs:latest
