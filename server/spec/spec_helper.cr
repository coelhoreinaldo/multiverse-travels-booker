require "spec"
require "spec-kemal"
require "../src/app"

Spec.before_each do
  # Inicia uma transação de banco de dados antes de cada teste
  Jennifer::Adapter.default_adapter.begin_transaction
end

Spec.after_each do
  # Desfaz a transação de banco de dados após cada teste
  Jennifer::Adapter.default_adapter.rollback_transaction
end
