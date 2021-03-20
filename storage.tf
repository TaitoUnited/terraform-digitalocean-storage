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

resource "digitalocean_spaces_bucket" "bucket" {
  for_each      = {for item in local.storageBuckets: item.name => item}

  name          = each.value.name
  region        = each.value.region
  acl           = each.value.acl
  force_destroy = false

  dynamic "cors_rule" {
    for_each = try(each.value.cors, null) != null ? each.value.cors : []
    content {
      allowed_origins = cors.value.allowedOrigins
      allowed_methods = cors.value.allowedMethods
      allowed_headers = cors.value.allowedHeaders
      max_age_seconds = cors.value.maxAgeSeconds
    }
  }

  versioning {
    enabled = each.value.versioningEnabled
  }

  # old version deletion
  lifecycle_rule {
    enabled = try(each.value.versioningRetainDays, null) != null
    noncurrent_version_expiration {
      days = each.value.versioningRetainDays
    }
  }

  # autoDeletion
  lifecycle_rule {
    enabled = try(each.value.autoDeletionRetainDays, null) != null
    expiration {
      days = each.value.autoDeletionRetainDays
    }
  }
}
