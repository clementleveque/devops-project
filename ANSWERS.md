1) What is the role of a namespace? Does it provide strong security isolation by itself?

A Kubernetes namespace organizes resources into separate logical environments within the same cluster. It helps manage resources and access permissions. However, namespaces alone do not provide strong security isolation. Additional mechanisms such as RBAC, NetworkPolicies and resource quotas are required.

2) Why does Kubernetes recreate the deleted pod? Which component is responsible?

Kubernetes recreates the deleted Pod because the Deployment specifies a desired state of three replicas. The ReplicaSet controller detects that the actual number of Pods is below the desired number and automatically creates a replacement Pod.

3) What is the difference between a readiness and a liveness probe? What happens to traffic when readiness fails?

A readiness probe checks whether a container is ready to receive traffic, while a liveness probe checks whether it is still functioning correctly. When readiness fails, Kubernetes removes the Pod from the Service's ready endpoints, preventing new traffic from being routed to it. When liveness fails repeatedly, Kubernetes restarts the container.

4) Is a Kubernetes Secret encrypted by default? How would you improve this?

Kubernetes Secrets are not encrypted at rest by default. Their values are Base64-encoded, which is not encryption. Security can be improved by enabling encryption at rest, restricting access with RBAC, and using an external secrets manager.

5) How does this pattern help with hybrid/multi-cloud deployments? What would differ between a real on-prem cluster and a cloud cluster?

Kustomize enables hybrid and multi-cloud deployments by reusing a common Kubernetes configuration (base) while adapting specific settings through overlays.

This ensures consistency across environments, reduces configuration duplication, and simplifies maintenance.

In a real deployment, on-premises and cloud clusters would differ mainly in their infrastructure, networking, storage, security configurations, and resource availability. Cloud environments typically use managed Kubernetes services and cloud-native load balancers, while on-premises environments require more manual infrastructure management.

6) Why did the broken rollout not take down the application?

Kubernetes uses a Rolling Update strategy to progressively replace old Pods with new ones. When the new image failed to start, the new Pod never became ready. Kubernetes therefore kept the three existing healthy Pods running, preventing service interruption.

7) How can we trace a running Pod back to the source code, CI/CD pipeline and code review?

A running Pod can be traced back to its ReplicaSet and Deployment using kubectl describe and Kubernetes owner references.

In our production environment, the Deployment contains annotations identifying the Git commit (369b1fb), the GitHub Actions pipeline run, the responsible team (team-a) and the associated ticket (OPS-123).

The container image tag matches the Git commit SHA. The corresponding GitHub Actions workflow completed successfully and published the Docker image to GHCR.

The commit is linked to Pull Request #1, which was merged into the main branch. However, no reviewer is recorded for this Pull Request.

This provides traceability between the running application, source code and CI/CD execution. For stronger reliability, deployment annotations should be generated automatically by the CI/CD pipeline rather than added manually.

8) Why is manual kubectl edit in production a traceability risk?

Using kubectl edit directly in production bypasses the Git and CI/CD workflow. Changes may be applied without a Git commit, Pull Request review, or automated validation.

This creates configuration drift between the Kubernetes cluster and the manifests stored in the repository. It also makes it harder to understand why a change was made, reproduce it, or safely roll it back.

Although Kubernetes audit logs can record who performed the modification and when, they do not replace Git history and code reviews.

A better approach is to manage configuration changes through version-controlled manifests, reviewed Pull Requests, and automated deployment pipelines, following GitOps principles.