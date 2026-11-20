import { Navigate, Route, Routes } from "react-router-dom";
import { Layout } from "./components/Layout";
import { CampaignDetail } from "./pages/CampaignDetail";
import { CampaignForm } from "./pages/CampaignForm";
import { Feed } from "./pages/Feed";
import { History } from "./pages/History";
import { Invites } from "./pages/Invites";
import { Login } from "./pages/Login";
import { MyCampaigns } from "./pages/MyCampaigns";
import { Profile } from "./pages/Profile";
import { Register } from "./pages/Register";

export function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/cadastro" element={<Register />} />

      <Route element={<Layout />}>
        <Route index element={<Feed />} />
        <Route path="/campanhas/nova" element={<CampaignForm />} />
        <Route path="/campanhas/:id" element={<CampaignDetail />} />
        <Route path="/campanhas/:id/editar" element={<CampaignForm />} />
        <Route path="/minhas" element={<MyCampaigns />} />
        <Route path="/convites" element={<Invites />} />
        <Route path="/historico" element={<History />} />
        <Route path="/perfil" element={<Profile />} />
      </Route>

      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}
