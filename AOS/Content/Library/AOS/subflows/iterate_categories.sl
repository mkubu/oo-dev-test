namespace: AOS.subflows
flow:
  name: iterate_categories
  inputs:
    - json
    - category_id
    - file_path
  workflow:
    - get_category:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: '${"$[?(@.categoryId == "+category_id+")]"}'
        publish:
          - category_json: '${return_result}'
        navigate:
          - SUCCESS: get_category_name
          - FAILURE: on_failure
    - get_category_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
            - json_path: '$.*.categoryName'
        publish:
          - category_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_product_ids
          - FAILURE: on_failure
    - get_product_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${category_json}'
            - json_path: '$.*.products.*.productId'
        publish:
          - product_ids: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: iterate_products
          - FAILURE: on_failure
    - iterate_products:
        loop:
          for: product_id in product_ids
          do:
            AOS.subflows.iterate_products:
              - json: '${category_json}'
              - category_name: '${category_name}'
              - category_id: '${category_id}'
              - file_path: '${file_path}'
          break: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_category:
        x: 71
        'y': 104
      get_category_name:
        x: 223
        'y': 102
      get_product_ids:
        x: 379
        'y': 106
      iterate_products:
        x: 535
        'y': 115
        navigate:
          7ba4b207-60a8-42c4-874c-4163df735739:
            targetId: 61f38339-f493-d412-f99d-4615023dbcb4
            port: SUCCESS
    results:
      SUCCESS:
        61f38339-f493-d412-f99d-4615023dbcb4:
          x: 706
          'y': 97
