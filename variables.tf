/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "storage_buckets" {
  type = list(object({
    name = string
    region = string
    acl = optional(string)
    corsRules = list(object({
      allowedOrigins = list(string)
      allowedMethods = optional(list(string))
      allowedHeaders = optional(list(string))
      maxAgeSeconds = optional(number)
    }))
    versioningEnabled = optional(bool)
    versioningRetainDays = optional(number)
    autoDeletionRetainDays = optional(number)
  }))
  default     = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}
