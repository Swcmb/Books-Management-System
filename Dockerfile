# 构建阶段
FROM maven:3.8.5-openjdk-8 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
# 修改数据库连接URL为mysql服务名
RUN sed -i 's/jdbc:mysql:\/\/localhost:3306\/library/jdbc:mysql:\/\/mysql:3306\/library/' src/main/resources/book-context.xml
RUN mvn clean package -DskipTests

# 运行阶段
FROM tomcat:9.0-jdk8-openjdk
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080