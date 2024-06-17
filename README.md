# Unikorn Stack All-in-One Helm Chart

![Unikorn Logo](https://raw.githubusercontent.com/unikorn-cloud/assets/main/images/logos/light-on-dark/logo.svg#gh-dark-mode-only)
![Unikorn Logo](https://raw.githubusercontent.com/unikorn-cloud/assets/main/images/logos/dark-on-light/logo.svg#gh-light-mode-only)

For non-power users, or those who don't want to develop in the [efficient way](https://github.com/unikorn-cloud/scripts/), this allows you a very simple method of getting started.

## Prerequisites

For all deployments you need:

* Jetstack cert-manager
* ArgoCD
* An ingress controller

For production deployments you'll most likely want:

* A cert-manager cluster issuer for something like Let's Encrypt
* Kubernetes external-dns

The would advice would be against that, preferring to separate components into separate namespaces to make management less error prone due to sensory overload.

## Installation

### Developers

For a standard developer edition you'll want a `values.yaml` that looks like:

```yaml
global:
  ingress:
    # Use the core self-signed CA.
    clusterIssuer: unikorn-issuer
  ca:
    # Define where services can find the CA for TLS verification.
    secretNamespace: cert-manager
    secretName: unikorn-ca
  identity:
    host: identity.my-domain.com
  region:
    host: region.my-domain.com
  kubernetes:
    host: kubernetes.my-domain.com
  ui:
    host: ui.my-domain.com

unikorn-identity:
  clients:
  # Note this name is used later to tie it to the UI.
  - name: my-client
    redirectURL: https://ui.my-domains.com/oauth2/callback
    loginURI: https://ui.my-domains.com/login

  providers:
  - name: google
    description: Google Identity
    type: google
    issuer: https://accounts.google.com
    clientID: PROVIDED_BY_GOOGLE
    clientSecret: PROVIDED_BY_GOOGLE

unikorn-region:
  regions:
  - name: my-region
    provider: openstack
    openstack:
      endpoint: https://openstack.my-domain.com:5000
      serviceAccountSecret:
        name: my-region-credentials

unikorn-ui:
  oauth2:
    # Refers to a client defined for identity.
    clientName: my-client
```

To actually use this, extract the CA from the secret alluded to earlier and install it in your browser.
Ensure `/etc/hosts` entries are added for all the service names defined in the `global` section, you can grab the IP address from `kubectl get ingresses -A`.

### Production

Very few changes, just add the following.

```yaml
global:
  ingress:
    clusterIssuer: lets-encrypt-production
    externalDNS: true
```
