pipeline {
    agent any

    environment {
        BACKEND_DIR = "backend"
        FRONTEND_DIR = "frontend"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Install Backend Dependencies') {
            when {
                expression { fileExists("${env.BACKEND_DIR}/package.json") }
            }
            steps {
                dir("${env.BACKEND_DIR}") {
                    echo 'Installing backend dependencies...'
                    script {
                        isUnix() ? sh 'npm install' : bat 'npm install'
                    }
                }
            }
        }

        stage('Run Backend Tests') {
            when {
                expression { fileExists("${env.BACKEND_DIR}/package.json") }
            }
            steps {
                script {
                    def pkg = readJSON file: "${env.BACKEND_DIR}/package.json"
                    if (pkg.scripts?.test && !pkg.scripts.test.contains('no test specified')) {
                        dir("${env.BACKEND_DIR}") {
                            echo 'Running backend tests...'
                            isUnix() ? sh 'npm test' : bat 'npm test'
                        }
                    } else {
                        echo 'Skipping backend tests: no test script defined in package.json'
                    }
                }
            }
        }

        stage('Install Frontend Dependencies') {
            when {
                expression { fileExists("${env.FRONTEND_DIR}/package.json") }
            }
            steps {
                dir("${env.FRONTEND_DIR}") {
                    echo 'Installing frontend dependencies...'
                    script {
                        isUnix() ? sh 'npm install' : bat 'npm install'
                    }
                }
            }
        }

        stage('Build Frontend') {
            when {
                expression { fileExists("${env.FRONTEND_DIR}/package.json") }
            }
            steps {
                dir("${env.FRONTEND_DIR}") {
                    echo 'Building frontend...'
                    script {
                        isUnix() ? sh 'npm run build' : bat 'npm run build'
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                expression { fileExists("scripts/deploy.bat") || fileExists("scripts/deploy.sh") }
            }
            steps {
                echo 'Deploying application...'
                script {
                    if (isUnix()) {
                        sh 'chmod +x scripts/deploy.sh'
                        sh './scripts/deploy.sh'
                    } else {
                        bat 'scripts\\deploy.bat'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution complete.'
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed.'
        }
        unstable {
            echo 'Build unstable.'
        }
    }
}
