function(
  myTLA='default',
  replicas='1'
)
  [
    {
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: 'tvengine-api',
      },
    },

    {
      apiVersion: 'v1',
      kind: 'Service',
      metadata: {
        name: 'nestjs-app',
      },
      spec: {
        type: 'ClusterIP',
        selector: {
          app: 'nestjs-app',
        },
        ports: [
          {
            name: 'http',
            port: 80,
            targetPort: 3000,
          },
        ],
      },
    },

    // {
    //   apiVersion: 'networking.k8s.io/v1',
    //   kind: 'Ingress',
    //   metadata: {
    //     name: 'nestjs-app',
    //     annotations: {
    //       'traefik.ingress.kubernetes.io/router.entrypoints': 'websecure',
    //       'traefik.ingress.kubernetes.io/router.tls': 'true',
    //       'traefik.ingress.kubernetes.io/router.middlewares': 'nestjs-app@kubernetescrd',
    //     },
    //   },
    //   spec: {
    //     rules: [
    //       {
    //         host: 'tobias.tvengine.vorab.jetzt',
    //       },
    //       {
    //         http: {
    //           paths: [
    //             {
    //               path: '/nestjs',
    //               pathType: 'Prefix',
    //               backend: {
    //                 service: {
    //                   name: 'nestjs-app',
    //                   port: {
    //                     number: 80,
    //                   },
    //                 },
    //               },
    //             },
    //           ],
    //         },
    //       },
    //     ],
    //   },
    // },

    // {
    //   apiVersion: 'traefik.containo.us/v1alpha1',
    //   kind: 'Middleware',
    //   metadata: {
    //     name: 'nestjs-app',
    //   },
    //   spec: {
    //     stripPrefix: {
    //       forceSlash: true,
    //       prefixes: ['/nestjs'],
    //     },
    //   },
    // },


    {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: {
        name: 'nestjs-app',
        labels: {
          app: 'nestjs-app',
        },
      },
      spec: {
        replicas: std.parseInt(replicas),
        revisionHistoryLimit: 1,
        selector: {
          matchLabels: {
            app: 'nestjs-app',
          },
        },
        template: {
          metadata: {
            labels: {
              app: 'nestjs-app',
            },
          },
          spec: {
            imagePullSecrets: [
              {
                name: 'nestjs-app-registry',
              },
            ],
            containers: [
              {
                name: 'nestjs-app',
                image: 'hdptvepocdevsetupacr.azurecr.io/tobias/test-app:latest',
                ports: [
                  {
                    containerPort: 3000,
                  },
                ],
                env: [
                  {
                    name: 'NODE_ENV',
                    value: 'production',
                  },
                  {
                    name: 'EXT_VAR',
                    value: 'my-first-ext-var',
                  },
                  {
                    name: 'TLA_VAR',
                    value: myTLA,
                  },
                ],
              },
            ],
          },
        },
      },
    },
  ]
