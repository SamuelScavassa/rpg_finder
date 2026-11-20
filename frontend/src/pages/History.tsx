import { api } from "../api";
import { CampaignList, Status } from "../components/common";
import { useLoad } from "../hooks";

export function History() {
  const { data, loading, error } = useLoad(() => api.myCampaigns({ finalizadas: true }), []);
  return (
    <>
      <h2>Histórico de campanhas</h2>
      <Status loading={loading} error={error} />
      {data && <CampaignList items={data} empty="Nenhuma campanha finalizada ainda" />}
    </>
  );
}
