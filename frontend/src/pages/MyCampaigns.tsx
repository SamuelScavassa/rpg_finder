import { useSearchParams } from "react-router-dom";
import { api } from "../api";
import { CampaignList, Status } from "../components/common";
import { useLoad } from "../hooks";

/** Substitui as telas "campanhas ativas" (mestre) e "participando" (jogador). */
export function MyCampaigns() {
  const [params, setParams] = useSearchParams();
  const papel = params.get("papel") === "jogador" ? "jogador" : "mestre";
  const { data, loading, error } = useLoad(() => api.myCampaigns({ papel }), [papel]);

  return (
    <>
      <div className="tabs">
        <button className={papel === "mestre" ? "active" : ""} onClick={() => setParams({ papel: "mestre" })}>
          Como mestre
        </button>
        <button className={papel === "jogador" ? "active" : ""} onClick={() => setParams({ papel: "jogador" })}>
          Participando
        </button>
      </div>
      <Status loading={loading} error={error} />
      {data && (
        <CampaignList
          items={data}
          empty={papel === "mestre" ? "Você ainda não criou nenhuma campanha" : "Você não participa de nenhuma campanha"}
        />
      )}
    </>
  );
}
