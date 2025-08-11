#!/bin/bash

# Namespace de monitoring
NAMESPACE="monitoring"

# Puertos locales
GRAFANA_PORT=3000
PROMETHEUS_PORT=9090

echo "=== 🔄 Iniciando port-forward para Grafana y Prometheus ==="

# Port-forward Grafana
echo "📊 Abriendo Grafana en http://localhost:${GRAFANA_PORT}"
kubectl port-forward -n $NAMESPACE svc/monitoring-grafana ${GRAFANA_PORT}:80 >/dev/null 2>&1 &
GRAFANA_PID=$!

# Port-forward Prometheus
echo "📈 Abriendo Prometheus en http://localhost:${PROMETHEUS_PORT}"
kubectl port-forward -n $NAMESPACE svc/monitoring-kube-prometheus-prometheus ${PROMETHEUS_PORT}:${PROMETHEUS_PORT} >/dev/null 2>&1 &
PROMETHEUS_PID=$!

# Mostrar credenciales de Grafana
echo "👤 Usuario Grafana: admin"
echo -n "🔑 Contraseña Grafana: "
kubectl get secret -n $NAMESPACE monitoring-grafana \
  -o jsonpath="{.data.admin-password}" | base64 -d
echo ""

# Función para cerrar al presionar Ctrl+C
trap "echo '⏹️ Deteniendo port-forward...'; kill $GRAFANA_PID $PROMETHEUS_PID" INT

# Mantener el script vivo
wait
