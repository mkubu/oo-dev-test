namespace: SMAX
flow:
  name: request_data
  inputs:
    - smax_url: 'https://us1-smax.saas.microfocus.com'
    - smax_username: tenant_admin
    - smax_password:
        default: 'SMAXR0cks!'
        sensitive: false
    - proxy_host: web-proxy.eu.softwaregrp.net
    - tenant_id: '328414634'
    - proxy_port: '8080'
  workflow:
    - get_sso_token:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${smax_url+'/auth/authentication-endpoint/authenticate/login?TENANTID='+tenant_id}"
            - auth_type: basic
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: 'Accept:application/json'
            - body: '{"Login":"tenant_admin","Password":"SMAXR0cks!"}'
            - content_type: application/json
        publish:
          - sso_token: '${return_result}'
        navigate:
          - SUCCESS: http_client_get
          - FAILURE: on_failure
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${smax_url+':443/rest/'+tenant_id+'/ems/Request?layout=Id,DisplayLabel,ImpactScope,Urgency'}"
            - auth_type: basic
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - headers: "${'Cookie:LWSSO_COOKIE_KEY=%s; TENANTID=%s' % (sso_token,tenant_id)}"
            - content_type: 'Accept:application/json'
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: write_to_file
          - FAILURE: on_failure
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: "c:\\\\temp\\\\request.json"
            - text: '${json}'
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
        x: 101
        'y': 172
      http_client_get:
        x: 283
        'y': 173
      write_to_file:
        x: 281
        'y': 339
        navigate:
          fdb937af-7c30-9aea-30ee-e72caec22e80:
            targetId: 38e540bf-60e5-b0cb-83ff-994a0463f210
            port: SUCCESS
    results:
      SUCCESS:
        38e540bf-60e5-b0cb-83ff-994a0463f210:
          x: 447
          'y': 340
