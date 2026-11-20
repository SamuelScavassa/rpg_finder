import { FormEvent, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { api } from "../api";
import { CampaignList, Status } from "../components/common";
import { useLoad } from "../hooks";

export function Feed() {
  const [params, setParams] = useSearchParams();
  const q = params.get("q") ?? "";
  const [text, setText] = useState(q);
  const { data, loading, error } = useLoad(() => api.campaigns(q), [q]);

  const search = (e: FormEvent) => {
    e.preventDefault();
    setParams(text.trim() ? { q: text.trim() } : {});
  };

  return (
    <>
      <form className="row search" onSubmit={search}>
        <input
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder="Encontre seu RPG aqui (tags separadas por espaço)"
        />
        <button>Buscar</button>
      </form>
      {q && <h2>Resultados para “{q}”</h2>}
      <Status loading={loading} error={error} />
      {data && (
        <CampaignList
          items={data}
          empty={q ? "Nenhuma campanha encontrada para essas tags" : "Nenhuma campanha aberta no momento"}
        />
      )}
    </>
  );
}
