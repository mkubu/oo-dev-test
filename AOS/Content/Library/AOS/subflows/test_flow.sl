namespace: AOS.subflows
flow:
  name: test_flow
  workflow:
    - Create_Request:
        do_external:
          b37a057b-9f03-42db-bbd0-49844960804e: []
        navigate:
          - success: SUCCESS
          - failure: on_failure
    - Get_SSO_Token:
        do_external:
          78a95e79-2f1d-4173-b12b-e00f7bcd2134: []
        navigate:
          - success: Create_Request
          - failure: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Create_Request:
        x: 280
        'y': 163
        navigate:
          5680cdd1-6252-f35f-1a49-67ba2e253f9a:
            targetId: 12065305-e154-115a-74ea-142c84860d4a
            port: success
      Get_SSO_Token:
        x: 94
        'y': 158
    results:
      SUCCESS:
        12065305-e154-115a-74ea-142c84860d4a:
          x: 456
          'y': 151
