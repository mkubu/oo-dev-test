namespace: Python
flow:
  name: excel_flow
  workflow:
    - new_excel_document:
        do:
          Python.new_excel_document:
            - file_name: "c:\\\\temp\\\\excel-test.xlsx"
            - header_data: 'c1,c2,c3'
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      new_excel_document:
        x: 184
        'y': 121
        navigate:
          ffdcf87b-de6a-e21f-247e-e4b136196dae:
            targetId: 8030e823-8054-d9ed-cfd9-7f98896807e1
            port: SUCCESS
    results:
      SUCCESS:
        8030e823-8054-d9ed-cfd9-7f98896807e1:
          x: 388
          'y': 104
