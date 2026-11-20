import { FormEvent, useState } from "react";
import { Link, Navigate, useNavigate } from "react-router-dom";
import { useAuth } from "../auth";
import { errMsg } from "../hooks";

export function Login() {
  const { user, login } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [senha, setSenha] = useState("");
  const [show, setShow] = useState(false);
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  if (user) return <Navigate to="/" replace />;

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    setBusy(true);
    setError("");
    try {
      await login(email.trim(), senha);
      navigate("/");
    } catch (err) {
      setError(errMsg(err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="auth">
      <img src="/images/Logo.png" alt="RPG Finder" height={100} />
      <form onSubmit={submit}>
        <label>
          E-mail
          <input type="email" required maxLength={100} value={email} onChange={(e) => setEmail(e.target.value)} />
        </label>
        <label>
          Senha
          <div className="row">
            <input type={show ? "text" : "password"} required value={senha} onChange={(e) => setSenha(e.target.value)} />
            <button type="button" className="link" onClick={() => setShow(!show)}>{show ? "Ocultar" : "Mostrar"}</button>
          </div>
        </label>
        {error && <p className="error">{error}</p>}
        <button disabled={busy}>{busy ? "Entrando…" : "Login"}</button>
      </form>
      <p>
        Não tem conta? <Link to="/cadastro">Crie agora.</Link>
      </p>
    </div>
  );
}
