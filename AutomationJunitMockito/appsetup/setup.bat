@echo off

cls
echo[
echo[
echo --------- Automation: Junits + Mocks for your Maven based SpringBoot application --------
echo[
echo Pre-requisites:
echo   1- Springboot application that starts up successfully with   "mvn clean install"
echo   2- JDK 8/higher and Maven local setup.
echo[
echo   3- Reference POM for you:
echo            \AutomationJunitMockito\appsetup\templates\pom-junit-mockito-template.xml 
echo		   section "Junit Mockito Mandatory" [Junit + Mockito + +Jacoco + Starter dependencies]
echo   4- Reference test application for you:
echo            test-projects/junit-automation    [Github]
echo[
echo   5- BACKUP your application so that you can reinstate the original state if required.
pause


REM set environment variables
set MODE=autogen

echo[
echo[
echo Step-1 ----Gather information - application
set APP_SETUP_DIR=%cd%
echo            Please provide the local path of your Maven based SpringBoot application:
echo            This path contains your pom.xml.
echo            for eg. 
echo              C:\Vijay\Java\projects\junit-mockito-mgt\test-projects\junit-automation
set /p "APP_BASE_PATH="


echo[
echo[
echo Step-2 ----Gather information - Springboot
echo            Please provide the full directory path of your Springboot Application Main class:
echo            for eg. 
echo              C:\Vijay\Java\projects\junit-mockito-mgt\test-projects\junit-automation\src\main\java\com\banknext\customer\mgt
set /p "APP_MAIN_CLASS_DIR="


echo[
echo[
echo Step-3 ----Gather User Preference
echo            1- Auto generate the Junits for my application.
echo            2- Only run the Junits. I have already auto generated under
set RUN_AUTO_GEN_JUNITS_PATH=%APP_MAIN_CLASS_DIR:main=test%
set RUN_AUTO_GEN_JUNITS_PATH=%RUN_AUTO_GEN_JUNITS_PATH%\automation\junit
echo               %RUN_AUTO_GEN_JUNITS_PATH%
set /p "USER_PREF="

set RUN_AUTO_GEN_JUNITS_PATH=%RUN_AUTO_GEN_JUNITS_PATH:*src\test\java\=%

REM echo               %RUN_AUTO_GEN_JUNITS_PATH%      
set RUN_AUTO_GEN_JUNITS_PATH=%RUN_AUTO_GEN_JUNITS_PATH:\=.%
REM set RUN_AUTO_GEN_JUNITS_PATH_ALL=%RUN_AUTO_GEN_JUNITS_PATH%.automation.junit.*.*
set RUN_AUTO_GEN_JUNITS_PATH_ALL=%RUN_AUTO_GEN_JUNITS_PATH%.*.*


IF %USER_PREF%==2 (   
   set MODE=autorun
   cd %APP_BASE_PATH%
    echo            Launching All auto generated Junits
    mvn test -Dtest=%RUN_AUTO_GEN_JUNITS_PATH_ALL% -Djacoco.haltOnFailure=false
   echo[
   echo[
   echo Launching Jacoco code coverage report.
   echo Jacoco will create this report ONLY if there are no test errors/failures.
   timeout /t 5 /nobreak
   start file:///%APP_BASE_PATH%/target/site/jacoco/index.html
   echo Process complete. Press any key to exit.
   pause
   echo Exiting ...
   timeout /t 5 /nobreak
   REM exit
)


cls 


echo[
echo[
echo Step-5 ----Gather target class information
echo            Please provide the fully qualified Class name for which you wish to create the Junits:
echo            for eg. 
echo              com.banknext.customer.mgt.controller.CustomerMgtControllerType1
set /p "TARGET_CLASS="
echo Step-5 complete

cls 


echo[
echo[
echo Step-6 ----Preparing automation env
set AUTOMATION_PREP_PATH=%APP_MAIN_CLASS_DIR%\automation\
echo        DELETING remnants of older automation run from -
echo        %AUTOMATION_PREP_PATH%
echo        If you DO NOT WISH to proceed then TERMINATE this console OTHERWISE press any key to CONFIRM deletion
pause
rmdir /s /q %AUTOMATION_PREP_PATH%
timeout /t 5 /nobreak
echo Step-6 complete


echo[
echo[
echo Step-7A ----Creating automation env - detect SpringBoot spec
cd %APP_BASE_PATH%
call mvn dependency:tree -Dincludes=org.springframework.boot:spring-boot-starter > app-dependencies-output.txt
echo Dependency info saved at %APP_BASE_PATH%\app-dependencies-output.txt


echo[
echo[
echo Step-7B ----Creating automation env - detect Maven spec
cd %APP_BASE_PATH%
call mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.build.finalName -q -DforceStdout > maven-artifacts-output.txt
set /p MAVEN_ARTIFACT_FINAL_NAME=<maven-artifacts-output.txt
echo MAVEN_ARTIFACT_FINAL_NAME:            %MAVEN_ARTIFACT_FINAL_NAME%

call mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.artifactId -q -DforceStdout > maven-artifacts-output.txt
set /p MAVEN_ARTIFACT_ID=<maven-artifacts-output.txt
echo MAVEN_ARTIFACT_ID:                    %MAVEN_ARTIFACT_ID%

call mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DforceStdout > maven-artifacts-output.txt
set /p MAVEN_ARTIFACT_VERSION_ID=<maven-artifacts-output.txt
echo MAVEN_ARTIFACT_VERSION_ID:            %MAVEN_ARTIFACT_VERSION_ID%


echo[
echo[
echo Step-7C ----Creating automation env - copy automation artifacts
cd %APP_SETUP_DIR%
REM javac AutomationPrep.java
java AutomationPrep %APP_SETUP_DIR% %APP_BASE_PATH% %APP_MAIN_CLASS_DIR% %TARGET_CLASS%
set AUTOMATION_TEMPLATES_PATH=%APP_MAIN_CLASS_DIR%\automation\templates
echo        Automation templates path set to:
echo        %AUTOMATION_TEMPLATES_PATH%
echo Step-7 Complete



echo[
echo[
echo Step-8 ----Core processing will launch in new window. Once it completes press any key to continue ..

REM for /r %APP_BASE_PATH% %%i in (*.jar) do set "APP_JAR_NAME=%%~ni"
REM start cmd /k "cd %APP_BASE_PATH% & mvn clean install -DskipTests=true -Pkafka,mongodb,redis,avro,hive & java -jar %APP_BASE_PATH%\target\%APP_JAR_NAME%.jar"
start cmd /k "cd %APP_BASE_PATH% & mvn clean install -DskipTests=true -Pkafka,mongodb,redis,avro,hive & java -jar %APP_BASE_PATH%\target\%MAVEN_ARTIFACT_FINAL_NAME%.jar"
set /p "AWAIT_PRESS_KEY_ANY="
set AUTO_GEN_JUNITS_PATH=%APP_MAIN_CLASS_DIR%\automation\junit 
set AUTO_GEN_JUNITS_PATH=%AUTO_GEN_JUNITS_PATH:main=test%
REM echo Step-8 complete

cls 


echo[
echo[
echo Step-9 ----Review
echo            Your auto generated Junits are saved at the below location. Please REVIEW/ADJUST/CORRECT as you see fit and only then proceed further.
echo            %AUTO_GEN_JUNITS_PATH%
rmdir /s /q %AUTOMATION_PREP_PATH%
echo            Launch auto-generated Junits ? [Y/N]:

for %%a in (%TARGET_CLASS:.= %) do set CLASS_NAME=%%a

set /p "LAUNCH_JUNITS="
IF %LAUNCH_JUNITS%==Y (
   echo Launching auto-generated Junits
   set MODE=autorun
   cd %APP_BASE_PATH%

   echo %CLASS_NAME%Test
   mvn test -Dtest=%CLASS_NAME%Test -Djacoco.haltOnFailure=false

   echo[
   echo Launching Jacoco code coverage report.
   echo Jacoco will create this report ONLY if there are no test errors/failures.

   timeout /t 5 /nobreak
   start file:///%APP_BASE_PATH%/target/site/jacoco/index.html
)

echo Process complete. Exiting ..