# directory
SERVER_DIR	:= ./server
DEPLOY_DIR	:= $(SERVER_DIR)/deployment
MODS_DIR	:= ./mods

# k8s
K8S_NAMESPACE	:= minetest

### help ###

.PHONY: help
help: ## display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

### server ###

.PHONY: deploy
deploy: ## deploy minetest server
	@kubectl apply -f $(DEPLOY_DIR)/config.yml -f $(DEPLOY_DIR)/data.yml -f $(DEPLOY_DIR)/deploy.yml -f $(DEPLOY_DIR)/namespace.yml -f $(DEPLOY_DIR)/service.yml

.PHONY: undeploy
undeploy: ## undeploy minetest server
	@kubectl delete all --all --namespace $(K8S_NAMESPACE)
	@kubectl delete cm --all --namespace $(K8S_NAMESPACE)
	@kubectl delete pvc --all --namespace $(K8S_NAMESPACE)
	@kubectl delete pv minetest-data

.PHONY: copy-mods
copy-mods: ## copy mods to minetest server
	@kubectl cp $(MODS_DIR) --namespace $(K8S_NAMESPACE) $(shell kubectl get pod --namespace $(K8S_NAMESPACE) --selector app=minetest -o jsonpath="{.items[0].metadata.name}"):/var/lib/minetest/.minetest
