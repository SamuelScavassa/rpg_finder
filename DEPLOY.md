# Deploy em um servidor Linux

Sobe tudo com um comando: Postgres, API, front e HTTPS automático (Caddy).

```
Internet ─▶ Caddy (80/443) ─┬─ /api/*  ─▶ backend (FastAPI) ─▶ db (Postgres)
                            └─ resto   ─▶ frontend (nginx, arquivos estáticos)
```

Só o Caddy publica portas (80, 443). O Postgres e a API ficam numa rede interna do Docker.

## 1. Servidor

Qualquer Ubuntu/Debian com ~1 GB de RAM (2 GB é mais confortável para o build do front).

```bash
# Docker + Compose (script oficial)
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER   # sai e entra de novo na sessão

# Firewall: só SSH, HTTP e HTTPS
sudo ufw allow OpenSSH && sudo ufw allow 80,443/tcp && sudo ufw allow 443/udp && sudo ufw enable
```

No painel da nuvem, libere também as portas 80 e 443 (security group).

## 2. Domínio

Crie um registro DNS **tipo A** apontando seu domínio (ex.: `rpg.exemplo.com`) para o IP do servidor.
O Caddy só consegue emitir o certificado depois que o DNS estiver propagando para esse IP.
Sem domínio? Veja "Teste só por IP" abaixo.

## 3. Subir

```bash
git clone <seu-repositorio> rpg-finder && cd rpg-finder     # ou envie a pasta com rsync/scp
cp .env.example .env
nano .env       # DOMAIN, PUBLIC_URL, POSTGRES_PASSWORD, JWT_SECRET
                # gere as senhas com:  openssl rand -hex 32

docker compose up -d --build
docker compose ps               # todos "running"/"healthy"
docker compose logs -f backend  # acompanhar
```

Abra `https://seu-dominio`. A documentação da API fica em `https://seu-dominio/api/docs`.

### Teste só por IP (sem HTTPS)

No `.env`: `DOMAIN=:80` e `PUBLIC_URL=http://IP-DO-SERVIDOR`. Sem HTTPS, senhas e tokens trafegam
em texto puro: use apenas para testar.

## 4. Operação

```bash
# Atualizar após mudar o código
git pull && docker compose up -d --build

# Logs / reiniciar um serviço
docker compose logs -f --tail=100 backend
docker compose restart backend

# Backup do banco (rode também por cron, ex.: diariamente)
docker compose exec -T db pg_dump -U rpg rpg_finder | gzip > backup_$(date +%F).sql.gz

# Restaurar
gunzip -c backup_AAAA-MM-DD.sql.gz | docker compose exec -T db psql -U rpg rpg_finder
```

Os dados ficam no volume `pgdata`; `docker compose down` **mantém** os dados, `down -v` **apaga**.
Guarde também o volume `caddy_data` (certificados): apagá-lo repetidamente pode bater no limite de
emissões do Let's Encrypt.

## Pontos de atenção

- **Sem migrações:** o back-end cria as tabelas no startup (`create_all`), mas **não altera** tabelas
  existentes. Antes de mudar o schema com dados em produção, adicione Alembic.
- **Uma única instância da API:** as salas do chat ficam em memória. Para escalar para várias
  instâncias é preciso Redis pub/sub.
- **Segredos:** o `.env` não deve ir para o git (já está no `.gitignore`). A API se recusa a subir em
  produção com `JWT_SECRET` fraco.
