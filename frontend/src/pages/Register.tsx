import { FormEvent, useState } from "react";
import { Link, Navigate, useNavigate } from "react-router-dom";
import { useAuth } from "../auth";
import { errMsg } from "../hooks";

export function Register() {
  const { user, register } = useAuth();
  const navigate = useNavigate();
  const [nome, setNome] = useState("");
  const [email, setEmail] = useState("");
  const [senha, setSenha] = useState("");
  const [confirma, setConfirma] = useState("");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  if (user) return <Navigate to="/" replace />;

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    if (senha !== confirma) return setError("As senhas não conferem");
    setBusy(true);
    setError("");
    try {
      await register(nome.trim(), email.trim(), senha);
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
        <label>Nome<input required maxLength={120} value={nome} onChange={(e) => setNome(e.target.value)} /></label>
        <label>E-mail<input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} /></label>
        <label>Senha (mín. 6 caracteres)<input type="password" required minLength={6} value={senha} onChange={(e) => setSenha(e.target.value)} /></label>
        <label>Confirme sua senha<input type="password" required value={confirma} onChange={(e) => setConfirma(e.target.value)} /></label>
        {error && <p className="error">{error}</p>}
        <button disabled={busy}>{busy ? "Criando…" : "Cadastre-se"}</button>
      </form>
      <p>
        Já tem conta? <Link to="/login">Entrar</Link>
      </p>
    </div>
  );
}
