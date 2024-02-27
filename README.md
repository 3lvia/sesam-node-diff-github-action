# sesam-upload-github-action

Deploy config to sesam service API.

# Usage

### Inputs
```
 download:
    description: 'Download config from Sesam node'
    required: true
    default: true
  node:
    description: 'Sesam node url. eg "datahub-asdfasdf.sesam.cloud"'
    required: true
  jwt:
    description: 'JWT authorization token created by the Sesam portal'
    required: true
  config_path_local:
    description: 'the path to the local sesam config folder. E.g. from checkout action.'
    required: true
    default: node
  config_path_download:
    description: 'the path to the downloaded config folder'
    required: true
    default: node_downloaded
  config_group:
    description: 'config-group to place the config in. Defaults to "default"'
    default: 'Default'
    required: true
  git_args:
    description: 'arguments to pass to git diff'
    default: ''
    required: false
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
  diff:
    runs-on: ubuntu-latest
    name: git diff node configs
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Do git diff
        id: sesam_diff
        uses: 3lvia/sesam-node-diff-github-action@v0.3
        with:
          node: ${{ vars.NODE }}
          jwt: ${{ secrets.JWT }}
```

