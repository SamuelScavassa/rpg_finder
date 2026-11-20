import { FormEvent, useEffect, useRef, useState } from "react";
import { api, chatUrl, ChatMessage } from "../api";
import { useAuth } from "../auth";
import { Avatar } from "./common";

const merge = (a: ChatMessage[], b: ChatMessage[]) => {
  const byId = new Map<number, ChatMessage>();
  [...a, ...b].forEach((m) => byId.set(m.id, m));
  return [...byId.values()].sort((x, y) => x.id - y.id);
};

export function Chat({ campaignId, readOnly = false }: { campaignId: number; readOnly?: boolean }) {
  const { user } = useAuth();
  const [msgs, setMsgs] = useState<ChatMessage[]>([]);
  const [text, setText] = useState("");
  const [online, setOnline] = useState(false);
  const ws = useRef<WebSocket | null>(null);
  const bottom = useRef<HTMLDivElement>(null);

  useEffect(() => {
    api.messages(campaignId).then((h) => setMsgs((prev) => merge(prev, h))).catch(() => {});
    if (readOnly) return;
    const socket = new WebSocket(chatUrl(campaignId));
    ws.current = socket;
    socket.onopen = () => setOnline(true);
    socket.onclose = () => setOnline(false);
    socket.onmessage = (e) => setMsgs((prev) => merge(prev, [JSON.parse(e.data) as ChatMessage]));
    return () => socket.close();
  }, [campaignId, readOnly]);

  useEffect(() => {
    bottom.current?.scrollIntoView({ behavior: "smooth" });
  }, [msgs]);

  const send = (e: FormEvent) => {
    e.preventDefault();
    const texto = text.trim();
    if (!texto || ws.current?.readyState !== WebSocket.OPEN) return;
    ws.current.send(JSON.stringify({ texto }));
    setText("");
  };

  return (
    <section className="card chat">
      <h3>
        Chat {!readOnly && <small className={online ? "ok" : "muted"}>{online ? "● online" : "○ conectando…"}</small>}
      </h3>
      <div className="messages">
        {msgs.length === 0 && <p className="muted center">Nenhuma mensagem ainda</p>}
        {msgs.map((m) => (
          <div key={m.id} className={`msg ${m.user.id === user?.id ? "mine" : ""}`}>
            <Avatar user={m.user} size={28} />
            <div>
              <strong>{m.user.nome}</strong>
              <span className="muted"> · {new Date(m.criado_em).toLocaleTimeString("pt-BR", { hour: "2-digit", minute: "2-digit" })}</span>
              <p>{m.texto}</p>
            </div>
          </div>
        ))}
        <div ref={bottom} />
      </div>
      {!readOnly && (
        <form className="row" onSubmit={send}>
          <input value={text} onChange={(e) => setText(e.target.value)} placeholder="Digite uma mensagem" maxLength={2000} />
          <button disabled={!online || !text.trim()}>Enviar</button>
        </form>
      )}
    </section>
  );
}
