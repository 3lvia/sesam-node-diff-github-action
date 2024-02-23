# sesam-upload-github-action

Deploy config to sesam service API.

# Usage

### Inputs
```
  node:
    description: 'Sesam node url. eg "datahub-asdfasdf.sesam.cloud"'
    required: true

  jwt:
    description: 'JWT authorization token created by the Sesam portal'
    required: true

  config-file:
    description: 'the location of the config file'
    required: true

  config-group:
    description: 'config-group to place the config in. Defaults to "default"'
    default: 'Default'
    required: true
```

### Outputs
```
  status-code:
    description: 'status code returned by service API'
```

## Example
```
on: [push]

jobs:
  sesam_upload_job:
    runs-on: ubuntu-latest
    name: A job to upload sesam config
    steps:
      - name: sesam-upload action step
        uses: 3lvia/sesam-upload-github-action@v1
        id: upload
        with:
          node: ${{ vars.NODE }}
          jwt: ${{ secrets.JWT }}
          config-file: 'config/getting-started-config.json'
          config-group: 'Default'
      # Use the output from the `upload` step
      - name: Get the status code
        run: echo "status code was ${{ steps.upload.outputs.status-code }}"
```

