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
  acl           = coalesce(each.value.acl, "private")
  force_destroy = false

  dynamic "cors_rule" {
    for_each = coalesce(each.value.corsRules, null) != null ? each.value.corsRules : []
    content {
      allowed_origins = coalesce(cors_rule.value.allowedOrigins, ["GET","HEAD"])
      allowed_methods = coalesce(cors_rule.value.allowedMethods, ["*"])
      allowed_headers = coalesce(cors_rule.value.allowedHeaders, ["*"])
      max_age_seconds = coalesce(cors_rule.value.maxAgeSeconds, 5)
    }
  }

  versioning {
    enabled = coalesce(each.value.versioningEnabled, false)
  }

  # old version deletion
  lifecycle_rule {
    enabled = coalesce(each.value.versioningRetainDays, null) != null
    noncurrent_version_expiration {
      days = each.value.versioningRetainDays
    }
  }

  # autoDeletion
  lifecycle_rule {
    enabled = coalesce(each.value.autoDeletionRetainDays, null) != null
    expiration {
      days = each.value.autoDeletionRetainDays
    }
  }
}
