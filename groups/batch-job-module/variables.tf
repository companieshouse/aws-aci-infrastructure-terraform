variable "name" {
  description = "Name of the job definition"
  type        = string
}

variable "type" {
  description = "Job definition type: container, multinode, or eks."
  type        = string

  validation {
    condition     = contains(["CONTAINER", "MULTINODE", "EKS"], upper(var.type))
    error_message = "Type must be one of: container, multinode, eks."
  }
}

variable "platform_capabilities" {
  description = "Platform capabilities: EC2 or FARGATE."
  type        = set(string)
  validation {
    condition     = length(var.platform_capabilities) == 1 && alltrue([for pc in var.platform_capabilities : contains(["EC2", "FARGATE"], pc)])
    error_message = "Platform_capabilities must contain exactly one of: EC2 or FARGATE."
  }
}

variable "template_vars" {
  description = "Scenario-specific variables for all AWS Batch job definition types"
  type = object({
    containerProperties = optional(object({
      image                  = optional(string),
      command                = optional(list(string)),
      jobRoleArn             = optional(string),
      executionRoleArn       = optional(string),
      readonlyRootFilesystem = optional(bool),
      user                   = optional(string),
      environment = optional(list(object({
        name  = optional(string),
        value = optional(string)
      }))),
      linuxParameters = optional(object({
        initProcessEnabled = optional(bool),
        sharedMemorySize   = optional(number),
        tmpfs = optional(list(object({
          mountOptions  = optional(list(string)),
          size          = optional(number),
          containerPath = optional(string)
        }))),
        devices    = optional(list(any)),
        maxSwap    = optional(number),
        swappiness = optional(number)
      })),
      logConfiguration = optional(object({
        logDriver = optional(string),
        options   = optional(map(string)),
        secretOptions = optional(list(object({
          name      = optional(string),
          valueFrom = optional(string)
        })))
      })),
      mountPoints = optional(list(object({
        containerPath = optional(string),
        readOnly      = optional(bool),
        sourceVolume  = optional(string)
      }))),
      networkConfiguration = optional(object({
        assignPublicIp = optional(string)
      })),
      resourceRequirements = optional(list(object({
        type  = optional(string),
        value = optional(string)
      }))),
      secrets = optional(list(object({
        name      = optional(string),
        valueFrom = optional(string)
      }))),
      ulimits = optional(list(object({
        name      = optional(string),
        softLimit = optional(number),
        hardLimit = optional(number)
      }))),
      volumes = optional(list(object({
        name = optional(string),
        host = optional(object({
          sourcePath = optional(string)
        })),
        efsVolumeConfiguration = optional(object({
          fileSystemId          = optional(string),
          rootDirectory         = optional(string),
          transitEncryption     = optional(string),
          transitEncryptionPort = optional(number)
        }))
      }))),
      fargatePlatformConfiguration = optional(object({
        platformVersion = optional(string)
      })),
      ephemeralStorage = optional(object({
        sizeInGiB = optional(number)
      })),
      runtimePlatform = optional(object({
        operatingSystemFamily = optional(string),
        cpuArchitecture       = optional(string)
      })),
      privileged = optional(bool)
    })),

    eksProperties = optional(object({
      podProperties = optional(object({
        hostNetwork           = optional(bool),
        serviceAccountName    = optional(string),
        shareProcessNamespace = optional(bool),
        dnsPolicy             = optional(string),
        containers = optional(list(object({
          name    = optional(string),
          image   = optional(string),
          command = optional(list(string)),
          args    = optional(list(string)),
          env = optional(list(object({
            name  = optional(string),
            value = optional(string)
          }))),
          resources = optional(object({
            limits = optional(object({
              cpu    = optional(string),
              memory = optional(string)
            }))
          })),
          securityContext = optional(any),
          volumeMounts = optional(list(object({
            name      = optional(string),
            mountPath = optional(string)
          }))),
          essential  = optional(bool),
          privileged = optional(bool)
        }))),
        volumes = optional(list(object({
          name = optional(string),
          emptyDir = optional(object({
            medium    = optional(string),
            sizeLimit = optional(string)
          })),
          hostPath = optional(object({
            path = optional(string)
          })),
          secret = optional(object({
            secretName = optional(string),
            optional   = optional(bool)
          }))
        }))),
        metadata = optional(object({
          labels      = optional(map(string)),
          annotations = optional(map(string))
        })),
        imagePullSecrets = optional(list(string)),
        initContainers   = optional(list(any)),
        imagePullPolicy  = optional(string)
      }))
    })),

    nodeProperties = optional(object({
      numNodes = optional(number),
      mainNode = optional(number),
      nodeRangeProperties = optional(list(object({
        targetNodes = optional(string),
        container = optional(object({
          image            = optional(string),
          vcpus            = optional(number),
          memory           = optional(number),
          command          = optional(list(string)),
          jobRoleArn       = optional(string),
          executionRoleArn = optional(string),
          environment = optional(list(object({
            name  = optional(string),
            value = optional(string)
          }))),
          mountPoints = optional(list(object({
            containerPath = optional(string),
            readOnly      = optional(bool),
            sourceVolume  = optional(string)
          }))),
          volumes = optional(list(object({
            name = optional(string),
            host = optional(object({
              sourcePath = optional(string)
            }))
          }))),
          logConfiguration = optional(object({
            logDriver = optional(string),
            options   = optional(map(string)),
            secretOptions = optional(list(object({
              name      = optional(string),
              valueFrom = optional(string)
            })))
          })),
          secrets = optional(list(object({
            name      = optional(string),
            valueFrom = optional(string)
          }))),
          ulimits = optional(list(object({
            name      = optional(string),
            softLimit = optional(number),
            hardLimit = optional(number)
          }))),
          linuxParameters = optional(object({
            initProcessEnabled = optional(bool),
            sharedMemorySize   = optional(number),
            tmpfs = optional(list(object({
              mountOptions  = optional(list(string)),
              size          = optional(number),
              containerPath = optional(string)
            })))
          })),
          readonlyRootFilesystem = optional(bool),
          privileged             = optional(bool),
          user                   = optional(string),
          resourceRequirements = optional(list(object({
            type  = optional(string),
            value = optional(string)
          })))
        }))
      })))
    }))
  })
  default = {}
}

variable "deregister_on_new_revision" {
  description = "Determines if the previous version is deregistered"
  type        = bool
  default     = true
}

variable "parameters" {
  description = "Parameter substitution placeholders to set in the job definition"
  type        = map(string)
  default     = {}
}

variable "propagate_tags" {
  description = "Whether to propagate the tags from the job definition to the corresponding Amazon ECS task"
  type        = bool
  default     = false
}

variable "scheduling_priority" {
  description = "Scheduling priority of the job definition"
  type        = number
  default     = 1
}

variable "retry_attempts" {
  description = "Supports the retry strategy to use for failed jobs that are submitted with this job definition"
  type    = number
  default = 1
}

variable "evaluate_on_exit" {
  description = "Evaluate on exit conditions under which the job should be retried or failed"
  type = list(object({
    action           = string,
    on_exit_code     = string,
    on_reason        = string,
    on_status_reason = string
  }))
  default = []
}

variable "timeout_seconds" {
  description = "Time duration in seconds after which AWS Batch terminates your jobs if they have not finished"
  type    = number
  default = 3600
}

variable "tags" {
  type    = map(string)
  default = {}
}
