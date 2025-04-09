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
                    script {
                        if (isUnix()) {
                            sh 'npm install'
                        } else {
                            bat 'npm install'
                        }
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
                            if (isUnix()) {
                                sh 'npm test'
                            } else {
                                bat 'npm test'
                            }
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
                    script {
                        if (isUnix()) {
                            sh 'npm install'
                        } else {
                            bat 'npm install'
                        }
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
                    script {
                        if (isUnix()) {
                            sh 'npm run build'
                        } else {
                            bat 'npm run build'
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                expression {
                    return fileExists('scripts/deploy.sh') || fileExists('scripts/deploy.bat')
                }
            }
            steps {
                script {
                    echo 'Deploying application...'
                    if (isUnix() && fileExists('scripts/deploy.sh')) {
                        sh 'chmod +x scripts/deploy.sh'
                        sh './scripts/deploy.sh'
                    } else if (!isUnix() && fileExists('scripts\\deploy.bat')) {
                        bat 'scripts\\deploy.bat'
                    } else {
                        echo 'No deploy script found for this OS.'
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
            echo '🎉 Build succeeded!'
        }
        failure {
            echo '❌ Build failed.'
        }
        unstable {
            echo '⚠️ Build unstable.'
        }
    }
}
