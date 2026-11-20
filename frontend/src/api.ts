export const API_URL: string =
  (import.meta.env.VITE_API_URL as string | undefined) ?? "http://localhost:8000";

// ---- tipos (espelham app/schemas.py do back-end) -------------------------
export interface UserPublic {
  id: number;
  nome: string;
  avatar: string;
}
export interface UserMe extends UserPublic {
  email: string;
}
export type CampaignStatus = "aberta" | "lotada" | "finalizada";
export interface Campaign {
  id: number;
  nome: string;
  descricao: string;
  discord: string;
  tags: string[];
  status: CampaignStatus;
  vagas_total: number;
  vagas_restantes: number;
  mestre: UserPublic;
  membros: UserPublic[];
  criado_em: string;
  finalizada_em: string | null;
}
export interface CampaignInput {
  nome: string;
  descricao: string;
  discord: string;
  vagas_total: number;
  tags: string[];
}
export interface Invite {
  id: number;
  status: "pendente" | "aceito" | "recusado";
  campaign_id: number;
  campaign_nome: string;
  user: UserPublic;
  criado_em: string;
}
export interface ChatMessage {
  id: number;
  campaign_id: number;
  user: UserPublic;
  texto: string;
  criado_em: string;
}

// ---- infraestrutura -------------------------------------------------------
export class ApiError extends Error {
  constructor(public status: number, message: string) {
    super(message);
  }
}

let token: string | null = localStorage.getItem("token");
let onUnauthorized: (() => void) | null = null;

export const getToken = () => token;
export function setToken(t: string | null) {
  token = t;
  if (t) localStorage.setItem("token", t);
  else localStorage.removeItem("token");
}
export function setUnauthorizedHandler(fn: () => void) {
  onUnauthorized = fn;
}

function messageFrom(data: unknown, fallback: string): string {
  const detail = (data as { detail?: unknown } | null)?.detail;
  if (typeof detail === "string") return detail;
  if (Array.isArray(detail)) {
    // erros de validação (422): [{loc: [...], msg: "..."}]
    return detail
      .map((d: { loc?: unknown[]; msg?: string }) => `${d.loc?.slice(1).join(".") ?? ""}: ${d.msg ?? ""}`)
      .join("; ");
  }
  return fallback;
}

async function request<T>(method: string, path: string, body?: unknown): Promise<T> {
  let res: Response;
  try {
    res = await fetch(API_URL + path, {
      method,
      headers: {
        ...(body !== undefined ? { "Content-Type": "application/json" } : {}),
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: body !== undefined ? JSON.stringify(body) : undefined,
    });
  } catch {
    throw new ApiError(0, "Não foi possível conectar ao servidor");
  }
  if (res.status === 204) return undefined as T;
  const data = await res.json().catch(() => null);
  if (!res.ok) {
    if (res.status === 401 && token) onUnauthorized?.();
    throw new ApiError(res.status, messageFrom(data, `Erro ${res.status}`));
  }
  return data as T;
}

// ---- endpoints ------------------------------------------------------------
export const api = {
  register: (nome: string, email: string, senha: string) =>
    request<{ access_token: string }>("POST", "/auth/register", { nome, email, senha }),
  login: (email: string, senha: string) =>
    request<{ access_token: string }>("POST", "/auth/login", { email, senha }),

  me: () => request<UserMe>("GET", "/me"),
  updateMe: (d: Partial<{ nome: string; email: string; avatar: string }>) =>
    request<UserMe>("PATCH", "/me", d),
  myCampaigns: (o: { papel?: "mestre" | "jogador"; finalizadas?: boolean } = {}) => {
    const p = new URLSearchParams();
    if (o.papel) p.set("papel", o.papel);
    if (o.finalizadas) p.set("finalizadas", "true");
    return request<Campaign[]>("GET", `/me/campaigns?${p}`);
  },
  myInvites: () => request<Invite[]>("GET", "/me/invites"),

  campaigns: (q?: string) =>
    request<Campaign[]>("GET", "/campaigns" + (q ? `?q=${encodeURIComponent(q)}` : "")),
  campaign: (id: number) => request<Campaign>("GET", `/campaigns/${id}`),
  createCampaign: (d: CampaignInput) => request<Campaign>("POST", "/campaigns", d),
  updateCampaign: (id: number, d: Partial<CampaignInput>) =>
    request<Campaign>("PATCH", `/campaigns/${id}`, d),
  deleteCampaign: (id: number) => request<void>("DELETE", `/campaigns/${id}`),
  finishCampaign: (id: number) => request<Campaign>("POST", `/campaigns/${id}/finish`),
  leaveCampaign: (id: number) => request<Campaign>("POST", `/campaigns/${id}/leave`),
  kickMember: (id: number, userId: number) =>
    request<Campaign>("DELETE", `/campaigns/${id}/members/${userId}`),
  sendInvite: (id: number) => request<Invite>("POST", `/campaigns/${id}/invites`),
  acceptInvite: (id: number) => request<Campaign>("POST", `/invites/${id}/accept`),
  rejectInvite: (id: number) => request<void>("POST", `/invites/${id}/reject`),
  messages: (id: number) => request<ChatMessage[]>("GET", `/campaigns/${id}/messages`),
};

export function chatUrl(campaignId: number): string {
  // API_URL pode ser absoluto (http://host:8000) ou relativo (/api, atrás de um proxy).
  const base = API_URL.startsWith("/")
    ? `${location.protocol === "https:" ? "wss" : "ws"}://${location.host}${API_URL}`
    : API_URL.replace(/^http/, "ws");
  return `${base}/ws/campaigns/${campaignId}/chat?token=${encodeURIComponent(token ?? "")}`;
}
