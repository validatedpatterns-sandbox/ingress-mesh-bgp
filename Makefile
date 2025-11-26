EXTRA_VARS ?=

ifeq ($(wildcard overrides.yml),overrides.yml)
    EXTRA_ARGS := -e @./overrides.yml
else
    EXTRA_ARGS :=
endif
.PHONY: default
default: help

## @AWS Infrastructure tasks
.PHONY: bgp-routing
bgp-routing: ## Sets up the BGP routing with a client ec2 in aws
	cd ansible && ansible-playbook -i hosts $(EXTRA_ARGS) $(EXTRA_VARS) playbooks/router.yml


.PHONY: bgp-routing-cleanup
bgp-routing-cleanup: ## Cleans up the BGP routing with a client ec2 in aws
	cd ansible && ansible-playbook -i hosts $(EXTRA_ARGS) $(EXTRA_VARS) playbooks/router-cleanup.yml

.PHONY: import
import: ## Imports SPOKECONFIG into HUBCONFIG defined clusters
	cd ansible && ansible-playbook -i hosts $(EXTRA_ARGS) $(EXTRA_VARS) playbooks/import-cluster.yml

.PHONY: help
##@ Pattern tasks

# No need to add a comment here as help is described in common/
help:
	@make -f common/Makefile MAKEFILE_LIST="Makefile common/Makefile" help

%:
	make -f common/Makefile $*

.PHONY: install
install: operator-deploy post-install ## installs the pattern and loads the secrets
	@echo "Installed"

.PHONY: post-install
post-install: ## Post-install tasks
	make load-secrets
	@echo "Done"

.PHONY: test
test:
	@make -f common/Makefile PATTERN_OPTS="-f values-global.yaml -f values-hub.yaml" test
