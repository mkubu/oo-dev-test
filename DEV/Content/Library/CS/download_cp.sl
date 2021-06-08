namespace: CS
flow:
  name: download_cp
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: 'https://puevmpre06.swinfra.net:8443/oo/rest/latest/content-file/7a1655a9-7263-4d18-83cc-bf8c95c78d7b'
            - auth_type: basic
            - username: admin
            - password:
                value: Police.123
                sensitive: true
            - destination_file: "c:\\\\temp\\mycp.jar"
            - method: GET
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 125
        'y': 140
        navigate:
          fc8c0322-917d-4156-c492-cc0d8014e2cd:
            targetId: 00bc3c80-56c0-dfdd-af4e-0319ace921c8
            port: SUCCESS
    results:
      SUCCESS:
        00bc3c80-56c0-dfdd-af4e-0319ace921c8:
          x: 361
          'y': 139
