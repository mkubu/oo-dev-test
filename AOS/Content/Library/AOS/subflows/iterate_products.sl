namespace: AOS.subflows
flow:
  name: iterate_products
  inputs:
    - json
    - category_name
    - category_id
    - file_path
    - product_id
  workflow:
    - get_product_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == '+product_id+')].productName'}"
        publish:
          - product_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: get_product_price
          - FAILURE: on_failure
    - get_product_price:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.*.products[?(@.productId == '+product_id+')].price'}"
        publish:
          - product_price: '${return_result[1:-1]}'
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
          - SUCCESS: is_excel
          - FAILURE: on_failure
    - add_product:
        do:
          io.cloudslang.base.filesystem.add_text_to_file:
            - file_path: '${file_path}'
            - text: "${\"|\"+\"|\".join([category_id.rjust(13),category_name.ljust(15),product_id.rjust(12),product_name.ljust(51),product_price.rjust(15),color_codes.ljust(60)])+\"|\\n\"}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - is_excel:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(file_path.endswith("xls") or file_path.endswith("xlsx"))}'
        publish: []
        navigate:
          - 'TRUE': Add_Excel_Data
          - 'FALSE': add_product
    - Add_Excel_Data:
        do_external:
          4552e495-4595-4916-b58b-ce521bdb1e9a:
            - excelFileName: '${file_path}'
            - worksheetName: products
            - headerData: "${'Category ID,Category Name,Product ID,Product Name,Product Price,'+','.join(['Color Code'] * 8)}"
            - rowData: "${category_id+','+category_name+','+product_id+','+product_name+','+product_price+','+color_codes}"
            - columnDelimiter: ','
            - rowsDelimiter: '|'
            - overwriteData: 'true'
        publish:
          - returnResult
        navigate:
          - failure: on_failure
          - success: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_product_name:
        x: 73
        'y': 108
      get_product_price:
        x: 215
        'y': 106
      get_color_codes:
        x: 356
        'y': 105
      add_product:
        x: 600
        'y': 268
        navigate:
          8b9139bc-a979-51de-8de0-8c5fdc38d8e4:
            targetId: 61a8f534-cba6-00ef-9903-663e3fcd1e90
            port: SUCCESS
      is_excel:
        x: 481
        'y': 110
      Add_Excel_Data:
        x: 613
        'y': 1
        navigate:
          3631f457-6412-6e84-603c-d1047c4bf677:
            targetId: 61a8f534-cba6-00ef-9903-663e3fcd1e90
            port: success
    results:
      SUCCESS:
        61a8f534-cba6-00ef-9903-663e3fcd1e90:
          x: 716
          'y': 112
