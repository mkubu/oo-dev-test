namespace: SMAX
flow:
  name: flow_t01
  inputs:
    - smax_url: 'https://smax_tenant'
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${smax_url}'
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
        x: 173
        'y': 158
        navigate:
          f9da2a3d-12e4-2610-deb1-6895dce718ba:
            targetId: c4f2fdb3-e515-a8f6-6ab3-71569b9ab3f4
            port: SUCCESS
    results:
      SUCCESS:
        c4f2fdb3-e515-a8f6-6ab3-71569b9ab3f4:
          x: 467
          'y': 157
