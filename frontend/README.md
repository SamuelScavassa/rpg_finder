# RPG Finder — Web (React)

React 18 + TypeScript + Vite + React Router. Consome a API em `../backend`.

```bash
# Node 18+ (ex.: sudo apt install nodejs npm, ou nvm)
npm install
cp .env.example .env     # VITE_API_URL=http://localhost:8000
npm run dev              # http://localhost:5173
npm run build            # checa tipos (tsc) e gera dist/
```

O back-end libera CORS para `http://localhost:5173` por padrão (`CORS_ORIGINS`).

## Telas (Flutter → React)

| Flutter                                              | Rota React                          |
|------------------------------------------------------|-------------------------------------|
| `login`, `cadastro`                                  | `/login`, `/cadastro`               |
| `feed`, `resultadoPesquisa`                          | `/` e `/?q=tag1 tag2`               |
| `create-campanha`                                    | `/campanhas/nova`, `/campanhas/:id/editar` |
| `details-campanha`, `detailsCampanhaAtivas`, `detailsCampanhasParticipando`, `chatView` | `/campanhas/:id` (ações e chat variam por papel) |
| `campanhasAtivas`, `campanhasParticipando`           | `/minhas?papel=mestre\|jogador`     |
| `convites`                                           | `/convites`                         |
| `historicoCampanha`                                  | `/historico`                        |
| `user-home`, `user-update`                           | `/perfil`                           |

## Notas

- O token JWT fica no `localStorage` (simples, mas exposto a XSS). Para mais segurança, mover para cookie `HttpOnly` exige ajustes no back-end.
- O chat usa WebSocket (`/ws/campaigns/:id/chat?token=`); o token vai na query string, então evite logar URLs do servidor.
