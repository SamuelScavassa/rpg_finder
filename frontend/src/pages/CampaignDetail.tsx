import { useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import { api } from "../api";
import { useAuth } from "../auth";
import { Chat } from "../components/Chat";
import { Avatar, Status, StatusBadge, Tags } from "../components/common";
import { errMsg, useLoad } from "../hooks";

export function CampaignDetail() {
  const id = Number(useParams().id);
  const { user } = useAuth();
  const navigate = useNavigate();
  const { data: c, loading, error, setData } = useLoad(() => api.campaign(id), [id]);
  const [msg, setMsg] = useState<{ text: string; ok: boolean } | null>(null);

  if (!c || !user) return <Status loading={loading} error={error} />;

  const isMestre = c.mestre.id === user.id;
  const isMember = c.membros.some((m) => m.id === user.id);
  const finished = c.status === "finalizada";

  const run = async (action: () => Promise<unknown>, okText: string, after?: () => void) => {
    try {
      await action();
      setMsg({ text: okText, ok: true });
      after?.();
    } catch (e) {
      setMsg({ text: errMsg(e), ok: false });
    }
  };
  const update = (next: Awaited<ReturnType<typeof api.campaign>>) => setData(next);

  return (
    <>
      <section className="card">
        <div className="row between">
          <h2>{c.nome}</h2>
          <StatusBadge c={c} />
        </div>
        <p className="muted">
          Mestre: <Avatar user={c.mestre} size={20} /> {c.mestre.nome} · Vagas restantes: {c.vagas_restantes}/{c.vagas_total}
        </p>
        <p className="pre">{c.descricao || "Sem descrição"}</p>
        <Tags tags={c.tags} />
        {c.discord && (isMestre || isMember) && (
          <p>
            Discord: <a href={c.discord} target="_blank" rel="noreferrer noopener">{c.discord}</a>
          </p>
        )}

        <h3>Jogadores</h3>
        {c.membros.length === 0 && <p className="muted">Nenhum jogador ainda</p>}
        <ul className="members">
          {c.membros.map((m) => (
            <li key={m.id} className="row between">
              <span><Avatar user={m} size={28} /> {m.nome}</span>
              {isMestre && !finished && (
                <button
                  className="danger small"
                  onClick={() =>
                    window.confirm(`Remover ${m.nome} da campanha?`) &&
                    run(() => api.kickMember(c.id, m.id).then(update), "Jogador removido")
                  }
                >
                  Remover
                </button>
              )}
            </li>
          ))}
        </ul>

        {msg && <p className={msg.ok ? "ok" : "error"}>{msg.text}</p>}

        <div className="row actions">
          {!isMestre && !isMember && c.status === "aberta" && (
            <button onClick={() => run(() => api.sendInvite(c.id), "Convite enviado!")}>Pedir para entrar</button>
          )}
          {!isMestre && !isMember && c.status !== "aberta" && <p className="muted">Esta campanha não está aceitando jogadores.</p>}
          {isMember && !finished && (
            <button
              className="danger"
              onClick={() =>
                window.confirm("Sair desta campanha?") &&
                run(() => api.leaveCampaign(c.id), "Você saiu da campanha", () => navigate("/minhas?papel=jogador"))
              }
            >
              Sair da campanha
            </button>
          )}
          {isMestre && !finished && (
            <>
              <Link to={`/campanhas/${c.id}/editar`} className="btn">Editar</Link>
              <button
                onClick={() =>
                  window.confirm("Finalizar a campanha? Ela irá para o histórico e não aceitará mais jogadores.") &&
                  run(() => api.finishCampaign(c.id).then(update), "Campanha finalizada")
                }
              >
                Finalizar
              </button>
            </>
          )}
          {isMestre && (
            <button
              className="danger"
              onClick={() =>
                window.confirm("Apagar a campanha definitivamente? Convites e mensagens também serão apagados.") &&
                run(() => api.deleteCampaign(c.id), "Campanha apagada", () => navigate("/minhas"))
              }
            >
              Apagar
            </button>
          )}
        </div>
      </section>

      {(isMestre || isMember) && <Chat campaignId={c.id} readOnly={finished} />}
    </>
  );
}
