

# STEP 1
- bastionInstance.tf
- ecr.tf
- eks-cluster.tf
- gatewat,tf
- key-pair.tf
- nodegroup.tf
- provider.tf
- rds.tf
- route_table.tf
- securityGroup.tf
- subnet.tf
- user-data.sh
- variables.tf
- vpc.tf
- web-asg.tf
- web-lanch-conjfiguration.tf
- web-lb.tf
  terraform apply실행
# STEP 2
- terraform control server내
  aws eks update-kubeconfig --region {region} --name was
  controll panel 지정
- App sourceFile ROOT.war
- docker iamge 필요
- docker build -t was:latest .
- docker run -d -p 8080:8080 was:latest
- docker cp ROOT.war {containerID}:/usr/local/tomcat/webapps
- docker exec -it {containerID} bash
- /usr/local/tomcat/webapps/ROOT/WEB-INF/spring/root-context.xml에서 RDS 설정에 맞춰 url 변경
- aws ecr get-login-password --region us-east-2 | sudo docker login --username AWS --password-stdin {ecr-url}
- 이후 docker stop commit tag push를 통해 ECR에 이미지 배포

# STEP 3
- alb.tf (image url Region 변경 필요)
- applicatoin.tf
- cloudfront.tf
- prometheus.tf
- prometheus_values.yaml
  해당 파일 추가 후 terraform apply
  이후 생성된 was loadBalancer의 url을 user-data.sh에서 변경후 terraform apply



> Written with [StackEdit](https://stackedit.io/).