namespace: AOS.subflows
flow:
  name: iterate_products
  inputs:
    - json
    - category_name
    - category_id
    - file_path
  workflow:
    - get_product_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == '+product_id+')].productName'}"
        publish:
          - product_name: '${return_result[-2:2]}'
        navigate:
          - SUCCESS: get_product_price
          - FAILURE: on_failure
    - get_product_price:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == '+product_id+')].price'}"
        publish:
          - return_result: '${return_result[-1:1]}'
        navigate:
          - SUCCESS: get_color_codes
          - FAILURE: on_failure
    - get_color_codes:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == '+product_id+')].colors.*.code'}"
        publish:
          - color_codes: "${filter(lambda ch: ch not in '\"', return_result)[1:-1]}"
        navigate:
          - SUCCESS: add_product
          - FAILURE: on_failure
    - add_product:
        do:
          io.cloudslang.base.filesystem.add_text_to_file:
            - file_path: '${file_path}'
            - text: "${\"|\"+\"|\".join([category_id.rjust(13),category_name.ljust(15),product_id.rjust(12),product_name.ljust(51),product_price.rjust(15),color_codes.ljust(60)])+\"|\\n\"}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_product_price:
        x: 215
        'y': 106
      get_product_name:
        x: 74
        'y': 108
      get_color_codes:
        x: 357
        'y': 104
      add_product:
        x: 509
        'y': 111
        navigate:
          8b9139bc-a979-51de-8de0-8c5fdc38d8e4:
            targetId: 61a8f534-cba6-00ef-9903-663e3fcd1e90
            port: SUCCESS
    results:
      SUCCESS:
        61a8f534-cba6-00ef-9903-663e3fcd1e90:
          x: 673
          'y': 106
