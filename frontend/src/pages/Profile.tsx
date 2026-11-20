import { FormEvent, useState } from "react";
import { api } from "../api";
import { useAuth } from "../auth";
import { errMsg } from "../hooks";

const AVATARS = ["avatar01.jpg", "avatar02.jpg", "avatar03.jpg"];

/** Une as telas "user-home" e "user-update" do app Flutter. */
export function Profile() {
  const { user, refresh } = useAuth();
  const [nome, setNome] = useState(user!.nome);
  const [email, setEmail] = useState(user!.email);
  const [avatar, setAvatar] = useState(user!.avatar.split("/").pop() ?? AVATARS[0]);
  const [msg, setMsg] = useState<{ text: string; ok: boolean } | null>(null);

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    try {
      await api.updateMe({ nome: nome.trim(), email: email.trim(), avatar });
      await refresh();
      setMsg({ text: "Perfil atualizado", ok: true });
    } catch (err) {
      setMsg({ text: errMsg(err), ok: false });
    }
  };

  return (
    <form className="card form" onSubmit={submit}>
      <h2>Atualizar perfil</h2>
      <div className="row avatars">
        {AVATARS.map((a) => (
          <button
            type="button"
            key={a}
            className={`avatar-choice ${a === avatar ? "active" : ""}`}
            onClick={() => setAvatar(a)}
            aria-label={a}
          >
            <img src={`/images/${a}`} alt="" width={72} height={72} />
          </button>
        ))}
      </div>
      <label>Nome<input required value={nome} onChange={(e) => setNome(e.target.value)} /></label>
      <label>E-mail<input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} /></label>
      {msg && <p className={msg.ok ? "ok" : "error"}>{msg.text}</p>}
      <button>Atualizar</button>
    </form>
  );
}
