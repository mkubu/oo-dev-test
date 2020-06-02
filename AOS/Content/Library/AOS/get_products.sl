namespace: AOS
flow:
  name: get_products
  inputs:
    - aos_url: 'https://www.advantageonlineshopping.com/'
    - file_path: "c:\\\\temp\\\\products.xlsx"
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${aos_url+"/catalog/api/v1/categories/all_data"}'
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: is_excel
          - FAILURE: on_failure
    - write_header:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: '${file_path}'
            - text: "${'+'+'+'.join([''.center(13,'-'),''.center(15,'-'),''.center(12,'-'),''.center(51,'-'),''.center(15,'-'),''.center(60,'-')])+'+\\n'+\\\n'|'+'|'.join(['Category ID'.center(13),'Category Name'.center(15),'Product ID'.center(12),'Product Name'.center(51),'Product Price'.center(15),'Color Codes'.center(60)])+'|\\n'+\\\n'+'+'+'.join([''.center(13,'-'),''.center(15,'-'),''.center(12,'-'),''.center(51,'-'),''.center(15,'-'),''.center(60,'-')])+'+\\n'}"
        navigate:
          - SUCCESS: get_categories
          - FAILURE: on_failure
    - get_categories:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: '$.*.categoryId'
        publish:
          - category_id_list: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: iterate_categories
          - FAILURE: on_failure
    - iterate_categories:
        loop:
          for: category_id in category_id_list
          do:
            AOS.subflows.iterate_categories:
              - json: '${json}'
              - category_id: '${category_id}'
              - file_path: '${file_path}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - is_excel:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(file_path.endswith("xls") or file_path.endswith("xlsx"))}'
        navigate:
          - 'TRUE': delete
          - 'FALSE': write_header
    - delete:
        do:
          io.cloudslang.base.filesystem.delete:
            - source: '${file_path}'
        navigate:
          - SUCCESS: New_Excel_Document
          - FAILURE: New_Excel_Document
    - New_Excel_Document:
        do_external:
          9d21ca68-7d03-4fb3-9478-03956532bf6f:
            - excelFileName: '${file_path}'
            - worksheetNames: products
            - delimiter: ','
        publish:
          - returnResult
        navigate:
          - failure: on_failure
          - success: get_categories
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 1
        'y': 108
      write_header:
        x: 360
        'y': 113
      get_categories:
        x: 499
        'y': 112
      iterate_categories:
        x: 497
        'y': 270
        navigate:
          cd0592bb-4915-d12e-5f09-c6d043c83cc3:
            targetId: a6bad35b-9862-7882-ba05-243858ed5ab5
            port: SUCCESS
      is_excel:
        x: 153
        'y': 114
      delete:
        x: 154
        'y': 285
      New_Excel_Document:
        x: 358
        'y': 284
    results:
      SUCCESS:
        a6bad35b-9862-7882-ba05-243858ed5ab5:
          x: 497
          'y': 426
