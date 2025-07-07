import { NextRequest, NextResponse } from "next/server";
import fs from "fs";
import path from "path";

export async function POST(req: NextRequest) {
  const formData = await req.formData();

  const autor = formData.get("autor") as string;
  const titulo = formData.get("titulo") as string;
  const anio = formData.get("anio") as string;
  const codigo_categoria = formData.get("categoria_codigo") as string;
  const formato = formData.get("formato") as string;
  const tipo_almacenamiento = formData.get("tipo_almacenamiento") as string;
  const url_blob_manual = formData.get("url_blob") as string | null;

  const iniciales = autor
    .split(" ")
    .map((w) => w[0])
    .join("")
    .toUpperCase()
    .replace(/[^A-Z0-9]/g, "");

  const palabra_titulo = titulo
    .split(" ")[0]
    ?.normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^0-9A-Za-z]/g, "") || "SinTitulo";

  const folio = `${anio}0101-${iniciales}-${palabra_titulo}-${codigo_categoria}`;

  const CATEGORIAS: Record<string, string> = {
    HC: "Historias y costumbres",
    DP: "Documentos públicos y transparencia",
    SP: "Salud pública",
    MR: "Mapas y recursos gráficos",
    PD: "Planes de desarrollo",
    PR: "Polémicas y resoluciones",
    RE: "Recursos estadísticos",
    AM: "Archivos musicales",
    PC: "Protección civil",
    LM: "Leyes estatales y municipales",
    ED: "Educación y cultura",
    DC: "Derechos civiles y humanos",
    TS: "Textos científicos o técnicos",
    AR: "Artículos periodísticos",
    OB: "Obras literarias o artísticas",
    JU: "Jurisprudencia y leyes federales"
  };

  const ficha = {
    folio,
    autor,
    titulo,
    anio,
    categoria: CATEGORIAS[codigo_categoria] || "Desconocida",
    codigo_categoria,
    formato,
    tipo_almacenamiento,
    url_azure_blob: tipo_almacenamiento === "externo" ? url_blob_manual : null,
    creado_por: "Proyecto aenergy",
    fecha_de_registro: new Date().toISOString(),
    descripcion: "Ficha generada automáticamente para la Estantería Digital de Papalotla.",
    version_ficha: "1.3"
  };

  // ✅ Guardar localmente
  const fichasDir = path.join(process.cwd(), "public", "fichas");
  fs.mkdirSync(fichasDir, { recursive: true });

  const filePath = path.join(fichasDir, `${ficha.folio}.json`);
  fs.writeFileSync(filePath, JSON.stringify(ficha, null, 2));

  return NextResponse.json({
    mensaje: "Ficha creada correctamente",
    ficha
  });
}
