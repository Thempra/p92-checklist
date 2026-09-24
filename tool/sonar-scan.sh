#!/bin/bash
# Prepara informes para SonarQube (plugin flutter) y lanza el scan.
# Uso: tool/sonar-scan.sh   (requiere flutter en PATH y red para el escáner)
set -e
cd "$(dirname "$0")/.."

# 1. Coverage LCOV + informe de tests en formato machine (--machine, NO --json)
flutter test --machine --coverage > coverage/test-report.json

# 2. Diagnósticos estáticos del analizador de Dart (formato MACHINE)
dart analyze --format=machine > .dart_analysis.txt || true

# 3. El escáner corre en docker con base /usr/src; el informe de tests
#    trae rutas absolutas del host -> reescribirlas.
sed -i 's|'"$PWD"'|/usr/src|g' coverage/test-report.json

# 4. Escaneo
TOKEN=$(head -n1 ~/.sonar_token 2>/dev/null || echo "$SONAR_TOKEN")
docker run --rm --network host -v "$PWD":/usr/src \
  -e SONAR_HOST_URL=https://sonar.thempra.net -e SONAR_TOKEN="$TOKEN" \
  -m 2g sonarsource/sonar-scanner-cli:latest \
  -Dsonar.projectBaseDir=/usr/src
