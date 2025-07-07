"use client";

import { useEffect, useState } from "react";
import Head from "next/head";
import Link from "next/link";

export default function BuscadorPage() {
  const [fichas, setFichas] = useState<any[]>([]);
  const [busqueda, setBusqueda] = useState<string>("");

  useEffect(() => {
    fetch("/api/buscador")
      .then((res) => {
        if (!res.ok) {
          throw new Error("Error al obtener las fichas");
        }
        return res.text();
      })
      .then((text) => {
        if (!text) {
          setFichas([]);
          return;
        }
        const data = JSON.parse(text);
        setFichas(data.fichas || []);
      })
      .catch((err) => {
        console.error(err);
        setFichas([]);
      });
  }, []);

  const resultados = fichas.filter(
    (ficha) =>
      ficha.titulo?.toLowerCase().includes(busqueda.toLowerCase()) ||
      ficha.autor?.toLowerCase().includes(busqueda.toLowerCase())
  );

  return (
    <>
      <Head>
        <title>Buscador · Estantería Digital de Papalotla</title>
        <meta
          name="description"
          content="Busca fichas en la Estantería Digital de Papalotla"
        />
      </Head>

      <main style={styles.main}>
        <h1 style={styles.h1}>Buscador de Fichas</h1>

        <input
          type="text"
          placeholder="Buscar por título o autor..."
          value={busqueda}
          onChange={(e) => setBusqueda(e.target.value)}
          style={styles.input}
        />

        <ul style={styles.list}>
          {resultados.map((ficha) => (
            <li key={ficha.folio} style={styles.item}>
              <strong>{ficha.titulo}</strong> <br />
              <em>{ficha.autor}</em> <br />
              <Link href={ficha.url} target="_blank" style={styles.link}>
                Ver JSON →
              </Link>
            </li>
          ))}

          {resultados.length === 0 && (
            <li style={styles.noResults}>
              No hay resultados para tu búsqueda.
            </li>
          )}
        </ul>

        <Link href="/">
          <button style={styles.button}>← Volver al inicio</button>
        </Link>
      </main>
    </>
  );
}

const styles = {
  main: {
    maxWidth: "800px",
    margin: "2rem auto",
    background: "#f9f9f9",
    padding: "2rem",
    borderRadius: "8px",
    boxShadow: "0 0 10px rgba(0,0,0,0.1)",
    color: "#222",
  },
  h1: {
    textAlign: "center" as const,
    color: "#0050b3",
    marginBottom: "1.5rem",
  },
  input: {
    width: "100%",
    padding: "0.75rem",
    borderRadius: "4px",
    border: "1px solid #ccc",
    marginBottom: "2rem",
    fontSize: "1rem",
  },
  list: {
    listStyle: "none",
    padding: 0,
  },
  item: {
    background: "#fff",
    padding: "1rem",
    marginBottom: "1rem",
    borderRadius: "4px",
    boxShadow: "0 0 5px rgba(0,0,0,0.1)",
  },
  link: {
    color: "#007BFF",
    textDecoration: "underline",
    fontWeight: "bold",
  },
  noResults: {
    textAlign: "center" as const,
    fontStyle: "italic" as const,
    color: "#888",
    marginTop: "2rem",
  },
  button: {
    background: "#007BFF",
    color: "white",
    padding: "0.75rem 1.5rem",
    border: "none",
    borderRadius: "4px",
    marginTop: "2rem",
    cursor: "pointer",
    fontSize: "1rem",
  },
};
