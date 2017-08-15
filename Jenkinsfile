#!/usr/bin/groovy

// // Load shared library
// @Library('github.com/camptocamp/c2c-pipeline-library@master') import static com.camptocamp.utils.*

pipeline {
  agent {
    // run with the custom geomapfish slave
    // will dynamically provision a new pod on Openshift
    label 'geomapfish'
  }

  stages {
    stage('build') {
      // TODO
      steps {
        sh returnStdout: true, script: 'rm -rf node_modules || true'
        sh returnStdout: true, script: 'ln -s /usr/lib/node_modules .'
        sh returnStdout: true, script: 'make build'
      }
    }

    stage('deploy-staging') {
      steps {
        sh 'ls'
        // TODO
      }
    }

    stage('deploy-preprod') {
      steps {
        sh 'pwd'
        // TODO
      }
    }

    stage('deploy-prod') {
      steps {
        sh 'pwd'
      }
    }
  }
}