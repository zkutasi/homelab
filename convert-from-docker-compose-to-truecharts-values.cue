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
	if inputService.environment != _|_ {
		for e in inputService.environment {
			(strings.Split(e, "=")[0]): strings.Split(e, "=")[1]
		}
	}
}

inputPorts: {
	raw:       inputService.ports[0]
	host:      strconv.Atoi(strings.Split(raw, ":")[0])
	container: strconv.Atoi(strings.Split(raw, ":")[1])
}

inputCmd: [
	if inputService.command != _|_ {
		for v in strings.Split(inputService.command, " ") {v}
	},
]

inputVolumes: {
	if inputService.volumes != _|_ {
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

  if inputService.volumes != _|_ {
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

  TZ: "Europe/Budapest"

  workload: {
    main: {
      enabled: true
      type:    "Deployment"
      podSpec: {
        containers: {
          main: {
            enabled: true
            if inputService.inputCmd != _|_ { args: inputCmd }
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
