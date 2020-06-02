namespace: AMDOCS
flow:
  name: RegisterAppMonitoring
  inputs:
    - appName:
        required: false
    - osInstance:
        required: false
    - monitoringPolicy:
        required: false
  workflow:
    - get_os_instance:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '1'
            - max: '3'
        publish:
          - random_sec: '${random_number}'
        navigate:
          - SUCCESS: assign_obm_policy
          - FAILURE: on_failure
    - assign_obm_policy:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${random_sec}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_os_instance:
        x: 59
        'y': 165
      assign_obm_policy:
        x: 229
        'y': 164
        navigate:
          d04c1e7f-0fbf-4476-930d-c919c6d3211b:
            targetId: fc79e4f5-1057-1aa5-3267-8830d70584bb
            port: SUCCESS
    results:
      SUCCESS:
        fc79e4f5-1057-1aa5-3267-8830d70584bb:
          x: 403
          'y': 167
