# Anoar CRM

CRM SaaS multi-tenant em PHP 8.3+ e MySQL 8.

## Escopo inicial
- Empresas (tenants) isoladas por `tenant_id`
- Autenticação e membros por tenant
- Cadastro de contatos, temperatura fria/morna/quente
- Futura prospecção, importação e scraping conforme regras das fontes e LGPD
- Futuro funil de vendas e automações

## Arquitetura
PHP sem framework, Composer/PSR-4, PDO, MySQL, front controller em `public/`, services e repositórios.

> Projeto em construção. Não publicar sem configurar ambiente, HTTPS e revisar controles de segurança.
