https://www.edureka.co/blog/kubernetes-networking/

kc apply -f deploy-webapp.yaml
kc apply -f svc-webapp.yaml
kc apply -f deploy-mysql.yaml
 kc apply -f svc-mysql.yaml


Edit the web Container 
/var/www/html/index.php 
$servername = "webapp-sql1";
$password = "edureka";


Edit the SQL Container:
mysql -uroot -ppassword
CREATE DATABASE ProductDetails;
use ProductDetails
#CREATE TABLE products(product_name VARCHAR(10), product_id VARCHAR(11));
CREATE TABLE emp(name VARCHAR(10), phone VARCHAR(11));



Go to : http://192.168.0.178:32445/



Case Study: Wealth Wizard Using Kubernetes Networking
Wealth Wizards is an online financial planning platform that combines financial planning, and smart software technology to deliver expert advice at an affordable cost.

Challenges
Now, it was extremely important for the company to quickly discover and eliminate code vulnerabilities with full visibility of their cloud environment but wanted to control traffic through access restrictions.
So, they used Kubernetes infrastructure to manage the provisioning and rollout of the clusters with the help of tools to manage the deployment and configuration of microservices across the Kube clusters.
They also used a network policy feature of Kubernetes to allow them to control traffic through access restrictions.
Now, the problem was, these policies are application-oriented and can only evolve with the applications, but, there was no component to enforce these policies.
So, the only solution the company could find for this was to use a network plugin, and hence they started using Weave Net.

Solution
This network plugin creates a virtual network that has a network policy controller to manage and enforce the rules in Kubernetes. Not only this, but it also connects Docker containers across multiple hosts and enables their automatic discovery.
So, suppose you have a workload in the cluster and you want to stop any other workload in the cluster talking to it. You can achieve this by creating a network policy that restricts access and only allows ingress to it via the ingress controller on a specific port.
Now, with his deployment on each Kubernetes node, the plugin manages inter-pod routing and has access to manipulate the IPtables rules. In simple terms, each policy is converted to a collection of IPtables rules, coordinated and configured across each machine to translate the Kubernetes tags.
Alright, now that you have gone through so much theory about Kubernetes Networking, let me show you how is it done practically.

Hands-On
So, with an assumption that all of you have installed Kubernetes on your systems, I have a scenario to showcase.
Suppose you want to store product name and product ID, for that you will need a web application. Basically, you need one container for web application and you need one more container as MySQL for the backend, and that MySQL container should be linked to the web application container. 