/**
 * Copyright 2021 Google LLC
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

# Resources in this file are optional and used for demonstration purposes only

# Create 3 elastic IPs, one for each environment to be used by Ingress controllers

resource "google_compute_global_address" "development-ingress" {
  count       = var.ingress-ip-addresses == true ? 1 : 0
  name        = "dev-ingress-ip"
  description = "IP Address for development environment's k8s Ingress"
}

resource "google_compute_global_address" "qa-ingress" {
  count       = var.ingress-ip-addresses == true ? 1 : 0
  name        = "qa-ingress-ip"
  description = "IP Address for QA environment's k8s Ingress"
}

resource "google_compute_global_address" "prod-ingress" {
  count       = var.ingress-ip-addresses == true ? 1 : 0
  name        = "prod-ingress-ip"
  description = "IP Address for prod environment's k8s Ingress"
}

