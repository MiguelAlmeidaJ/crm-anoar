# Decisões iniciais

## Multi-tenancy
Banco MySQL compartilhado, separação lógica por `tenant_id`.
Somente um serviço de autenticação autorizado pode selecionar o tenant ativo após
validar `tenant_users`. Nunca usar `tenant_id` recebido diretamente de
parâmetros HTTP como contexto de autorização. Toda consulta, update e delete
de registros comerciais deve exigir tenant_id.

## Segurança
- Usar password_hash/password_verify e regeneração de sessão ao autenticar.
- Definir cookies Secure, HttpOnly e SameSite, CSRF para ações mutáveis.
- Validar autorização por papel e tenant em cada rota.
- Usar prepared statements e escaping na interface.
- Impedir exposição de `.env` servindo somente o diretório `public/`.
- Cobrir isolamento entre tenants com testes antes de disponibilizar endpoints.

## Scraping
Implementar como jobs assíncronos com limitação de taxa, respeito a termos de
uso/robots quando aplicável, LGPD e rastreabilidade da fonte e finalidade.
Evitar acessar áreas autenticadas, contornar controles ou coletar dados sensíveis.
