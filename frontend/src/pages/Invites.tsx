import { useState } from "react";
import { Link } from "react-router-dom";
import { api } from "../api";
import { Avatar, Status } from "../components/common";
import { errMsg, useLoad } from "../hooks";

/** Convites pendentes nas campanhas em que sou mestre. */
export function Invites() {
  const { data, loading, error, reload } = useLoad(() => api.myInvites(), []);
  const [msg, setMsg] = useState("");

  const answer = async (id: number, accept: boolean) => {
    setMsg("");
    try {
      if (accept) await api.acceptInvite(id);
      else await api.rejectInvite(id);
    } catch (e) {
      setMsg(errMsg(e)); // ex.: campanha sem vagas
    }
    reload();
  };

  return (
    <>
      <h2>Convites</h2>
      <Status loading={loading} error={error} />
      {msg && <p className="error">{msg}</p>}
      {data && data.length === 0 && <p className="muted center">Nenhum convite pendente</p>}
      {data?.map((i) => (
        <div key={i.id} className="card row between">
          <div>
            <Avatar user={i.user} size={32} /> <strong>{i.user.nome}</strong> quer entrar em{" "}
            <Link to={`/campanhas/${i.campaign_id}`}>{i.campaign_nome}</Link>
          </div>
          <div className="row">
            <button className="small" onClick={() => answer(i.id, true)}>Aceitar</button>
            <button className="danger small" onClick={() => answer(i.id, false)}>Recusar</button>
          </div>
        </div>
      ))}
    </>
  );
}
