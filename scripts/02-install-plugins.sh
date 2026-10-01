#!/usr/bin/env bash
# Installs the plugins listed in templates/plugins.txt using the Jenkins plugin CLI.
# Usage: JENKINS_USER=admin JENKINS_TOKEN=<api-token> ./02-install-plugins.sh
set -euo pipefail
cd "$(dirname "$0")/.."

URL="${JENKINS_URL:-http://localhost:8080}"
: "${JENKINS_USER:?set JENKINS_USER}" "${JENKINS_TOKEN:?set JENKINS_TOKEN}"

curl -fsSL "$URL/jnlpJars/jenkins-cli.jar" -o /tmp/jenkins-cli.jar
mapfile -t PLUGINS < <(grep -v '^\s*#' templates/plugins.txt | grep -v '^\s*$')
java -jar /tmp/jenkins-cli.jar -s "$URL" -auth "$JENKINS_USER:$JENKINS_TOKEN" \
  install-plugin "${PLUGINS[@]}"
java -jar /tmp/jenkins-cli.jar -s "$URL" -auth "$JENKINS_USER:$JENKINS_TOKEN" safe-restart
