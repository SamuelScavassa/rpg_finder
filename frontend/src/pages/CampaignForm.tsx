import { FormEvent, useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { api } from "../api";
import { TagInput } from "../components/TagInput";
import { errMsg } from "../hooks";

/** Criação (/campanhas/nova) e edição (/campanhas/:id/editar). */
export function CampaignForm() {
  const { id } = useParams();
  const editing = id !== undefined;
  const navigate = useNavigate();

  const [nome, setNome] = useState("");
  const [descricao, setDescricao] = useState("");
  const [discord, setDiscord] = useState("");
  const [vagas, setVagas] = useState(3);
  const [tags, setTags] = useState<string[]>([]);
  const [minVagas, setMinVagas] = useState(1);
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    if (!editing) return;
    api
      .campaign(Number(id))
      .then((c) => {
        setNome(c.nome);
        setDescricao(c.descricao);
        setDiscord(c.discord);
        setVagas(c.vagas_total);
        setTags(c.tags);
        setMinVagas(Math.max(1, c.membros.length));
      })
      .catch((e) => setError(errMsg(e)));
  }, [editing, id]);

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    setBusy(true);
    setError("");
    const body = { nome: nome.trim(), descricao, discord, vagas_total: vagas, tags };
    try {
      const c = editing ? await api.updateCampaign(Number(id), body) : await api.createCampaign(body);
      navigate(`/campanhas/${c.id}`);
    } catch (err) {
      setError(errMsg(err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form className="card form" onSubmit={submit}>
      <h2>{editing ? "Editar campanha" : "Criação de campanha"}</h2>
      <label>
        Nome da campanha
        <input required maxLength={120} value={nome} onChange={(e) => setNome(e.target.value)} placeholder="Digite o nome da campanha" />
      </label>
      <label>
        Descrição da campanha
        <textarea rows={5} value={descricao} onChange={(e) => setDescricao(e.target.value)} placeholder="Descrição da campanha" />
      </label>
      <label>
        Link Discord
        <input value={discord} onChange={(e) => setDiscord(e.target.value)} placeholder="discord.gg/seu-convite" />
      </label>
      <label>
        Número de jogadores
        <input type="number" required min={minVagas} max={100} value={vagas} onChange={(e) => setVagas(Number(e.target.value))} />
      </label>
      <label>
        Tags
        <TagInput tags={tags} onChange={setTags} />
      </label>
      {error && <p className="error">{error}</p>}
      <button disabled={busy}>{editing ? "Salvar" : "Criar campanha"}</button>
    </form>
  );
}
