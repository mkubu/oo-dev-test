namespace: SMAX
flow:
  name: request_data
  inputs:
    - smax_url: 'https://us1-smax.saas.microfocus.com/'
    - smax_username: tenant_admin
    - smax_password:
        default: 'SMAXR0cks!'
        sensitive: false
  workflow:
    - Get_SSO_Token:
        do_external:
          78a95e79-2f1d-4173-b12b-e00f7bcd2134:
            - sawUrl: '${smax_url}'
            - username: '${smax_username}'
            - password:
                value: '${smax_password}'
                sensitive: true
            - trustAllRoots: 'true'
        publish:
          - ssoToken
        navigate:
          - success: SUCCESS
          - failure: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_SSO_Token:
        x: 64
        'y': 167
        navigate:
          ca32ee10-9ee4-9c8b-03a4-aa8264e21fb3:
            targetId: 38e540bf-60e5-b0cb-83ff-994a0463f210
            port: success
    results:
      SUCCESS:
        38e540bf-60e5-b0cb-83ff-994a0463f210:
          x: 344
          'y': 168
