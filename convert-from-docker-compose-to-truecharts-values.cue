package converter

import (
	"strings"
	"strconv"
)

input: _

if len(input.services) > 1 {
	_|_ // ERROR: Only one service at a time is supported for conversion.
}

// Get the first service from the input-compose file
let inputService = [ for _, s in input.services {s}][0]

// ----------------------------------------------------------------------
// Parsing helpers
// ----------------------------------------------------------------------

inputImage: {
	_parts: strings.Split(inputService.image, ":")
	repo: _parts[0]
	tag: *_parts[1] | "latest"
}

inputEnv: {
	for e in inputService.environment {
		(strings.Split(e, "=")[0]): strings.Split(e, "=")[1]
    }
}

inputPorts: {
	raw:       inputService.ports[0]
	host:      strconv.Atoi(strings.Split(raw, ":")[0])
	container: strconv.Atoi(strings.Split(raw, ":")[1])
}

inputCmd: strings.Split(inputService.command, " ")

inputVolumes: {
	raw:       inputService.volumes[0]
	host:      strings.Split(raw, ":")[0]
	container: strings.Split(raw, ":")[1]
	fileName:  strings.TrimPrefix(host, "./")
	inputVolumes: {
		raw:       inputService.volumes[0]
		host:      strings.Split(raw, ":")[0]
		container: strings.Split(raw, ":")[1]
		fileName:  strings.TrimPrefix(host, "./")
	}
}

// ----------------------------------------------------------------------
// OUTPUT – TrueCharts values.yaml format
// ----------------------------------------------------------------------
output: {
  image: {
    repository: inputImage.repo
    tag:        inputImage.tag
    pullPolicy: "IfNotPresent"
  }

  persistence: {
    config: {
      enabled:   true
      type:      "configmap"
      objectName:"config"
      mountPath: inputVolumes.container
      optional:  false
      readOnly:  true
    }
  }

  service: {
    main: {
      enabled: true
      ports: {
        main: {
          port:       inputPorts.host
          protocol:   "http"
          targetPort: inputPorts.container
        }
      }
    }
  }

  TZ: inputEnv.TZ

  workload: {
    main: {
      enabled: true
      type:    "Deployment"
      podSpec: {
        containers: {
          main: {
            enabled: true
            args: inputCmd
            probes: {
              liveness:  { enabled: false }
              readiness: { enabled: false }
              startup:   { enabled: false }
            }
          }
        }
      }
    }
  }
}
