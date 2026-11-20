import { Link } from "react-router-dom";
import { Campaign, UserPublic } from "../api";

export function Avatar({ user, size = 40 }: { user: UserPublic; size?: number }) {
  // Dados migrados do Firestore podem vir como "images/avatar01.jpg".
  const file = user.avatar.split("/").pop() || "avatar01.jpg";
  return (
    <img className="avatar" src={`/images/${file}`} alt={user.nome} width={size} height={size} />
  );
}

export function Tags({ tags }: { tags: string[] }) {
  if (!tags.length) return <p className="muted">Não tem tags essa campanha</p>;
  return (
    <div className="tags">
      {tags.map((t) => (
        <span key={t} className="tag">
          {t}
        </span>
      ))}
    </div>
  );
}

export function StatusBadge({ c }: { c: Campaign }) {
  return <span className={`badge ${c.status}`}>{c.status}</span>;
}

export function CampaignCard({ c }: { c: Campaign }) {
  return (
    <Link to={`/campanhas/${c.id}`} className="card campaign-card">
      <div className="row between">
        <h3>{c.nome}</h3>
        <StatusBadge c={c} />
      </div>
      <p className="muted">
        Mestre: {c.mestre.nome} · {c.vagas_restantes}/{c.vagas_total} vagas
      </p>
      <p className="clamp">{c.descricao}</p>
      <Tags tags={c.tags} />
    </Link>
  );
}

export function CampaignList({ items, empty }: { items: Campaign[]; empty: string }) {
  if (!items.length) return <p className="muted center">{empty}</p>;
  return (
    <div className="grid">
      {items.map((c) => (
        <CampaignCard key={c.id} c={c} />
      ))}
    </div>
  );
}

export function Status({ loading, error }: { loading: boolean; error: string | null }) {
  if (loading) return <p className="muted center">Carregando…</p>;
  if (error) return <p className="error center">{error}</p>;
  return null;
}
