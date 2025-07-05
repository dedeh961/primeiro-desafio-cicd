APP = api-flask

compose:
	@docker-compose build
	@docker-compose up

setup-dev:
	@kind create cluster --config kubernetes/config/config.yaml
	@helm install my-ingress ingress-nginx/ingress-nginx --set controller.service.type=NodePort --set controller.service.nodePorts.http=30080 --set controller.service.nodePorts.https=30443
	@echo "Aguardando Ingress Controller ficar pronto..."
	@kubectl wait --for=condition=available deployment -l app.kubernetes.io/component=controller --timeout=120s
	@echo "Ingress Controller pronto!"

teardown-dev:
	@kind delete clusters kind

deploy-dev:
	@docker build -t $(APP):latest .
	@kind load docker-image $(APP):latest
	@kubectl apply -f kubernetes/manifests
	@kubectl rollout restart deploy api-flask
	@echo "Aguardando Deployment da aplicacao ficar pronto..."
	@kubectl rollout status deployment/$(APP)

dev: setup-dev deploy-dev

dev-helm: setup-dev deploy-dev-helm
