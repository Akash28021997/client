pipeline {
    agent any

    environment {
        BACKEND_DIR = "backend"
        FRONTEND_DIR = "frontend"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                dir("${BACKEND_DIR}") {
                    bat 'npm install'
                }
            }
        }

        stage('Run Backend Tests') {
            steps {
                script {
                    def pkg = readJSON file: 'backend/package.json'
                    if (pkg.scripts?.test && !pkg.scripts.test.contains('no test specified')) {
                        dir("backend") {
                            bat 'npm test'
                        }
                    } else {
                        echo 'Skipping tests: no test script defined in package.json'
                    }
                }
        }
        }

        stage('Install Frontend Dependencies') {
            steps {
                dir("${FRONTEND_DIR}") {
                    bat 'npm install'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir("${FRONTEND_DIR}") {
                    bat 'npm run build'
                }
            }
        }

        stage('Deploy') {
            steps {
                bat 'scripts\\deploy.bat'
            }
        }
    }
}
