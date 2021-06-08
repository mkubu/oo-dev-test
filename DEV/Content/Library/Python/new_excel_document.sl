namespace: Python
operation:
  name: new_excel_document
  inputs:
    - file_name
    - sheet_name:
        required: false
        default: Sheet1
    - header_data:
        required: false
    - delimiter:
        required: false
        default: ','
  python_action:
    use_jython: false
    script: |-
      import openpyxl
      from openpyxl import Workbook
      def execute(file_name, sheet_name, header_data, delimiter):
          wb = Workbook()
          sheet = wb.active
          if (sheet_name is None):
              sheet_name = 'Sheet1'
          sheet.title = sheet_name
          if (header_data is not None):
              sheet.append(eval(header_data))
          wb.save(file_name)
  results:
    - SUCCESS
