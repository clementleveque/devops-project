1) Why forbid direct pushes to main?

Direct pushes to main are forbidden to ensure that all changes are reviewed and tested through Pull Requests before being merged. This reduces the risk of introducing bugs and helps maintain a stable and reliable main branch.

2) What is the difference between an image and a container?
A Docker image is a read-only template containing the application, its dependencies, and its environment. A container is a running instance of an image. Multiple containers can be created from the same image.

For the TP :
- Image : myapp:0.1 → modèle de notre application.
- Conteneur : myapp → instance de l'application en cours d'exécution.

3) Compare the size of your image with a non-slim base image. What do you observe?

The Alpine-based image is significantly smaller (177 MB) than the standard Node.js image (1.14 GB), representing approximately an 84.5% size reduction. Alpine uses a minimal Linux distribution, which reduces storage requirements, download times, and deployment overhead. However, some dependencies may have compatibility limitations.

PS C:\Users\Sebastien\devops-project> docker images myapp
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
myapp        full      9bffce4518b4   23 seconds ago   1.14GB
myapp        0.1       45a65a61e949   7 minutes ago    177MB

4) 
