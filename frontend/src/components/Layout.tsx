import { Link, NavLink, Navigate, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../auth";
import { Avatar } from "./common";

/** Rotas privadas: redireciona para o login se não houver sessão. */
export function Layout() {
  const { user, loading, logout } = useAuth();
  const navigate = useNavigate();

  if (loading) return <p className="muted center">Carregando…</p>;
  if (!user) return <Navigate to="/login" replace />;

  return (
    <>
      <header className="topbar">
        <Link to="/" className="brand">
          <img src="/images/Logo.png" alt="" height={32} /> RPG Finder
        </Link>
        <nav>
          <NavLink to="/" end>Feed</NavLink>
          <NavLink to="/minhas">Minhas campanhas</NavLink>
          <NavLink to="/convites">Convites</NavLink>
          <NavLink to="/historico">Histórico</NavLink>
        </nav>
        <div className="row">
          <Link to="/campanhas/nova" className="btn small">+ Criar campanha</Link>
          <Link to="/perfil" title="Perfil"><Avatar user={user} size={32} /></Link>
          <button
            className="link"
            onClick={() => {
              logout();
              navigate("/login");
            }}
          >
            Sair
          </button>
        </div>
      </header>
      <main className="container">
        <Outlet />
      </main>
    </>
  );
}
