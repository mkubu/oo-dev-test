namespace: SMAX
flow:
  name: request_data_1
  inputs:
    - smax_url: 'https://smd.mfdemos.com'
    - smax_username: michal.kubu
    - smax_password:
        default: MFdemo.12345
        sensitive: true
    - proxy_host: web-proxy.eu.softwaregrp.net
    - tenant_id: '608148015'
    - proxy_port: '8080'
  workflow:
    - get_sso_token:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${smax_url+'/auth/authentication-endpoint/authenticate/login?TENANTID='+tenant_id}"
            - auth_type: basic
            - username: null
            - password:
                value: null
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: 'Accept:application/json'
            - body: "${'{\"Login\":\"' + smax_username + '\",\"Password\":\"' + smax_password  + '\"}'}"
            - content_type: application/json
        publish:
          - sso_token: '${return_result}'
        navigate:
          - SUCCESS: http_client_action
          - FAILURE: on_failure
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${smax_url+':443/rest/'+tenant_id+'/ems/Request?layout=Id,DisplayLabel,ImpactScope,Urgency'}"
            - auth_type: basic
            - preemptive_auth: null
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - headers: "${'Cookie:LWSSO_COOKIE_KEY=%s; TENANTID=%s' % (sso_token,tenant_id)}"
            - destination_file: "c:\\\\temp\\\\request1.json"
            - content_type: 'Accept:application/json'
            - method: GET
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_sso_token:
        x: 100
        'y': 177
      http_client_action:
        x: 270
        'y': 179
        navigate:
          ba2febc4-b50f-3e97-8385-9192e51bb509:
            targetId: 38e540bf-60e5-b0cb-83ff-994a0463f210
            port: SUCCESS
    results:
      SUCCESS:
        38e540bf-60e5-b0cb-83ff-994a0463f210:
          x: 460
          'y': 172
