# Overview

The purpose of this repository is to demonstrate a CICD flow using a build-up of Binary Authorization Attestations with multiple Attestors

## Requirements

* GCP Project ID where the project has an active billing account associated with it

## Resource Usage

This repository creates 3 GKE instances.  Each instance is a small GKE instance and are **NOT** intended to be ready for production.  The purpose is to demonstrate a deployment sequence, NOT how to configure GKE clusters

## Flow

```mermaid
sequenceDiagram
    participant B as Build Attestor
    participant S as Security Attestor
    participant D as Developer/Person
    participant Q as QA Attestor
    participant P as Prod Cluster

    D->>B: Submit Code
    Note left of D: Write Code

    B->>S: Build Image
    Note right of B: Tests Pass
    Note right of B: Create Attestation

    S->>D: Run CVE Tests
    Note right of S: Create Attestation
    Note right of S: Deploy to DEV

    D->>Q: Dev Ready for QA
    Note right of D: Trigger Manual Deploy

    Q->>P: QA Verify
    Note right of Q: Trigger Prod Deploy
    Note right of Q: Create Attestation

    P-->>Q: Reject
    Note right of Q: If Not All<br/>Attestations, reject

```