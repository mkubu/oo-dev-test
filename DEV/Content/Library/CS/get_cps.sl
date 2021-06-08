namespace: CS
flow:
  name: get_cps
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: 'https://puevmpre06.swinfra.net:8443/oo/rest/latest/content-packs'
            - auth_type: basic
            - username: admin
            - password:
                value: Police.123
                sensitive: true
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 166
        'y': 107
        navigate:
          80dd8492-0cc6-4720-92c5-6e897dda3165:
            targetId: e3345d08-c4b9-2401-12d5-e6e0d043e053
            port: SUCCESS
    results:
      SUCCESS:
        e3345d08-c4b9-2401-12d5-e6e0d043e053:
          x: 469
          'y': 107
