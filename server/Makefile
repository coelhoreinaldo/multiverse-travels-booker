# === Sam shortcut
# The following lines are autogenerated and any changes will be
# discarded if Sam regenerates this file.
CRYSTAL_BIN = crystal
CRYSTAL_PATH := $(if $(shell command -v $(CRYSTAL_BIN) 2>/dev/null),$(shell command -v $(CRYSTAL_BIN) 2>/dev/null),$(error '`$(CRYSTAL_BIN)` not found, please install it and/or ensure it is in your PATH'))
SAM_PATH ?= "sam.cr"
.PHONY: sam
sam:
	$(CRYSTAL_PATH) $(SAM_PATH) $(filter-out $@,$(MAKECMDGOALS))
%:
	@:
# === Sam shortcut

# Define o ambiente de desenvolvimento de testes, cria o bancos e gera as migrations, define a porta 3001 para rodar os testes e depois dropa o banco.
run_test:
	APP_ENV=test make sam db:setup && APP_ENV=test PORT=3001 KEMAL_ENV=test crystal spec && APP_ENV=test make sam db:drop
	
run_unit_test:

	APP_ENV=test make sam db:setup && APP_ENV=test PORT=3001 KEMAL_ENV=test crystal spec/units/travel_plan_service_spec.cr && PORT=3001 KEMAL_ENV=test crystal spec/units/app_unit_spec.cr && APP_ENV=test make sam db:drop

run_integration_test:
	APP_ENV=test make sam db:setup && APP_ENV=test PORT=3001 KEMAL_ENV=test crystal spec/integration/app_spec.cr && APP_ENV=test make sam db:drop

# Quando em desenvolvimento, usar o comando abaixo criar o banco de dados e rodar o servidor.
start:
	shards install && make sam db:setup && crystal src/app.cr