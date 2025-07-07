"use client";

import { useState } from "react";




export default function Home() {
  const [tipoAlmacenamiento, setTipoAlmacenamiento] = useState<string>("");
  const [ficha, setFicha] = useState<any>(null);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    const formData = new FormData(e.currentTarget);

    const response = await fetch("/api/fichas", {
      method: "POST",
      body: formData,
    });

    const data = await response.json();
    setFicha(data.ficha);

    
    
  };

  // Todas las categorías útiles actuales y posibles futuras:
  const categorias = [
    { codigo: "HC", nombre: "Historias y costumbres" },
    { codigo: "DP", nombre: "Documentos públicos y transparencia" },
    { codigo: "SP", nombre: "Salud pública" },
    { codigo: "MR", nombre: "Mapas y recursos gráficos" },
    { codigo: "PD", nombre: "Planes de desarrollo" },
    { codigo: "PR", nombre: "Polémicas y resoluciones" },
    { codigo: "RE", nombre: "Recursos estadísticos" },
    { codigo: "AM", nombre: "Archivos musicales" },
    { codigo: "PC", nombre: "Protección civil" },
    { codigo: "LM", nombre: "Leyes estatales y municipales" },
    { codigo: "ED", nombre: "Educación y cultura" },
    { codigo: "DC", nombre: "Derechos civiles y humanos" },
    { codigo: "TS", nombre: "Textos científicos o técnicos" },
    { codigo: "AR", nombre: "Artículos periodísticos" },
    { codigo: "OB", nombre: "Obras literarias o artísticas" },
    { codigo: "JU", nombre: "Jurisprudencia y leyes federales" }
  ];

  const formatos = [
    "PDF",
    "MD",
    "HTML",
    "JPG",
    "PNG",
    "MP3",
    "DOCX",
    "XLSX",
    "JSON",
    "CSV",
    "TXT"
  ];

  return (
    <main style={{
      display: "flex",
      flexDirection: "column",
      minHeight: "100vh",
      backgroundColor: "#f5f5f5",
    }}>
      <div style={{
        maxWidth: "700px",
        margin: "2rem auto",
        background: "#f9f9f9",
        padding: "2rem",
        borderRadius: "8px",
        boxShadow: "0 0 10px rgba(0,0,0,0.1)",
        color: "#222",
        flex: 1
      }}>
        <h1 style={{
          textAlign: "center",
          marginBottom: "2rem",
          color: "#222"
        }}>
          Nueva Ficha - Aenergy Core
        </h1>

        {!ficha && (
          <form onSubmit={handleSubmit} encType="multipart/form-data">
            <label style={styles.label}>Autor</label>
            <input type="text" name="autor" required style={styles.input} />

            <label style={styles.label}>Título</label>
            <input type="text" name="titulo" required style={styles.input} />

            <label style={styles.label}>Año</label>
            <input type="number" name="anio" required style={styles.input} />

            <label style={styles.label}>Categoría</label>
            <select name="categoria_codigo" required style={styles.input}>
              <option value="">-- Selecciona una categoría --</option>
              {categorias.map((cat) => (
                <option key={cat.codigo} value={cat.codigo}>
                  {cat.nombre}
                </option>
              ))}
            </select>

            <label style={styles.label}>Formato</label>
            <select name="formato" required style={styles.input}>
              <option value="">-- Selecciona un formato --</option>
              {formatos.map((fmt) => (
                <option key={fmt} value={fmt}>{fmt}</option>
              ))}
            </select>

            <label style={styles.label}>
              ¿El archivo es interno o externo?
            </label>
            <div style={{ display: "flex", gap: "1rem" }}>
              <label style={{ color: "#222" }}>
                <input
                  type="radio"
                  name="tipo_almacenamiento"
                  value="interno"
                  onChange={() => setTipoAlmacenamiento("interno")}
                  required
                />{" "}
                Interno
              </label>
              <label style={{ color: "#222" }}>
                <input
                  type="radio"
                  name="tipo_almacenamiento"
                  value="externo"
                  onChange={() => setTipoAlmacenamiento("externo")}
                  required
                />{" "}
                Externo
              </label>
            </div>

            {tipoAlmacenamiento === "externo" && (
              <>
                <label style={styles.label}>URL del archivo externo</label>
                <input type="url" name="url_blob" style={styles.input} />
              </>
            )}

            {tipoAlmacenamiento === "interno" && (
              <>
                <label style={styles.label}>Archivo a subir</label>
                <input
                  type="file"
                  name="archivo"
                  style={styles.input}
                  accept={formatos.map(f => `.${f.toLowerCase()}`).join(",")}
                />
              </>
            )}

            <button type="submit" style={styles.button}>
              Generar Ficha
            </button>
          </form>
        )}

        {ficha && (
          <div style={{ marginTop: "2rem" }}>
            <h2 style={{ color: "#0050b3" }}>🌟 ¡Ficha creada! 🌟</h2>
            <p style={{ marginTop: "1rem", fontStyle: "italic" }}>
              “¡Éxito! Tu archivo se ha subido correctamente a la Estantería. ¡Gracias por contribuir al conocimiento colectivo!”
            
              <br />
             ↻ Recarga la página para crear una nueva ficha . 
            </p>

            <ul style={{ marginTop: "1rem", lineHeight: "1.8" }}>
              <li><strong>Folio:</strong> {ficha.folio}</li>
              <li><strong>Autor:</strong> {ficha.autor}</li>
              <li><strong>Título:</strong> {ficha.titulo}</li>
              <li><strong>Categoría:</strong> {ficha.categoria}</li>
              <li><strong>Año:</strong> {ficha.anio}</li>
              <li><strong>Formato:</strong> {ficha.formato}</li>
              {ficha.url_azure_blob && (
                <li>
                  <strong>Archivo:</strong>{" "}
                  <a href={ficha.url_azure_blob} target="_blank" rel="noreferrer">
                    {ficha.url_azure_blob}
                  </a>
                </li>
              )}
            </ul>

            <h3 style={{ marginTop: "2rem" }}>🗄️ JSON generado:</h3>
            <pre style={{
              background: "#333",
              color: "#eee",
              padding: "1rem",
              borderRadius: "4px",
              fontSize: "0.8rem",
              overflowX: "auto"
            }}>
              {JSON.stringify(ficha, null, 2)}
            </pre>
          </div>
        )}
      </div>

      <footer style={{
        textAlign: "center",
        background: "#222",
        color: "#eee",
        padding: "1.5rem 1rem",
        fontSize: "0.9rem",
        marginTop: "2rem"
      }}>
        Generado con{" "}
        <strong style={{ color: "#00bfff" }}> Proyecto Aenergy V2.0. "Rocket Puncher"</strong> · Insielab Holdings · Con el ❤️ desde Papalotla de Xicohténcatl
        <br />
        <em>Estantería Digital de Papalotla.</em>
      </footer>
    </main>
  );
}

const styles = {
  input: {
    width: "100%",
    padding: "0.5rem",
    marginTop: "0.3rem",
    border: "1px solid #ccc",
    borderRadius: "4px",
    color: "#222",
    backgroundColor: "#fff",
  },
  label: {
    display: "block",
    marginTop: "1rem",
    fontWeight: "bold",
    color: "#222",
  },
  button: {
    background: "#007BFF",
    color: "white",
    padding: "0.75rem 1.5rem",
    border: "none",
    borderRadius: "4px",
    marginTop: "2rem",
    width: "100%",
    cursor: "pointer",
    fontSize: "1rem",
  },
};
